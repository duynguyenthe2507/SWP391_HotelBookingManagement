package Dao;

import Models.Rule;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RuleDao extends DBContext {
    public List<Rule> findRules(String search, Boolean status) {
        List<Rule> list = new ArrayList<>();
        // Sử dụng một List để giữ các tham số cho PreparedStatement
        List<Object> params = new ArrayList<>();

        // Bắt đầu câu SQL
        String sql = "SELECT * FROM Rules WHERE 1=1";

        // 1. Thêm điều kiện TÌM KIẾM (nếu có)
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (title LIKE ? OR description LIKE ?)";
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        // 2. Thêm điều kiện TRẠNG THÁI (nếu có)
        if (status != null) {
            sql += " AND status = ?";
            params.add(status); // Thêm true hoặc false
        }

        sql += " ORDER BY ruleId DESC"; // Sắp xếp

        // Sử dụng try-with-resources cho Connection
        try (Connection conn = new DBContext().connection; // Sử dụng cách kết nối của bạn
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set các tham số vào câu lệnh SQL
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Rule r = new Rule(
                            rs.getInt("ruleId"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getBoolean("status"),
                            rs.getTimestamp("createdAt"),
                            rs.getTimestamp("updatedAt")
                    );
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error findRules: " + e.getMessage());
            e.printStackTrace(); // In chi tiết lỗi
        }
        return list;
    }
    // Lấy tất cả các Rule (cho lễ tân hoặc admin)
    public List<Rule> getAllRules() {
        List<Rule> list = new ArrayList<>();
        String sql = "SELECT * FROM Rules ORDER BY ruleId DESC";

        try (Connection conn = new DBContext().connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Rule r = new Rule(
                        rs.getInt("ruleId"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getBoolean("status"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("updatedAt")
                );
                list.add(r);
            }

        } catch (SQLException e) {
            System.out.println("Error getAllRules: " + e.getMessage());
        }
        return list;
    }

    // Lấy danh sách Rule đang hoạt động (cho người dùng xem)
    public List<Rule> getActiveRules() {
        List<Rule> list = new ArrayList<>();
        String sql = "SELECT * FROM Rules WHERE status = 1 ORDER BY ruleId DESC";

        try (Connection conn = new DBContext().connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Rule r = new Rule(
                        rs.getInt("ruleId"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getBoolean("status"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("updatedAt")
                );
                list.add(r);
            }

        } catch (SQLException e) {
            System.out.println("Error getActiveRules: " + e.getMessage());
        }
        return list;
    }

    // Lấy Rule theo ID
    public Rule getRuleById(int id) {
        String sql = "SELECT * FROM Rules WHERE ruleId = ?";
        try (Connection conn = new DBContext().connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Rule(
                        rs.getInt("ruleId"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getBoolean("status"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("updatedAt")
                );
            }

        } catch (SQLException e) {
            System.out.println("Error getRuleById: " + e.getMessage());
        }
        return null;
    }

    // Thêm mới Rule
    public boolean insertRule(Rule r) {
        String sql = "INSERT INTO Rules (title, description, status, createdAt, updatedAt) VALUES (?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = new DBContext().connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getTitle());
            ps.setString(2, r.getDescription());
            ps.setBoolean(3, r.isStatus());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error insertRule: " + e.getMessage());
        }
        return false;
    }

    // Cập nhật Rule
    public boolean updateRule(Rule r) {
        String sql = "UPDATE Rules SET title=?, description=?, status=?, updatedAt=GETDATE() WHERE ruleId=?";
        try (Connection conn = new DBContext().connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getTitle());
            ps.setString(2, r.getDescription());
            ps.setBoolean(3, r.isStatus());
            ps.setInt(4, r.getRuleId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updateRule: " + e.getMessage());
        }
        return false;
    }

    // Xóa Rule
    public boolean deleteRule(int id) {
        String sql = "DELETE FROM Rules WHERE ruleId = ?";
        try (Connection conn = new DBContext().connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error deleteRule: " + e.getMessage());
        }
        return false;
    }
}
