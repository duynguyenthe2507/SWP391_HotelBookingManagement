package DAO;

import Models.Services;
import java.sql.*;
import java.util.*;

public class ServicesDao extends DBContext {

    private Services mapResultSetToServices(ResultSet rs) throws SQLException {
        return new Services(
                rs.getInt("serviceId"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("description")
        );
    }

    public List<Services> getAllServices() {
        List<Services> list = new ArrayList<>();
        String sql = "SELECT * FROM Services";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToServices(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Services getServiceById(int id) {
        String sql = "SELECT * FROM Services WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToServices(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addService(Services s) {
        String sql = "INSERT INTO Services(name, price, description) VALUES (?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setString(3, s.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateService(Services s) {
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

    public boolean deleteService(int id) {
        String sql = "DELETE FROM Services WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
