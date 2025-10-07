package DAL;

import Models.ServiceRequest;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class ServiceRequestDao extends DBContext {

    private ServiceRequest map(ResultSet rs) throws SQLException {
        return new ServiceRequest(
                rs.getInt("requestId"),
                rs.getInt("bookingId"),
                rs.getInt("serviceTypeId"),
                rs.getDouble("price"),
                rs.getString("status"),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
    }

    public List<ServiceRequest> getAll() {
        List<ServiceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ServiceRequest";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<ServiceRequest> getByBookingId(int bookingId) {
        List<ServiceRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM ServiceRequest WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(ServiceRequest sr) {
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

    public boolean update(ServiceRequest sr) {
        String sql = "UPDATE ServiceRequest SET price=?, status=? WHERE requestId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, sr.getPrice());
            ps.setString(2, sr.getStatus());
            ps.setInt(3, sr.getRequestId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM ServiceRequest WHERE requestId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
