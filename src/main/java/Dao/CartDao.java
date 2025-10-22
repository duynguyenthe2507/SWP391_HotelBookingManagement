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
            ps.setInt(1, userId);
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
}