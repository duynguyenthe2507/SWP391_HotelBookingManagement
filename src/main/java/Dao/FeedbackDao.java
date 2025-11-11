package Dao;

import Models.Feedback;
import Utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeedbackDao extends DBContext {
    
    private static final Logger LOGGER = Logger.getLogger(FeedbackDao.class.getName());
    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedbackId"));
        feedback.setUserId(rs.getInt("userId"));
        feedback.setBookingId(rs.getInt("bookingId"));
        feedback.setContent(rs.getString("content"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        feedback.setUserFirstName(rs.getString("firstName"));
        feedback.setUserLastName(rs.getString("lastName"));
        feedback.setUserAvatarUrl(rs.getString("avatar_url"));
        
        return feedback;
    }
    public List<Feedback> getReviewsByRoomId(int roomId, int limit) {
        List<Feedback> feedbackList = new ArrayList<>();
        // Truy vấn JOIN 3 bảng: Feedback -> Booking -> Users
        String sql = "SELECT TOP (?) f.*, u.firstName, u.lastName, u.avatar_url " +
                     "FROM Feedback f " +
                     "JOIN Booking b ON f.bookingId = b.bookingId " +
                     "JOIN Users u ON f.userId = u.userId " +
                     "WHERE b.roomId = ? " +
                     "ORDER BY f.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, roomId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapFeedback(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting reviews for room " + roomId, e);
        }
        return feedbackList;
    }
    public Feedback addReview(Feedback feedback) {
        String sql = "INSERT INTO Feedback (userId, bookingId, content, rating, created_at, updatedAt) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, feedback.getUserId());
            ps.setInt(2, feedback.getBookingId());
            ps.setString(3, feedback.getContent());
            ps.setInt(4, feedback.getRating());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        feedback.setFeedbackId(rs.getInt(1));
                        return getReviewById(feedback.getFeedbackId());
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new review", e);
        }
        return null;
    }

    public Feedback getReviewById(int feedbackId) {
        String sql = "SELECT f.*, u.firstName, u.lastName, u.avatar_url " +
                     "FROM Feedback f " +
                     "JOIN Users u ON f.userId = u.userId " +
                     "WHERE f.feedbackId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFeedback(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting review by ID " + feedbackId, e);
        }
        return null;
    }

    public Feedback getReviewByBookingId(int bookingId) {
        String sql = "SELECT f.*, u.firstName, u.lastName, u.avatar_url " +
                     "FROM Feedback f " +
                     "JOIN Users u ON f.userId = u.userId " +
                     "WHERE f.bookingId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFeedback(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting review by Booking ID " + bookingId, e);
        }
        return null;
    }
}