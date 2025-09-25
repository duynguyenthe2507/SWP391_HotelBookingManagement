package DAO;

import Models.Feedback;
import java.sql.*;
import java.util.*;

public class FeedbackDao extends DBContext {

    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        return new Feedback(
                rs.getInt("feedbackId"),
                rs.getInt("userId"),
                rs.getInt("bookingId"),
                rs.getString("content"),
                rs.getInt("rating"),
                rs.getTimestamp("created_at").toLocalDateTime()
        );
    }

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedback";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToFeedback(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Feedback getFeedbackById(int id) {
        String sql = "SELECT * FROM Feedback WHERE feedbackId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToFeedback(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addFeedback(Feedback f) {
        String sql = "INSERT INTO Feedback(userId, bookingId, content, rating) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, f.getUserId());
            ps.setInt(2, f.getBookingId());
            ps.setString(3, f.getContent());
            ps.setInt(4, f.getRating());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteFeedback(int id) {
        String sql = "DELETE FROM Feedback WHERE feedbackId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
