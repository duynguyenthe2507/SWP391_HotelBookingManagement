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

public class BookingDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(BookingDao.class.getName());

    public BookingDao(Connection externalConnection) {
        super(externalConnection);
        LOGGER.log(Level.INFO, "BookingDao initialized with an external connection.");
    }

    public BookingDao() {
        super();
        LOGGER.log(Level.INFO, "BookingDao initialized with its own connection.");
    }

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
                rs.getTimestamp("updatedAt") != null ? rs.getTimestamp("updatedAt").toLocalDateTime() : null
        );
    }

    // ============ OFFLINE BOOKING METHODS (from haitn/pushOfflineBooking) ============
    
    public int insertOfflineBooking(Booking booking) {
        String sql = "INSERT INTO Booking (guestName, receptionistId, roomId, checkinTime, checkoutTime, " +
                "guestCount, specialRequest, totalPrice, status, createdAt) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, booking.getGuestName());
            ps.setObject(2, booking.getReceptionistId());
            ps.setInt(3, booking.getRoomId());
            ps.setTimestamp(4, Timestamp.valueOf(booking.getCheckinTime()));
            ps.setTimestamp(5, Timestamp.valueOf(booking.getCheckoutTime()));
            ps.setInt(6, booking.getGuestCount());
            ps.setString(7, booking.getSpecialRequest());
            ps.setDouble(8, booking.getTotalPrice());
            ps.setString(9, "Pending");

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
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.*, r.name as roomName, (u_guest.firstName + ' ' + u_guest.lastName) as guestCustomerName " +
                        "FROM Booking b " +
                        "JOIN Room r ON b.roomId = r.roomId " +
                        "LEFT JOIN Users u_guest ON b.userId = u_guest.userId " +
                        "WHERE 1=1 "
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
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("booking", mapResultSetToBooking(rs));
                    map.put("roomName", rs.getString("roomName"));
                    map.put("customerName", rs.getString("guestName") != null ? rs.getString("guestName") : rs.getString("guestCustomerName"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding bookings", e);
        }
        return list;
    }

    public int countBookings(String status, String checkIn, String keyword) {
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) " +
                        "FROM Booking b " +
                        "JOIN Room r ON b.roomId = r.roomId " +
                        "LEFT JOIN Users u_guest ON b.userId = u_guest.userId " +
                        "WHERE 1=1 "
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
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting bookings", e);
        }
        return 0;
    }

    public Map<String, Object> getBookingDetailsById(int bookingId) {
        Map<String, Object> details = new HashMap<>();
        String sql = "SELECT b.*, r.*, " +
                "r.name as roomName, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt, " +
                "(u_guest.firstName + ' ' + u_guest.lastName) as guestUsername, " +
                "(u_rep.firstName + ' ' + u_rep.lastName) as receptionistUsername " +
                "FROM Booking b " +
                "JOIN Room r ON b.roomId = r.roomId " +
                "JOIN Category c ON r.categoryId = c.categoryId " +
                "LEFT JOIN [User] u_guest ON b.userId = u_guest.userId " +
                "LEFT JOIN [User] u_rep ON b.receptionistId = u_rep.userId " +
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

    // ============ ONLINE BOOKING METHODS (from dev branch) ============

    public boolean insertBookingWithDetails(Booking booking, List<BookingDetail> details) {
        String bookingSql = "INSERT INTO Booking(userId, checkinTime, checkoutTime, durationHours, status, totalPrice, createdAt, updatedAt) "
                + "VALUES (?,?,?,?,?,?,?,?)";

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
                LOGGER.log(Level.INFO, "Transaction started internally for creating booking for user {0}.", booking.getUserId());
            } else {
                LOGGER.log(Level.INFO, "Participating in external transaction for creating booking for user {0}.", booking.getUserId());
            }

            try (PreparedStatement psInsertBooking = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                psInsertBooking.setInt(1, booking.getUserId());
                psInsertBooking.setTimestamp(2, Timestamp.valueOf(booking.getCheckinTime()));
                psInsertBooking.setTimestamp(3, Timestamp.valueOf(booking.getCheckoutTime()));
                psInsertBooking.setDouble(4, booking.getDurationHours());
                psInsertBooking.setString(5, booking.getStatus());
                psInsertBooking.setDouble(6, booking.getTotalPrice());
                psInsertBooking.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
                psInsertBooking.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));

                LOGGER.log(Level.INFO, "Executing insert booking statement...");
                int affectedRows = psInsertBooking.executeUpdate();

                if (affectedRows == 0) throw new SQLException("Inserting booking failed, no rows affected.");

                try (ResultSet generatedKeys = psInsertBooking.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        booking.setBookingId(generatedKeys.getInt(1));
                        LOGGER.log(Level.INFO, "Booking inserted successfully with generated ID: {0}", booking.getBookingId());
                    } else {
                        throw new SQLException("Inserting booking failed, no ID obtained.");
                    }
                }
            }

            BookingDetailDao bookingDetailDao = new BookingDetailDao(conn);

            for (BookingDetail detail : details) {
                detail.setBookingId(booking.getBookingId());
                LOGGER.log(Level.INFO, "Attempting to insert booking detail for roomId {0}, bookingId {1}", new Object[]{detail.getRoomId(), booking.getBookingId()});
                boolean detailInserted = bookingDetailDao.insertBookingDetail(detail);

                if (!detailInserted) {
                    throw new SQLException("Inserting booking detail failed for roomId " + detail.getRoomId());
                }

                if ("pending".equalsIgnoreCase(booking.getStatus()) || "confirmed".equalsIgnoreCase(booking.getStatus())) {
                    LOGGER.log(Level.INFO, "Attempting to update room {0} status to 'booked'", detail.getRoomId());
                    boolean roomStatusUpdated = updateRoomStatusDirect(detail.getRoomId(), "booked", conn);
                    if (!roomStatusUpdated) {
                        throw new SQLException("Updating room status to 'booked' failed for roomId " + detail.getRoomId());
                    }
                }
            }

            if (!isExternalConn) {
                LOGGER.log(Level.INFO, "Committing internally managed transaction for booking {0}...", booking.getBookingId());
                conn.commit();
            } else {
                LOGGER.log(Level.INFO, "Inserts successful within external transaction for booking {0}. Commit handled externally.", booking.getBookingId());
            }
            return true;

        } catch (SQLException e) {
            System.out.println("!!!!!!!!!!!!!! SQLException caught in BookingDao.insertBookingWithDetails !!!!!!!!!!!!!!");
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
                LOGGER.log(Level.SEVERE, "Error in finally block of insertBookingWithDetails while restoring autoCommit", e);
            }
        }
    }

    public boolean updateBookingStatus(int bookingId, String newStatus) {
        String sql = "UPDATE Booking SET status=?, updatedAt=? WHERE bookingId=?";
        Connection conn = null;
        boolean originalAutoCommit = true;
        boolean isExternalConn = super.isConnectionManagedExternally();

        try {
            conn = this.connection;
            if (conn == null || conn.isClosed()) return false;

            if (!isExternalConn) {
                originalAutoCommit = conn.getAutoCommit();
                conn.setAutoCommit(false);
            }

            int affectedRows = 0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setInt(3, bookingId);
                affectedRows = ps.executeUpdate();
            }

            if (affectedRows > 0) {
                List<Integer> roomIds = getRoomIdsByBookingId(bookingId, conn);

                if ("cancelled".equalsIgnoreCase(newStatus) || "completed".equalsIgnoreCase(newStatus)) {
                    for (int roomId : roomIds) {
                        if (!hasActiveBookingsForRoom(roomId, bookingId, conn)) {
                            if (!updateRoomStatusDirect(roomId, "available", conn))
                                throw new SQLException("Failed to update room status to available for roomId " + roomId);
                        }
                    }
                } else if ("confirmed".equalsIgnoreCase(newStatus) || "pending".equalsIgnoreCase(newStatus)) {
                    for (int roomId : roomIds) {
                        if (!updateRoomStatusDirect(roomId, "booked", conn))
                            throw new SQLException("Failed to update room status to booked for roomId " + roomId);
                    }
                }

                if (!isExternalConn) conn.commit();
                return true;
            } else {
                if (!isExternalConn) conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            System.out.println("!!!!!!!!!!!!!! SQLException caught in BookingDao.updateBookingStatus !!!!!!!!!!!!!!");
            LOGGER.log(Level.SEVERE, "SQL Exception during updateBookingStatus for BookingID: " + bookingId, e);
            e.printStackTrace();
            if (!isExternalConn && conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "CRITICAL ERROR: Could not rollback!", ex);
                }
            }
            return false;
        } finally {
            try {
                if (!isExternalConn && conn != null && !conn.isClosed()) {
                    conn.setAutoCommit(originalAutoCommit);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error in finally block of updateBookingStatus", e);
            }
        }
    }

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

    private List<Integer> getRoomIdsByBookingId(int bookingId, Connection conn) throws SQLException {
        List<Integer> roomIds = new ArrayList<>();
        String sql = "SELECT roomId FROM BookingDetail WHERE bookingId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) roomIds.add(rs.getInt("roomId"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Transaction] SQL Error getting room IDs for booking " + bookingId, e);
            throw e;
        }
        return roomIds;
    }

    private boolean hasActiveBookingsForRoom(int roomId, int excludeBookingId, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BookingDetail bd " +
                "JOIN Booking b ON bd.bookingId = b.bookingId " +
                "WHERE bd.roomId = ? AND b.status IN ('pending', 'confirmed') " +
                "AND b.checkoutTime > ? AND b.bookingId != ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, excludeBookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Transaction] SQL Error checking active bookings for room " + roomId, e);
            throw e;
        }
        return true;
    }

    // ============ COMMON METHODS ============

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToBooking(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int id) {
        String sql = "SELECT * FROM Booking WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToBooking(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE userId=? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addBooking(Booking b) {
        String sql = "INSERT INTO Booking(userId, roomId, checkinTime, checkoutTime, guestCount, status, totalPrice, createdAt) "
                + "VALUES (?,?,?,?,?,?,?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(4, Timestamp.valueOf(b.getCheckoutTime()));
            ps.setInt(5, b.getGuestCount());
            ps.setString(6, b.getStatus());
            ps.setDouble(7, b.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

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

    public boolean isRoomBookedDuringDates(int roomId, LocalDateTime checkIn, LocalDateTime checkOut) {
        String sql = "SELECT COUNT(bd.bookingDetailId) FROM BookingDetail bd " +
                "JOIN Booking b ON bd.bookingId = b.bookingId " +
                "WHERE bd.roomId = ? " +
                "AND b.status IN ('pending', 'confirmed') " +
                "AND b.checkinTime < ? AND b.checkoutTime > ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, Timestamp.valueOf(checkOut));
            ps.setTimestamp(3, Timestamp.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    public List<Booking> getBookingsByStatus(String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE status=? ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getUpcomingBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE checkinTime > ? AND status IN ('pending', 'confirmed') ORDER BY checkinTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getCurrentBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE checkinTime <= ? AND checkoutTime > ? AND status = 'confirmed' ORDER BY checkinTime ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            ps.setTimestamp(1, now);
            ps.setTimestamp(2, now);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}