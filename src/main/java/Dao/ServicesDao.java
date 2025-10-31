package Dao;

import Models.Services;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServicesDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(ServicesDao.class.getName());

    private Services map(ResultSet rs) throws SQLException {
        return new Services(
                rs.getInt("serviceId"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("description"),
                rs.getString("iconClass"),
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
        String sql = "INSERT INTO Services(name, price, description, iconClass) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getIconClass());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Services s) {
        String sql = "UPDATE Services SET name=?, price=?, description=?, iconClass=? WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getIconClass()); // Thêm iconClass
            ps.setInt(5, s.getServiceId());
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


    public Map<Integer, Services> getAllServicesAsMap() {
        Map<Integer, Services> map = new HashMap<>();
        String sql = "SELECT * FROM Services";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Services s = map(rs);
                map.put(s.getServiceId(), s);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting services as map", e);
        }
        return map;
    }

    public List<Map<String, Object>> getServicesByBookingId(int bookingId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.name, s.description, bsl.quantity, bsl.priceAtBooking " +
                "FROM Services s " +
                "JOIN BookingServiceLink bsl ON s.serviceId = bsl.serviceId " +
                "WHERE bsl.bookingId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> serviceInfo = new HashMap<>();
                    serviceInfo.put("name", rs.getString("name"));
                    serviceInfo.put("description", rs.getString("description"));
                    serviceInfo.put("quantity", rs.getInt("quantity"));
                    serviceInfo.put("priceAtBooking", rs.getDouble("priceAtBooking"));
                    list.add(serviceInfo);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting services for booking " + bookingId, e);
        }
        return list;
    }
}