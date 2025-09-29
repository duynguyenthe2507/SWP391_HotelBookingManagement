package DAO;

import Models.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao extends DBContext {

    // Lấy tất cả user
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM [User]";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Lấy user theo ID
    public User getUserById(int userId) {
        String sql = "SELECT * FROM [User] WHERE userId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm user mới
    public boolean addUser(User user) {
        String sql = "INSERT INTO [User](mobilePhone, fullName, email, password, role, isBlackList, isActive) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getMobilePhone());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getRole());
            ps.setBoolean(6, user.getIsBlacklist());
            ps.setBoolean(7, user.getIsActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật user
    public boolean updateUser(User user) {
        String sql = "UPDATE [User] SET mobilePhone=?, fullName=?, email=?, password=?, role=?, "
                + "isBlackList=?, isActive=?, updatedAt=GETDATE() WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getMobilePhone());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getRole());
            ps.setBoolean(6, user.getIsBlacklist());
            ps.setBoolean(7, user.getIsActive());
            ps.setInt(8, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa user
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM [User] WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm tiện ích: map từ ResultSet sang User object
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("userId"),
                rs.getString("mobilePhone"),
                rs.getString("fullName"),
                rs.getString("email"),
                rs.getString("password"),
                rs.getString("role"),
                rs.getBoolean("isBlackList"),
                rs.getBoolean("isActive"),
                rs.getTimestamp("createdAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }
}
