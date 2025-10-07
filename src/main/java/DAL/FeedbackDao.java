package DAL;

import Models.Feedback;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class FeedbackDao extends DBContext {

    private Feedback map(ResultSet rs) throws SQLException {
        return new Feedback(
                rs.getInt("feedbackId"),
                rs.getInt("userId"),
                rs.getInt("bookingId"),
                rs.getInt("rating"),
                rs.getString("comment"),
                rs.getTimestamp("createdAt").toLocalDateTime()
        );
    }

    public List<Feedback> getAll() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedback";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Feedback> getByBookingId(int bookingId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedback WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Feedback f) {
        String sql = "INSERT INTO Feedback(userId, bookingId, rating, comment) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, f.getUserId());
            ps.setInt(2, f.getBookingId());
            ps.setInt(3, f.getRating());
            ps.setString(4, f.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Feedback f) {
        String sql = "UPDATE Feedback SET rating=?, comment=? WHERE feedbackId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, f.getRating());
            ps.setString(2, f.getComment());
            ps.setInt(3, f.getFeedbackId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Feedback WHERE feedbackId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
