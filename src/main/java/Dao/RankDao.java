package Dao;

import Models.Rank;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class RankDao extends DBContext {

    private Rank map(ResultSet rs) throws SQLException {
        return new Rank(
                rs.getInt("rankId"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getInt("minBookings"),
                rs.getDouble("discountPercentage"),
                rs.getTimestamp("createdAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }

    public List<Rank> getAll() {
        List<Rank> list = new ArrayList<>();
        String sql = "SELECT * FROM Rank ORDER BY minBookings ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Rank getById(int id) {
        String sql = "SELECT * FROM Rank WHERE rankId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Rank r) {
        String sql = "INSERT INTO Rank(name, description, minBookings, discountPercentage) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setInt(3, r.getMinBookings());
            ps.setDouble(4, r.getDiscountPercentage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Xử lý trùng tên rank
            if (!e.getMessage().contains("duplicate")) e.printStackTrace();
        }
        return false;
    }

    public boolean update(Rank r) {
        String sql = "UPDATE Rank SET name=?, description=?, minBookings=?, discountPercentage=? WHERE rankId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setInt(3, r.getMinBookings());
            ps.setDouble(4, r.getDiscountPercentage());
            ps.setInt(5, r.getRankId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            if (!e.getMessage().contains("duplicate")) e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Rank WHERE rankId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Không xóa được nếu FK trong Users
            e.printStackTrace();
        }
        return false;
    }
}
