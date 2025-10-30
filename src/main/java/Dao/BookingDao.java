package Dao;

import Models.Booking;
import Models.BookingDetail;
import Utils.DBContext; 

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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
        Timestamp checkinTimeTs = rs.getTimestamp("checkinTime");
        Timestamp checkoutTimeTs = rs.getTimestamp("checkoutTime");
        Timestamp createdAtTs = rs.getTimestamp("createdAt");
        Timestamp updatedAtTs = rs.getTimestamp("updatedAt");

        return new Booking(
                rs.getInt("bookingId"),
                rs.getInt("userId"),
                checkinTimeTs != null ? checkinTimeTs.toLocalDateTime() : null,
                checkoutTimeTs != null ? checkoutTimeTs.toLocalDateTime() : null,
                rs.getDouble("durationHours"),
                rs.getString("status"),
                rs.getDouble("totalPrice"),
                createdAtTs != null ? createdAtTs.toLocalDateTime() : null,
                updatedAtTs != null ? updatedAtTs.toLocalDateTime() : null
        );
    }

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
            LOGGER.log(Level.SEVERE, "SQL Error Code: {0}", e.getErrorCode());
            LOGGER.log(Level.SEVERE, "SQL State: {0}", e.getSQLState());
            LOGGER.log(Level.SEVERE, "Error Message: {0}", e.getMessage());

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
                try { conn.rollback(); } 
                catch (SQLException ex) { LOGGER.log(Level.SEVERE, "CRITICAL ERROR: Could not rollback!", ex); }
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

     public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY createdAt DESC";
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToBooking(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
     }
     public Booking getBookingById(int id) {
          String sql = "SELECT * FROM Booking WHERE bookingId=?";
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToBooking(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
     }
      public List<Booking> getBookingsByUserId(int userId) {
         List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE userId=? ORDER BY createdAt DESC";
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
     }
      public boolean isRoomBookedDuringDates(int roomId, LocalDateTime checkIn, LocalDateTime checkOut) {
         String sql = "SELECT COUNT(bd.bookingDetailId) FROM BookingDetail bd " +
                     "JOIN Booking b ON bd.bookingId = b.bookingId " +
                     "WHERE bd.roomId = ? " +
                     "AND b.status IN ('pending', 'confirmed') " +
                     "AND b.checkinTime < ? AND b.checkoutTime > ?"; 
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, Timestamp.valueOf(checkOut));
            ps.setTimestamp(3, Timestamp.valueOf(checkIn));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return true; 
     }
      public List<Booking> getBookingsByStatus(String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE status=? ORDER BY createdAt DESC";
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
     }
     public List<Booking> getUpcomingBookings() {
         List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE checkinTime > ? AND status IN ('pending', 'confirmed') ORDER BY checkinTime ASC";
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
     }
     public List<Booking> getCurrentBookings() {
         List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE checkinTime <= ? AND checkoutTime > ? AND status = 'confirmed' ORDER BY checkinTime ASC";
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            ps.setTimestamp(1, now);
            ps.setTimestamp(2, now);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
     }
}

