package Dao;

import Models.Guideline;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuidelineDao extends DBContext { // Kế thừa DBContext
    public List<Guideline> findGuidelines(String search, Boolean status) {
        List<Guideline> list = new ArrayList<>();
        // Sử dụng một List để giữ các tham số cho PreparedStatement
        List<Object> params = new ArrayList<>();

        // Bắt đầu câu SQL
        String sql = "SELECT * FROM ServiceGuideline WHERE 1=1";

        // 1. Thêm điều kiện TÌM KIẾM (nếu có)
        // Tìm trong cả title và content [cite: 150]
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (title LIKE ? OR content LIKE ?)";
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        // 2. Thêm điều kiện TRẠNG THÁI (nếu có)
        if (status != null) {
            sql += " AND status = ?";
            params.add(status); // Thêm true hoặc false
        }

        sql += " ORDER BY updatedAt DESC"; // Sắp xếp giống hàm getAll()

        // Sử dụng try-with-resources
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            // Set các tham số vào câu lệnh SQL
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs)); // Sử dụng hàm map đã có
                }
            }
        } catch (SQLException e) {
            System.out.println("Error findGuidelines: " + e.getMessage());
            e.printStackTrace(); // In chi tiết lỗi
        }
        return list;
    }
    // Ánh xạ dữ liệu từ ResultSet sang đối tượng Guideline
    private Guideline map(ResultSet rs) throws SQLException {
        Guideline g = new Guideline();
        g.setGuidelineId(rs.getInt("guidelineId"));

        // Xử lý serviceId (có thể là NULL)
        int svc = rs.getInt("serviceId");
        g.setServiceId(rs.wasNull() ? null : svc);

        g.setTitle(rs.getNString("title"));
        g.setContent(rs.getNString("content"));
        g.setImageUrl(rs.getString("imageUrl"));
        g.setStatus(rs.getBoolean("status"));
        g.setCreatedAt(rs.getTimestamp("createdAt"));
        g.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return g;
    }

    /**
     * Lấy tất cả guideline (cho admin/receptionist)
     * @return Danh sách Guideline
     */
    public List<Guideline> getAll() {
        String sql = "SELECT * FROM ServiceGuideline ORDER BY updatedAt DESC";
        List<Guideline> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Guideline> getAllActive() {
        String sql = "SELECT * FROM ServiceGuideline WHERE status = 1 ORDER BY updatedAt DESC";
        List<Guideline> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Guideline getById(int id) {
        String sql = "SELECT * FROM ServiceGuideline WHERE guidelineId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)){

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void insert(Guideline g) {
        // Dùng GETDATE() của SQL Server để tự động điền createdAt và updatedAt
        String sql = "INSERT INTO ServiceGuideline (serviceId, title, content, imageUrl, status, createdAt, updatedAt) " +
                "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql)){

            // Xử lý serviceId (có thể NULL)
            if (g.getServiceId() == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, g.getServiceId());
            }

            ps.setNString(2, g.getTitle());
            ps.setNString(3, g.getContent());
            ps.setString(4, g.getImageUrl());
            ps.setBoolean(5, g.isStatus());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean update(Guideline g) {
        String sql = "UPDATE ServiceGuideline SET serviceId=?, title=?, content=?, imageUrl=?, status=?, updatedAt=GETDATE() " +
                "WHERE guidelineId=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)){

            if (g.getServiceId() == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, g.getServiceId());
            }

            ps.setNString(2, g.getTitle());
            ps.setNString(3, g.getContent());
            ps.setString(4, g.getImageUrl());
            ps.setBoolean(5, g.isStatus());
            ps.setInt(6, g.getGuidelineId()); // ID cho điều kiện WHERE

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public void delete(int id) {
        String sql = "DELETE FROM ServiceGuideline WHERE guidelineId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}