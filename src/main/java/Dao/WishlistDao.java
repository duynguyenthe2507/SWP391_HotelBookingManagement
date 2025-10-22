package Dao;

import Models.WishlistItem;
import Utils.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WishlistDao extends DBContext {

    public List<WishlistItem> getWishlistByUserId(int userId) {
        List<WishlistItem> wishlistItems = new ArrayList<>();
        String sql = "SELECT w.wishlistId, w.userId, r.roomId, r.name as roomName, r.price, r.imgUrl as roomImgUrl " +
                "FROM Wishlist w " +
                "JOIN Room r ON w.roomId = r.roomId " +
                "WHERE w.userId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WishlistItem item = new WishlistItem(
                            rs.getInt("wishlistId"),
                            rs.getInt("userId"),
                            rs.getInt("roomId"),
                            rs.getString("roomName"),
                            rs.getDouble("price"),
                            rs.getString("roomImgUrl")
                    );
                    wishlistItems.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return wishlistItems;
    }
}