package DAO;

import Models.Wishlist;
import java.sql.*;
import java.util.*;

public class WishlistDao extends DBContext {

    private Wishlist mapResultSetToWishlist(ResultSet rs) throws SQLException {
        return new Wishlist(
                rs.getInt("wishlistId"),
                rs.getInt("userId"),
                rs.getInt("roomId")
        );
    }

    public List<Wishlist> getWishlistByUser(int userId) {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT * FROM Wishlist WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToWishlist(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean addWishlist(Wishlist w) {
        String sql = "INSERT INTO Wishlist(userId, roomId) VALUES (?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, w.getUserId());
            ps.setInt(2, w.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean removeWishlist(int wishlistId) {
        String sql = "DELETE FROM Wishlist WHERE wishlistId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, wishlistId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean removeWishlistByUserAndRoom(int userId, int roomId) {
        String sql = "DELETE FROM Wishlist WHERE userId=? AND roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
