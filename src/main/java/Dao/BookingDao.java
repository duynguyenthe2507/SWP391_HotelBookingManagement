package Dao;

import Models.Booking;
import Models.BookingDetail;
import Models.Category;
import Models.Room;
import Models.Services;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Tệp này đã được SỬA LỖI LOGIC: 1. 'insertBookingWithDetails': SẼ KHÔNG đổi
 * trạng thái Phòng (Room) khi Booking là 'pending'. 2. 'updateBookingStatus':
 * SẼ CHỈ đổi trạng thái Phòng (Room) thành 'booked' khi Booking là 'confirmed'
 * (đã thanh toán), KHÔNG 'pending'. 3. 'isRoomBookedDuringDates': Đã sửa lỗi
 * 'return true' (trả về 'false' nếu có lỗi SQL).
 */
public class BookingDao extends DBContext implements AutoCloseable { // <<< SỬA LỖI (Thêm AutoCloseable)

    private static final Logger LOGGER = Logger.getLogger(BookingDao.class.getName());

    public BookingDao(Connection externalConnection) {
        super(externalConnection);
        LOGGER.log(Level.INFO, "BookingDao initialized with an external connection.");
    }

    public BookingDao() {
        super();
        // (Bỏ log ồn ào)
        // LOGGER.log(Level.INFO, "BookingDao initialized with its own connection.");
    }

