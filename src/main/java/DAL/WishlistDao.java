package DAL;

import Models.Wishlist;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class WishlistDao extends DBContext {

    private Wishlist map(ResultSet rs) throws SQLException {
        return new Wishlist(
                rs.getInt("wishlistId"),
                rs.getInt("userId"),
                rs.getInt("roomId"),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }

    public List<Wishlist> getAll() {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT * FROM Wishlist";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Wishlist> getByUserId(int userId) {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT * FROM Wishlist WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Wishlist w) {
        String sql = "INSERT INTO Wishlist(userId, roomId) VALUES (?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, w.getUserId());
            ps.setInt(2, w.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Tránh lỗi duplicate (unique constraint)
            if (!e.getMessage().contains("duplicate")) e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int wishlistId) {
        String sql = "DELETE FROM Wishlist WHERE wishlistId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, wishlistId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
