package DAL;

import Models.BookingHistory;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class BookingHistoryDao extends DBContext {

    private BookingHistory map(ResultSet rs) throws SQLException {
        return new BookingHistory(
                rs.getInt("historyId"),
                rs.getInt("bookingId"),
                rs.getString("status"),
                rs.getString("note"),
                rs.getTimestamp("changedAt").toLocalDateTime()
        );
    }

    public List<BookingHistory> getAll() {
        List<BookingHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingHistory";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<BookingHistory> getByBookingId(int bookingId) {
        List<BookingHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingHistory WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(BookingHistory bh) {
        String sql = "INSERT INTO BookingHistory(bookingId, status, note) VALUES (?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bh.getBookingId());
            ps.setString(2, bh.getStatus());
            ps.setString(3, bh.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(BookingHistory bh) {
        String sql = "UPDATE BookingHistory SET status=?, note=? WHERE historyId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, bh.getStatus());
            ps.setString(2, bh.getNote());
            ps.setInt(3, bh.getHistoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM BookingHistory WHERE historyId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
