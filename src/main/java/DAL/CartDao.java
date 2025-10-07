package DAL;

import Models.Cart;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class CartDao extends DBContext {

    private Cart map(ResultSet rs) throws SQLException {
        return new Cart(
                rs.getInt("cartId"),
                rs.getInt("userId"),
                rs.getInt("roomId"),
                rs.getInt("quantity"),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }

    public List<Cart> getAll() {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT * FROM Cart";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Cart> getByUserId(int userId) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT * FROM Cart WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Cart c) {
        String sql = "INSERT INTO Cart(userId, roomId, quantity) VALUES (?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, c.getUserId());
            ps.setInt(2, c.getRoomId());
            ps.setInt(3, c.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Tránh lỗi duplicate
            if (!e.getMessage().contains("duplicate")) e.printStackTrace();
        }
        return false;
    }

    public boolean updateQuantity(int cartId, int quantity) {
        String sql = "UPDATE Cart SET quantity=? WHERE cartId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Cart WHERE cartId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
