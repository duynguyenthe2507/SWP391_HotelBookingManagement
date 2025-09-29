package DAO;

import Models.Cart;
import java.sql.*;
import java.util.*;

public class CartDao extends DBContext {

    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        return new Cart(
                rs.getInt("cartId"),
                rs.getInt("userId"),
                rs.getInt("roomId"),
                rs.getInt("quantity")
        );
    }

    public List<Cart> getAllCarts() {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT * FROM Cart";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToCart(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Cart getCartById(int id) {
        String sql = "SELECT * FROM Cart WHERE cartId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToCart(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addCart(Cart c) {
        String sql = "INSERT INTO Cart(userId, roomId, quantity) VALUES (?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, c.getUserId());
            ps.setInt(2, c.getRoomId());
            ps.setInt(3, c.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateCart(Cart c) {
        String sql = "UPDATE Cart SET userId=?, roomId=?, quantity=? WHERE cartId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, c.getUserId());
            ps.setInt(2, c.getRoomId());
            ps.setInt(3, c.getQuantity());
            ps.setInt(4, c.getCartId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteCart(int id) {
        String sql = "DELETE FROM Cart WHERE cartId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
