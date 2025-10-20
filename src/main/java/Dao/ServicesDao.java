package Dao;

import Models.Services;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class ServicesDao extends DBContext {

    private Services map(ResultSet rs) throws SQLException {
        return new Services(
                rs.getInt("serviceId"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("description"),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }

    public List<Services> getAll() {
        List<Services> list = new ArrayList<>();
        String sql = "SELECT * FROM Services";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Services getById(int id) {
        String sql = "SELECT * FROM Services WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Services s) {
        String sql = "INSERT INTO Services(name, price, description) VALUES (?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setString(3, s.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Services s) {
        String sql = "UPDATE Services SET name=?, price=?, description=? WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setInt(4, s.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Services WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