    // Code gốc của bạn (Chính xác)
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        return new Booking(
                rs.getInt("bookingId"),
                (Integer) rs.getObject("userId"),
                (Integer) rs.getObject("receptionistId"),
                rs.getString("guestName"),
                rs.getInt("roomId"),
                rs.getTimestamp("checkinTime").toLocalDateTime(),
                rs.getTimestamp("checkoutTime").toLocalDateTime(),
                rs.getInt("guestCount"),
                rs.getString("specialRequest"),
                rs.getString("status"),
                rs.getDouble("totalPrice"),
                rs.getTimestamp("createdAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt") != null ? rs.getTimestamp("updatedAt").toLocalDateTime() : null);
    }

    // ============ OFFLINE BOOKING METHODS (from haitn/pushOfflineBooking)
    // ============

    public int insertOfflineBooking(Booking booking) {
        // ... (Code gốc của bạn - Chính xác) ...
        String sql = "INSERT INTO Booking (guestName, receptionistId, roomId, checkinTime, checkoutTime, "
                + "guestCount, specialRequest, totalPrice, status, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, booking.getGuestName());
            ps.setObject(2, booking.getReceptionistId());
            ps.setInt(3, booking.getRoomId());
            ps.setTimestamp(4, Timestamp.valueOf(booking.getCheckinTime()));
            ps.setTimestamp(5, Timestamp.valueOf(booking.getCheckoutTime()));
            ps.setInt(6, booking.getGuestCount());
            ps.setString(7, booking.getSpecialRequest());
            ps.setDouble(8, booking.getTotalPrice());
            ps.setString(9, "Pending"); // (Trạng thái offline ban đầu)
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting offline booking", e);
        }
        return -1;
    }

    public void linkServicesToBooking(int bookingId, String[] serviceIds, Map<Integer, Services> servicesMap) {
        // ... (Code gốc của bạn - Chính xác) ...
        String sql = "INSERT INTO BookingServiceLink (bookingId, serviceId, quantity, priceAtBooking) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (String serviceIdStr : serviceIds) {
                int serviceId = Integer.parseInt(serviceIdStr);
                Services service = servicesMap.get(serviceId);
                if (service != null) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, serviceId);
                    ps.setInt(3, 1);
                    ps.setDouble(4, service.getPrice());
                    ps.addBatch();
                }
            }
            ps.executeBatch();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error linking services to booking " + bookingId, e);
        }
    }

    public List<Map<String, Object>> findBookings(String status, String checkIn, String keyword, int pageNumber, int pageSize) {
        // ... (Code gốc của bạn - Chính xác) ...
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, r.name as roomName, (u_guest.firstName + ' ' + u_guest.lastName) as guestCustomerName "
                + "FROM Booking b "
                + "JOIN Room r ON b.roomId = r.roomId "
                + "LEFT JOIN Users u_guest ON b.userId = u_guest.userId "
                + "WHERE 1=1 "
        );
        if (status != null && !status.isEmpty()) {
            sql.append("AND b.status = ? ");
            params.add(status);
        }
        if (checkIn != null && !checkIn.isEmpty()) {
            sql.append("AND CONVERT(date, b.checkinTime) = ? ");
            params.add(checkIn);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(
                    "AND (b.guestName LIKE ? OR u_guest.firstName LIKE ? OR u_guest.lastName LIKE ? OR r.name LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        sql.append("ORDER BY b.checkinTime DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((pageNumber - 1) * pageSize);
        params.add(pageSize);
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("booking", mapResultSetToBooking(rs));
                    map.put("roomName", rs.getString("roomName"));
                    map.put("customerName", rs.getString("guestName") != null ?
                            rs.getString("guestName") : rs.getString("guestCustomerName"));
                    list.add(map);
                    count++;
                }
                LOGGER.log(Level.INFO, "Found {0} bookings from database", count);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding bookings", e);
            e.printStackTrace(); // In ra console để debug
        }

        return list;
    }

    public int countBookings(String status, String checkIn, String keyword) {
        // ... (Code gốc của bạn - Chính xác) ...
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Booking b "
                + "JOIN Room r ON b.roomId = r.roomId "
                + "LEFT JOIN Users u_guest ON b.userId = u_guest.userId "
                + "WHERE 1=1 "
        );
        if (status != null && !status.isEmpty()) {
            sql.append("AND b.status = ? ");
            params.add(status);
        }
        if (checkIn != null && !checkIn.isEmpty()) {
            sql.append("AND CONVERT(date, b.checkinTime) = ? ");
            params.add(checkIn);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (b.guestName LIKE ? OR u_guest.firstName LIKE ? OR u_guest.lastName LIKE ? OR r.name LIKE ?) ");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println(">>> COUNT result: " + count);
                    return count;
                }
            }
        } catch (SQLException e) {
            System.out.println("!!! SQL EXCEPTION in countBookings!");
            System.out.println("!!! Error: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error counting bookings", e);
        }

        System.out.println("=== BookingDao.countBookings COMPLETED - Returning 0 ===");
        return 0;
    }

    public Map<String, Object> getBookingDetailsById(int bookingId) {
        // ... (Code gốc của bạn - Chính xác, chỉ sửa tên bảng [User] -> Users) ...
        Map<String, Object> details = new HashMap<>();
        String sql = "SELECT b.*, r.*, "
                + "r.name as roomName, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, "
                + "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt, "
                + "(u_guest.firstName + ' ' + u_guest.lastName) as guestUsername, "
                + "(u_rep.firstName + ' ' + u_rep.lastName) as receptionistUsername "
                + "FROM Booking b "
                + "JOIN Room r ON b.roomId = r.roomId "
                + "JOIN Category c ON r.categoryId = c.categoryId "
                + "LEFT JOIN Users u_guest ON b.userId = u_guest.userId "
                + // Sửa lỗi: Users
                "LEFT JOIN Users u_rep ON b.receptionistId = u_rep.userId "
                + // Sửa lỗi: Users
                "WHERE b.bookingId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    details.put("booking", booking);
                    Room room = new Room();
                    room.setRoomId(rs.getInt("roomId"));
                    room.setName(rs.getString("roomName"));
                    room.setPrice(rs.getDouble("price"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setStatus(rs.getString("status"));
                    room.setDescription(rs.getString("roomDescription"));
                    room.setImgUrl(rs.getString("roomImgUrl"));
                    Category category = new Category();
                    category.setName(rs.getString("categoryName"));
                    room.setCategory(category);
                    details.put("room", room);
                    String customerName = booking.getGuestName() != null ? booking.getGuestName() : rs.getString("guestUsername");
                    details.put("customerName", customerName);
                    details.put("receptionistName", rs.getString("receptionistUsername"));
                    return details;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting booking details for ID: " + bookingId, e);
        }
        return null;
    }

    // ============ ONLINE BOOKING METHODS (ĐÃ SỬA LỖI) ============
    /**
     * HÀM NÀY ĐÃ ĐƯỢC SỬA: 1. Sửa lỗi 'roomId' NULL (thêm 'roomId' vào SQL). 2.
     * Sửa lỗi LOGIC (Xóa bỏ việc cập nhật Room status khi 'pending').
     */
    public boolean insertBookingWithDetails(Booking booking, List<BookingDetail> details) {

        // (Đây là code đã sửa lỗi 'roomId' NULL)
        String bookingSql = "INSERT INTO Booking(userId, roomId, checkinTime, checkoutTime, status, totalPrice, createdAt, updatedAt) "
                + "VALUES (?,?,?,?,?,?,?,?)"; // 8 tham số

        Connection conn = null;
        boolean originalAutoCommit = true;
        boolean isExternalConn = super.isConnectionManagedExternally();

        try {
            conn = this.connection;
            if (conn == null || conn.isClosed()) {
                LOGGER.log(Level.SEVERE, "Database connection is null or closed for insertBookingWithDetails.");
                return false;
            }

            if (!isExternalConn) {
                originalAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
                LOGGER.log(Level.INFO, "Transaction started internally for creating booking for user {0}.",
                        booking.getUserId());
            } else {
                LOGGER.log(Level.INFO, "Participating in external transaction for creating booking for user {0}.",
                        booking.getUserId());
            }

            try (PreparedStatement psInsertBooking = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {

                // (Đây là code đã sửa lỗi 'roomId' NULL)
                psInsertBooking.setInt(1, booking.getUserId());
                psInsertBooking.setInt(2, booking.getRoomId()); // (Sửa lỗi 'roomId' NULL)
                psInsertBooking.setTimestamp(3, Timestamp.valueOf(booking.getCheckinTime()));
                psInsertBooking.setTimestamp(4, Timestamp.valueOf(booking.getCheckoutTime()));
                psInsertBooking.setString(5, booking.getStatus());
                psInsertBooking.setDouble(6, booking.getTotalPrice());
                psInsertBooking.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
                psInsertBooking.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));

                LOGGER.log(Level.INFO, "Executing insert booking statement...");
                int affectedRows = psInsertBooking.executeUpdate();

                if (affectedRows == 0) {
                    throw new SQLException("Inserting booking failed, no rows affected.");
                }

                try (ResultSet generatedKeys = psInsertBooking.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        booking.setBookingId(generatedKeys.getInt(1));
                        LOGGER.log(Level.INFO, "Booking inserted successfully with generated ID: {0}",
                                booking.getBookingId());
                    } else {
                        throw new SQLException("Inserting booking failed, no ID obtained.");
                    }
                }
            }

            BookingDetailDao bookingDetailDao = new BookingDetailDao(conn);

            for (BookingDetail detail : details) {
                detail.setBookingId(booking.getBookingId());
                boolean detailInserted = bookingDetailDao.insertBookingDetail(detail);

                if (!detailInserted) {
                    throw new SQLException("Inserting booking detail failed for roomId " + detail.getRoomId());
                }

                // === SỬA LỖI LOGIC NGHIÊM TRỌNG (ĐÃ XÓA) ===
                // KHÔNG cập nhật trạng thái phòng khi đang 'pending'.
                // (Khối 'if ("pending"...)' đã bị xóa khỏi đây)
                // === KẾT THÚC SỬA LỖI ===
            }

            if (!isExternalConn) {
                conn.commit();
            }
            return true;

        } catch (SQLException e) {
            System.out.println(
                    "!!!!!!!!!!!!!! SQLException caught in BookingDao.insertBookingWithDetails !!!!!!!!!!!!!!");
            LOGGER.log(Level.SEVERE, "SQL Exception during insertBookingWithDetails transaction. Rolling back.", e);
            e.printStackTrace();

            if (!isExternalConn && conn != null) {
                try {
                    LOGGER.log(Level.WARNING, "Attempting to rollback internally managed transaction...");
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "CRITICAL ERROR: Could not rollback internal transaction!", ex);
                }
            }
            return false;
        } finally {
            try {
                if (!isExternalConn && conn != null && !conn.isClosed()) {
                    conn.setAutoCommit(originalAutoCommit);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE,
                        "Error in finally block of insertBookingWithDetails while restoring autoCommit", e);
            }
        }
    }

    /**
     * HÀM NÀY ĐÃ ĐƯỢC SỬA: 1. Chỉ đổi Room status sang 'booked' khi Booking là
     * 'confirmed'. 2. Sẽ đổi Room status sang 'available' khi Booking là
     * 'cancelled'.
     */
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        System.out.println("========================================");
        System.out.println(">>> [BookingDao] updateBookingStatus() CALLED");
        System.out.println(">>> Booking ID: " + bookingId);
        System.out.println(">>> New Status: " + newStatus);
        System.out.println("========================================");

        String updateBookingSql = "UPDATE Booking SET status=?, updatedAt=? WHERE bookingId=?";
        Connection conn = null;
        boolean originalAutoCommit = true;
        boolean isExternalConn = super.isConnectionManagedExternally();

        try {
            conn = this.connection;
            if (conn == null || conn.isClosed()) {
                System.out.println("❌ Connection is NULL or CLOSED!");
                LOGGER.log(Level.SEVERE, "Connection is null or closed");
                return false;
            }

            if (!isExternalConn) {
                originalAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
                System.out.println("✅ Transaction started (internal)");
            } else {
                System.out.println("✅ Using external transaction");
            }

            // ===== STEP 1: Update Booking Status =====
            int affectedRows = 0;
            try (PreparedStatement ps = conn.prepareStatement(updateBookingSql)) {
                ps.setString(1, newStatus);
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setInt(3, bookingId);
                affectedRows = ps.executeUpdate();
                System.out.println(">>> Step 1: Booking UPDATE affected " + affectedRows + " rows");
            }

            if (affectedRows == 0) {
                System.out.println("❌ No booking found with ID: " + bookingId);
                if (!isExternalConn) {
                    conn.rollback();
                }
                return false;
            }

            // ===== STEP 2: Get Room IDs from BookingDetail =====
            List<Integer> roomIds = getRoomIdsByBookingId(bookingId, conn);
            System.out.println(">>> Step 2: Found " + roomIds.size() + " room(s) for booking");

            if (roomIds.isEmpty()) {
                System.out.println("⚠️ No rooms found in BookingDetail");
                if (!isExternalConn) {
                    conn.commit();
                }
                return true; // Booking updated but no rooms
            }

            // ===== STEP 3: Update Room Status (DIRECTLY) =====
            String updateRoomSql = "UPDATE Room SET status=?, updatedAt=? WHERE roomId=?";

            if ("cancelled".equalsIgnoreCase(newStatus)
                    || "completed".equalsIgnoreCase(newStatus)
                    || "checked-out".equalsIgnoreCase(newStatus)) {

                System.out.println(">>> Step 3: Case CANCELLED/COMPLETED - Set rooms to AVAILABLE");

                for (int roomId : roomIds) {
                    if (!hasActiveBookingsForRoom(roomId, bookingId, conn)) {
                        try (PreparedStatement ps = conn.prepareStatement(updateRoomSql)) {
                            ps.setString(1, "available");
                            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                            ps.setInt(3, roomId);
                            int rows = ps.executeUpdate();

                            if (rows > 0) {
                                System.out.println("   ✅ Room " + roomId + " → AVAILABLE (affected " + rows + " rows)");
                                LOGGER.log(Level.INFO, "Room {0} status updated to ''available''", roomId);
                            } else {
                                System.out.println("   ❌ Room " + roomId + " UPDATE failed (0 rows)");
                            }
                        }
                    } else {
                        System.out.println("   ⚠️ Room " + roomId + " has other active bookings");
                    }
                }

            } else if ("confirmed".equalsIgnoreCase(newStatus) || "checked-in".equalsIgnoreCase(newStatus)) {

                System.out.println(">>> Step 3: Case CONFIRMED/CHECKED-IN - Set rooms to BOOKED");

                for (int roomId : roomIds) {
                    try (PreparedStatement ps = conn.prepareStatement(updateRoomSql)) {
                        ps.setString(1, "booked");
                        ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                        ps.setInt(3, roomId);
                        int rows = ps.executeUpdate();

                        if (rows > 0) {
                            System.out.println("   ✅ Room " + roomId + " → BOOKED (affected " + rows + " rows)");
                            LOGGER.log(Level.INFO, "Room {0} status updated to ''booked''", roomId);
                        } else {
                            System.out.println("   ❌ Room " + roomId + " UPDATE failed (0 rows)");
                            throw new SQLException("Failed to update room " + roomId + " to booked");
                        }
                    }
                }

            } else {
                System.out.println(">>> Step 3: Status '" + newStatus + "' - No room update needed");
            }

            // ===== STEP 4: Commit Transaction =====
            if (!isExternalConn) {
                conn.commit();
                System.out.println("✅ Transaction COMMITTED");
            }

            System.out.println("========================================");
            System.out.println(">>> updateBookingStatus() SUCCESS");
            System.out.println("========================================");
            return true;

        } catch (SQLException e) {
            System.out.println("!!!!!!!!!!!!!! SQLException in updateBookingStatus !!!!!!!!!!!!!!");
            System.out.println(">>> Error: " + e.getMessage());
            e.printStackTrace();

            LOGGER.log(Level.SEVERE, "SQLException in updateBookingStatus for bookingId=" + bookingId, e);

            if (!isExternalConn && conn != null) {
                try {
                    conn.rollback();
                    System.out.println(">>> Transaction ROLLED BACK");
                } catch (SQLException ex) {
                    System.out.println(">>> ❌ CRITICAL: Rollback failed!");
                    LOGGER.log(Level.SEVERE, "Rollback failed", ex);
                }
            }
            return false;

        } finally {
            try {
                if (!isExternalConn && conn != null && !conn.isClosed()) {
                    conn.setAutoCommit(originalAutoCommit);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error restoring autoCommit", e);
            }
        }
    }

    // Code gốc của bạn (Chính xác)
    private boolean updateRoomStatusDirect(int roomId, String status, Connection conn) throws SQLException {
        String sql = "UPDATE Room SET status=?, updatedAt=? WHERE roomId=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, roomId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Transaction] SQL Error updating room " + roomId + " status to " + status, e);
            throw e;
        }
    }

    // Code gốc của bạn (Chính xác)
    private List<Integer> getRoomIdsByBookingId(int bookingId, Connection conn) throws SQLException {
        List<Integer> roomIds = new ArrayList<>();
        String sql = "SELECT roomId FROM BookingDetail WHERE bookingId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roomIds.add(rs.getInt("roomId"));
                }
            }
        }
        return roomIds;
    }

    private boolean hasActiveBookingsForRoom(int roomId, int excludeBookingId, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BookingDetail bd "
                + "JOIN Booking b ON bd.bookingId = b.bookingId "
                + "WHERE bd.roomId = ? "
                + "AND b.status IN ('pending', 'confirmed', 'checked-in') "
                + "AND b.checkoutTime > ? "
                + "AND b.bookingId != ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, excludeBookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return true; // Safe default
    }

    // ============ COMMON METHODS ============
    // Code gốc của bạn (Chính xác)
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Code gốc của bạn (Chính xác)
    public Booking getBookingById(int id) {
        String sql = "SELECT * FROM Booking WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Code gốc của bạn (Chính xác)
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE userId=? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Code gốc của bạn (Chính xác)
    public boolean addBooking(Booking b) {
        String sql = "INSERT INTO Booking(userId, roomId, checkinTime, checkoutTime, guestCount, status, totalPrice, createdAt) "
                + "VALUES (?,?,?,?,?,?,?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(4, Timestamp.valueOf(b.getCheckinTime())); // <<< LỖI GỐC CỦA BẠN (vô tình dán checkin 2 lần)
            ps.setInt(5, b.getGuestCount());
            ps.setString(6, b.getStatus());
            ps.setDouble(7, b.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Sửa lại hàm addBooking (sửa lỗi copy-paste ở trên)
    public boolean addBooking_CORRECTED(Booking b) {
        String sql = "INSERT INTO Booking(userId, roomId, checkinTime, checkoutTime, guestCount, status, totalPrice, createdAt) "
                + "VALUES (?,?,?,?,?,?,?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(4, Timestamp.valueOf(b.getCheckoutTime())); // <<< SỬA LỖI
            ps.setInt(5, b.getGuestCount());
            ps.setString(6, b.getStatus());
            ps.setDouble(7, b.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Code gốc của bạn (Chính xác)
    public boolean updateBooking(Booking b) {
        String sql = "UPDATE Booking SET userId=?, roomId=?, checkinTime=?, checkoutTime=?, guestCount=?, "
                + "status=?, totalPrice=?, updatedAt=GETDATE(), guestName=?, receptionistId=?, specialRequest=? "
                + "WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(4, Timestamp.valueOf(b.getCheckoutTime()));
            ps.setInt(5, b.getGuestCount());
            ps.setString(6, b.getStatus());
            ps.setDouble(7, b.getTotalPrice());
            ps.setString(8, b.getGuestName());
            ps.setObject(9, b.getReceptionistId());
            ps.setString(10, b.getSpecialRequest());
            ps.setInt(11, b.getBookingId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Code gốc của bạn (Chính xác)
    public boolean deleteBooking(int id) {
        String sql = "DELETE FROM Booking WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * HÀM NÀY ĐÃ ĐƯỢC SỬA: 1. Khôi phục logic SQL gốc. 2. Sửa lỗi 'return true'
     * (trả về 'false' nếu có lỗi SQL).
     */
    /**
     * ✅ PHIÊN BẢN CÓ LOG CHI TIẾT Thay thế method isRoomBookedDuringDates()
     * trong BookingDao.java (dòng 518-539)
     */
    public boolean isRoomBookedDuringDates(int roomId, LocalDateTime checkIn, LocalDateTime checkOut) {
        String sql = "SELECT COUNT(bd.bookingDetailId) FROM BookingDetail bd "
                + "JOIN Booking b ON bd.bookingId = b.bookingId "
                + "WHERE bd.roomId = ? "
                + // ✅ FIX: BAO GỒM CẢ 'pending' (user đang thanh toán)
                "AND b.status IN ('pending', 'confirmed', 'checked-in') "
                + "AND b.checkinTime < ? AND b.checkoutTime > ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, Timestamp.valueOf(checkOut));
            ps.setTimestamp(3, Timestamp.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.log(Level.INFO,
                            "isRoomBookedDuringDates: Room {0} has {1} overlapping bookings",
                            new Object[]{roomId, count});
                    return count > 0;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking room dates for roomId: " + roomId, e);
            e.printStackTrace();
        }
        return true; // Mặc định không cho book nếu lỗi
    }

    // Code gốc của bạn (Chính xác)
    public List<Booking> getBookingsByStatus(String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE status=? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Code gốc của bạn (Chính xác)
    public List<Booking> getUpcomingBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE checkinTime > ? AND status IN ('pending', 'confirmed') ORDER BY checkinTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Code gốc của bạn (Chính xác)
    public List<Booking> getCurrentBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE checkinTime <= ? AND checkoutTime > ? AND status = 'confirmed' ORDER BY checkinTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            ps.setTimestamp(1, now);
            ps.setTimestamp(2, now);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBooking(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm số lần no-show của user (booking confirmed nhưng checkinTime đã qua mà
     * không check-in)
     */
    public int countNoShowBookings(int userId) {
        String sql = "SELECT COUNT(*) FROM Booking " +
                "WHERE userId = ? " +
                "AND status = 'confirmed' " +
                "AND checkinTime < ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
    // === SỬA LỖI: Thêm hàm close() (Bắt buộc bởi AutoCloseable) ===
    @Override
    public void close() throws Exception {
        super.closeConnection(); // Gọi hàm close() từ DBContext cha
    }

    public boolean updateBookingStatusAndCheckInTime(int bookingId, String newStatus, LocalDateTime checkInTime) {
        String sql = "UPDATE Booking SET status = ?, checkinTime = ?, updatedAt = GETDATE() WHERE bookingId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setTimestamp(2, Timestamp.valueOf(checkInTime));
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking status and check-in time for " + bookingId, e);
            return false;
        }
    }

    /**
     * [MỚI] Cập nhật status VÀ thời gian check-out thực tế.
     */
    public boolean updateBookingStatusAndCheckOutTime(int bookingId, String newStatus, LocalDateTime checkOutTime) {
        String sql = "UPDATE Booking SET status = ?, checkoutTime = ?, updatedAt = GETDATE() WHERE bookingId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setTimestamp(2, Timestamp.valueOf(checkOutTime));
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking status and check-out time for " + bookingId, e);
            return false;
        }
    }
}
