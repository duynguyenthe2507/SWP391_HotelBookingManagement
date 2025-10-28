package Dao;

import Models.Booking;
import Models.Services;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(BookingDao.class.getName());

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        return new Booking(
                rs.getInt("bookingId"),
                (Integer) rs.getObject("userId"), // Có thể NULL
                (Integer) rs.getObject("receptionistId"), // Có thể NULL
                rs.getString("guestName"), // Có thể NULL
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
            ps.setString(9, "Pending"); // Mặc định là Pending

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về bookingId
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting offline booking", e);
        }
        return -1; // Thất bại
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
                    ps.setInt(3, 1); // Mặc định số lượng là 1
                    ps.setDouble(4, service.getPrice()); // Lưu giá tại thời điểm đặt
                    ps.addBatch();
                }
            }
            ps.executeBatch();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error linking services to booking " + bookingId, e);
        }
    }

    public boolean updateBookingStatus(int bookingId, String newStatus) {
        String sql = "UPDATE Booking SET status = ?, updatedAt = GETDATE() WHERE bookingId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking status for " + bookingId, e);
            return false;
        }
    }

    public List<Map<String, Object>> findBookings(String status, String checkIn, String keyword, int pageNumber, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.*, r.name as roomName, u_guest.username as guestUsername " +
                        "FROM Booking b " +
                        "JOIN Room r ON b.roomId = r.roomId " +
                        "LEFT JOIN [User] u_guest ON b.userId = u_guest.userId " + // LEFT JOIN cho guest
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
            sql.append("AND (b.guestName LIKE ? OR u_guest.username LIKE ? OR r.name LIKE ?) ");
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
                    map.put("customerName", rs.getString("guestName") != null ? rs.getString("guestName") : rs.getString("guestUsername"));
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
                        "LEFT JOIN [User] u_guest ON b.userId = u_guest.userId " +
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
            sql.append("AND (b.guestName LIKE ? OR u_guest.username LIKE ? OR r.name LIKE ?) ");
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

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToBooking(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Booking getBookingById(int id) {
        String sql = "SELECT * FROM Booking WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToBooking(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addBooking(Booking b) {
        String sql = "INSERT INTO Booking(userId, roomId, checkinTime, checkoutTime, guestCount, status, totalPrice, createdAt) "
                + "VALUES (?,?,?,?,?,?,?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, b.getUserId());
            ps.setInt(2, b.getRoomId());
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(4, Timestamp.valueOf(b.getCheckoutTime()));
            ps.setInt(5, b.getGuestCount());
            ps.setString(6, b.getStatus());
            ps.setDouble(7, b.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
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
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteBooking(int id) {
        String sql = "DELETE FROM Booking WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}