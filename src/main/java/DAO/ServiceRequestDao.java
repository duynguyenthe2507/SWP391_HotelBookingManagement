package DAO;

import Models.ServiceRequest;
import java.sql.*;
import java.util.*;

public class ServiceRequestDao extends DBContext {

    private ServiceRequest mapResultSetToServiceRequest(ResultSet rs) throws SQLException {
        return new ServiceRequest(
                rs.getInt("serviceId"),
                rs.getInt("bookingId"),
                rs.getInt("serviceTypeId"),
                rs.getDouble("price"),
                rs.getString("status")
        );
    }

    public List<ServiceRequest> getAllServiceRequests() {
        List<ServiceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ServiceRequest";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToServiceRequest(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public ServiceRequest getServiceRequestById(int id) {
        String sql = "SELECT * FROM ServiceRequest WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToServiceRequest(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addServiceRequest(ServiceRequest sr) {
        String sql = "INSERT INTO ServiceRequest(bookingId, serviceTypeId, price, status) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sr.getBookingId());
            ps.setInt(2, sr.getServiceTypeId());
            ps.setDouble(3, sr.getPrice());
            ps.setString(4, sr.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateServiceRequest(ServiceRequest sr) {
        String sql = "UPDATE ServiceRequest SET bookingId=?, serviceTypeId=?, price=?, status=? WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sr.getBookingId());
            ps.setInt(2, sr.getServiceTypeId());
            ps.setDouble(3, sr.getPrice());
            ps.setString(4, sr.getStatus());
            ps.setInt(5, sr.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteServiceRequest(int id) {
        String sql = "DELETE FROM ServiceRequest WHERE serviceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
