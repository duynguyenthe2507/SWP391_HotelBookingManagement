package Dao;

import Models.BookingDetail;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDetailDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(BookingDetailDao.class.getName());
    private Connection daoConnection;
    private boolean isConnectionExternal;

    public BookingDetailDao() {
        super();
        this.daoConnection = super.connection;
        this.isConnectionExternal = false;
    }

    public BookingDetailDao(Connection externalConnection) {
        if (externalConnection == null) {
            LOGGER.log(Level.SEVERE, "BookingDetailDao initialized with a NULL external connection!");
            throw new IllegalArgumentException("External connection cannot be null for BookingDetailDao");
        }
        this.daoConnection = externalConnection;
        this.isConnectionExternal = true;
    }

    private BookingDetail mapResultSetToBookingDetail(ResultSet rs) throws SQLException {
        BookingDetail detail = new BookingDetail();
        detail.setBookingDetailId(rs.getInt("bookingDetailId"));
        detail.setBookingId(rs.getInt("bookingId"));
        detail.setRoomId(rs.getInt("roomId"));
        detail.setPriceAtBooking(rs.getDouble("priceAtBooking"));
        detail.setGuestCount(rs.getInt("guestCount"));
        detail.setSpecialRequest(rs.getString("specialRequest"));
        return detail;
    }

    public boolean insertBookingDetail(BookingDetail detail) throws SQLException {
        String sql = "INSERT INTO BookingDetail(bookingId, roomId, priceAtBooking, guestCount, specialRequest, createdAt, updatedAt) "
                   + "VALUES (?,?,?,?,?,?,?)";
        Connection connToUse = this.daoConnection;

        if (connToUse == null || connToUse.isClosed()) {
             LOGGER.log(Level.SEVERE, "Connection is null or closed in insertBookingDetail (isExternal={0}). Cannot proceed.", isConnectionExternal);
             throw new SQLException("Database connection is not available for insertBookingDetail.");
        }

        try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
            ps.setInt(1, detail.getBookingId());
            ps.setInt(2, detail.getRoomId());
            ps.setDouble(3, detail.getPriceAtBooking());
            ps.setInt(4, detail.getGuestCount());
            ps.setString(5, detail.getSpecialRequest());
            ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            ps.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));

            int result = ps.executeUpdate();
            boolean success = result > 0;
            
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, String.format("[%s] SQL error in insertBookingDetail for bookingId: %d, roomId: %d",
                       isConnectionExternal ? "Transaction" : "Standalone", detail.getBookingId(), detail.getRoomId()), e);
            e.printStackTrace();
            throw e;
        }
    }

     @Deprecated
    public boolean insertBookingDetail(BookingDetail detail, Connection conn) throws SQLException {
         LOGGER.log(Level.WARNING, "Deprecated insertBookingDetail(detail, conn) called. Use constructor injection.");
         if (conn == null || conn.isClosed()) {
              throw new SQLException("Connection passed to deprecated insertBookingDetail is null or closed.");
         }
         this.daoConnection = conn;
         this.isConnectionExternal = true;
         return insertBookingDetail(detail);
    }

    private Connection getReadableConnection() throws SQLException {
        if (!isConnectionExternal && (daoConnection == null || daoConnection.isClosed())) {
            DBContext tempDb = new DBContext();
            Connection tempConn = tempDb.getConnection();
            if (tempConn == null || tempConn.isClosed()) {
                throw new SQLException("Failed to create temporary connection for read operation.");
            }
            return tempConn; // Trả về connection mới
        }
         // Nếu là external, hoặc internal vẫn còn mở, dùng daoConnection
        if (daoConnection == null || daoConnection.isClosed()) {
             throw new SQLException("Connection is not available for read operation.");
        }
        return daoConnection;
    }
    
    private void closeReadableConnection(Connection conn) {
        // Chỉ đóng nếu nó không phải là connection do constructor quản lý
        if (conn != this.daoConnection) { 
            try {
                if (conn != null && !conn.isClosed()) {
                     conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing temporary readable connection", e);
            }
        }
    }


    public List<BookingDetail> getBookingDetailsByBookingId(int bookingId) {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingDetail WHERE bookingId=? ORDER BY bookingDetailId";
        Connection connToUse = null;
        try {
            connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapResultSetToBookingDetail(rs));
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getBookingDetailsByBookingId for bookingId: " + bookingId, e);
            e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getBookingDetailsByBookingId", e);
             e.printStackTrace();
        } finally {
             closeReadableConnection(connToUse);
        }
        return list;
    }

     public BookingDetail getBookingDetailById(int bookingDetailId) {
         String sql = "SELECT * FROM BookingDetail WHERE bookingDetailId=?";
         Connection connToUse = null;
         BookingDetail detail = null;
         try {
             connToUse = getReadableConnection();
             try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                 ps.setInt(1, bookingDetailId);
                 try (ResultSet rs = ps.executeQuery()) {
                     if (rs.next()) {
                         detail = mapResultSetToBookingDetail(rs);
                     }
                 }
             }
         } catch (SQLException e) {
             LOGGER.log(Level.SEVERE, "SQL error in getBookingDetailById for ID: " + bookingDetailId, e);
              e.printStackTrace();
         } catch (Exception e) {
              LOGGER.log(Level.SEVERE, "Error getting connection in getBookingDetailById", e);
              e.printStackTrace();
         } finally {
              closeReadableConnection(connToUse);
         }
         return detail;
     }

       public List<BookingDetail> getBookingDetailsWithRoomInfo(int bookingId) {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT bd.*, r.name as roomName, r.imgUrl as roomImgUrl, r.price as currentPrice, " +
                     "c.name as categoryName " +
                     "FROM BookingDetail bd " +
                     "JOIN Room r ON bd.roomId = r.roomId " +
                     "JOIN Category c ON r.categoryId = c.categoryId " +
                     "WHERE bd.bookingId=? " +
                     "ORDER BY bd.bookingDetailId";
         Connection connToUse = null;
         try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        BookingDetail detail = mapResultSetToBookingDetail(rs);
                         detail.setRoomName(rs.getString("roomName"));
                         detail.setRoomImgUrl(rs.getString("roomImgUrl"));
                        list.add(detail);
                    }
                }
            }
         } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getBookingDetailsWithRoomInfo for bookingId: " + bookingId, e);
             e.printStackTrace();
         } catch (Exception e) {
              LOGGER.log(Level.SEVERE, "Error getting connection in getBookingDetailsWithRoomInfo", e);
              e.printStackTrace();
         } finally {
              closeReadableConnection(connToUse);
         }
        return list;
    }

      public boolean updateBookingDetail(BookingDetail detail) throws SQLException {
        String sql = "UPDATE BookingDetail SET bookingId=?, roomId=?, priceAtBooking=?, guestCount=?, specialRequest=?, updatedAt=? WHERE bookingDetailId=?";
        Connection connToUse = this.daoConnection;

        if (connToUse == null || connToUse.isClosed()) {
            LOGGER.log(Level.SEVERE, "Connection is null or closed in updateBookingDetail (isExternal={0}). Cannot proceed.", isConnectionExternal);
            throw new SQLException("Database connection is not available for updateBookingDetail.");
        }

        try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
            ps.setInt(1, detail.getBookingId());
            ps.setInt(2, detail.getRoomId());
            ps.setDouble(3, detail.getPriceAtBooking());
            ps.setInt(4, detail.getGuestCount());
            ps.setString(5, detail.getSpecialRequest());
            ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(7, detail.getBookingDetailId());

            int result = ps.executeUpdate();
            boolean success = result > 0;
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, String.format("[%s] SQL error in updateBookingDetail for ID: %d",
                       isConnectionExternal ? "Transaction" : "Standalone", detail.getBookingDetailId()), e);
            throw e;
        }
    }

     public boolean deleteBookingDetail(int bookingDetailId) throws SQLException {
        String sql = "DELETE FROM BookingDetail WHERE bookingDetailId=?";
        Connection connToUse = this.daoConnection;

        if (connToUse == null || connToUse.isClosed()) {
             LOGGER.log(Level.SEVERE, "Connection is null or closed in deleteBookingDetail (isExternal={0}). Cannot proceed.", isConnectionExternal);
             throw new SQLException("Database connection is not available for deleteBookingDetail.");
        }

        try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
            ps.setInt(1, bookingDetailId);
            int result = ps.executeUpdate();
            boolean success = result > 0;
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, String.format("[%s] SQL error in deleteBookingDetail for ID: %d",
                       isConnectionExternal ? "Transaction" : "Standalone", bookingDetailId), e);
            throw e;
        }
    }

     public List<Integer> getRoomIdsByBookingId(int bookingId) {
        List<Integer> roomIds = new ArrayList<>();
        String sql = "SELECT roomId FROM BookingDetail WHERE bookingId=?";
        Connection connToUse = null;
        try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) { roomIds.add(rs.getInt("roomId")); }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getRoomIdsByBookingId for bookingId: " + bookingId, e);
             e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getRoomIdsByBookingId", e);
             e.printStackTrace();
        } finally {
            closeReadableConnection(connToUse);
        }
        return roomIds;
    }

     public int countBookingDetailsByBookingId(int bookingId) {
        String sql = "SELECT COUNT(*) FROM BookingDetail WHERE bookingId=?";
        Connection connToUse = null;
        int count = 0;
        try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) { count = rs.getInt(1); }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in countBookingDetailsByBookingId for bookingId: " + bookingId, e);
             e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in countBookingDetailsByBookingId", e);
             e.printStackTrace();
        } finally {
            closeReadableConnection(connToUse);
        }
        return count;
    }

     public double getTotalPriceFromDetails(int bookingId) {
         String sql = "SELECT SUM(priceAtBooking) FROM BookingDetail WHERE bookingId=?";
         Connection connToUse = null;
        double totalPrice = 0.0;
         try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) { totalPrice = rs.getDouble(1); }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getTotalPriceFromDetails for bookingId: " + bookingId, e);
             e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getTotalPriceFromDetails", e);
             e.printStackTrace();
        } finally {
            closeReadableConnection(connToUse);
        }
        return totalPrice;
     }

     public int getTotalGuestCount(int bookingId) {
        String sql = "SELECT SUM(guestCount) FROM BookingDetail WHERE bookingId=?";
        Connection connToUse = null;
        int totalGuests = 0;
         try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) { totalGuests = rs.getInt(1); }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getTotalGuestCount for bookingId: " + bookingId, e);
             e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getTotalGuestCount", e);
             e.printStackTrace();
        } finally {
            closeReadableConnection(connToUse);
        }
        return totalGuests;
    }

     public boolean isRoomInBooking(int bookingId, int roomId) {
        String sql = "SELECT COUNT(*) FROM BookingDetail WHERE bookingId=? AND roomId=?";
        Connection connToUse = null;
        boolean exists = false;
        try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, roomId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) { exists = rs.getInt(1) > 0; }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in isRoomInBooking for bookingId: " + bookingId + ", roomId: " + roomId, e);
             e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in isRoomInBooking", e);
             e.printStackTrace();
        } finally {
            closeReadableConnection(connToUse);
        }
        return exists;
    }

      public List<BookingDetail> getAllBookingDetails() {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingDetail ORDER BY bookingId, bookingDetailId";
        Connection connToUse = null;
         try {
             connToUse = getReadableConnection();
            try (PreparedStatement ps = connToUse.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBookingDetail(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getAllBookingDetails", e);
             e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getAllBookingDetails", e);
             e.printStackTrace();
        } finally {
            closeReadableConnection(connToUse);
        }
        return list;
    }
}

