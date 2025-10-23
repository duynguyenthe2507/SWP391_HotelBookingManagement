package Dao;

import Models.Booking;
import Utils.DBContext;

import java.sql.*;
import java.util.*;

public class BookingDao extends DBContext {

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        return new Booking(
                rs.getInt("bookingId"),
                rs.getInt("userId"),
                rs.getTimestamp("checkinTime").toLocalDateTime(),
                rs.getTimestamp("checkoutTime").toLocalDateTime(),
                rs.getDouble("durationHours"),
                rs.getString("status"),
                rs.getDouble("totalPrice"),
                rs.getTimestamp("createdAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
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
        String sql = "INSERT INTO Booking(userId, checkinTime, checkoutTime, durationHours, status, totalPrice) "
                   + "VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, b.getUserId());
            ps.setTimestamp(2, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckoutTime()));
            ps.setDouble(4, b.getDurationHours());
            ps.setString(5, b.getStatus());
            ps.setDouble(6, b.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateBooking(Booking b) {
        String sql = "UPDATE Booking SET userId=?, checkinTime=?, checkoutTime=?, durationHours=?, "
                   + "status=?, totalPrice=? WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, b.getUserId());
            ps.setTimestamp(2, Timestamp.valueOf(b.getCheckinTime()));
            ps.setTimestamp(3, Timestamp.valueOf(b.getCheckoutTime()));
            ps.setDouble(4, b.getDurationHours());
            ps.setString(5, b.getStatus());
            ps.setDouble(6, b.getTotalPrice());
            ps.setInt(7, b.getBookingId());
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
