package Dao;

import Models.Wishlist;
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

    public boolean removeFromWishlist(int wishlistId) {
        String sql = "DELETE FROM Wishlist WHERE wishlistId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, wishlistId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Thêm một phòng mới vào danh sách yêu thích của người dùng.
     * @param item Đối tượng Wishlist (chỉ cần userId và roomId)
     * @return true nếu thêm thành công.
     */
    public boolean addToWishlist(Wishlist item) {
        String sql = "INSERT INTO Wishlist (userId, roomId) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getUserId());
            ps.setInt(2, item.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // (Thêm logging)
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra xem một phòng đã tồn tại trong wishlist của người dùng chưa.
     * @param userId ID người dùng
     * @param roomId ID phòng
     * @return true nếu đã tồn tại.
     */
    public boolean checkIfExists(int userId, int roomId) {
        String sql = "SELECT COUNT(*) FROM Wishlist WHERE userId = ? AND roomId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}