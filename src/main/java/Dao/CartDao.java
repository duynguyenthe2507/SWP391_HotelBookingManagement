package Dao;

import Models.Cart;
import Models.CartItem;
import Utils.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDao extends DBContext {

    public List<CartItem> getCartByUserId(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.cartId, c.userId, c.quantity, r.roomId, r.name as roomName, r.price, r.imgUrl as roomImgUrl " +
                "FROM Cart c " +
                "JOIN Room r ON c.roomId = r.roomId " +
                "WHERE c.userId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId); // gán userId vào
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem(
                            rs.getInt("cartId"),
                            rs.getInt("userId"),
                            rs.getInt("quantity"),
                            rs.getInt("roomId"),
                            rs.getString("roomName"),
                            rs.getDouble("price"),
                            rs.getString("roomImgUrl")
                    );
                    cartItems.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM Cart WHERE cartId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Cart getCartItemByUserAndRoom(int userId, int roomId) {
        String sql = "SELECT * FROM Cart WHERE userId = ? AND roomId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Cart(
                            rs.getInt("cartId"),
                            rs.getInt("userId"),
                            rs.getInt("roomId"),
                            rs.getInt("quantity"),
                            rs.getTimestamp("updatedAt").toLocalDateTime()
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCartQuantity(int cartId, int newQuantity) {
        String sql = "UPDATE Cart SET quantity = ? WHERE cartId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addToCart(Cart cart) {
        String sql = "INSERT INTO Cart (userId, roomId, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cart.getUserId());
            ps.setInt(2, cart.getRoomId());
            ps.setInt(3, cart.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}