package DAL;

import Models.BookingDetail;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class BookingDetailDao extends DBContext {

    private BookingDetail map(ResultSet rs) throws SQLException {
        return new BookingDetail(
                rs.getInt("bookingDetailId"),
                rs.getInt("bookingId"),
                rs.getInt("roomId"),
                rs.getDouble("priceAtBooking"),
                rs.getInt("guestCount"),
                rs.getString("specialRequest"),
                rs.getTimestamp("createdAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }

    public List<BookingDetail> getAll() {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingDetail";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<BookingDetail> getByBookingId(int bookingId) {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingDetail WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(BookingDetail bd) {
        String sql = "INSERT INTO BookingDetail(bookingId, roomId, priceAtBooking, guestCount, specialRequest) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bd.getBookingId());
            ps.setInt(2, bd.getRoomId());
            ps.setDouble(3, bd.getPriceAtBooking());
            ps.setInt(4, bd.getGuestCount());
            ps.setString(5, bd.getSpecialRequest());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(BookingDetail bd) {
        String sql = "UPDATE BookingDetail SET roomId=?, priceAtBooking=?, guestCount=?, specialRequest=? WHERE bookingDetailId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bd.getRoomId());
            ps.setDouble(2, bd.getPriceAtBooking());
            ps.setInt(3, bd.getGuestCount());
            ps.setString(4, bd.getSpecialRequest());
            ps.setInt(5, bd.getBookingDetailId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM BookingDetail WHERE bookingDetailId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
