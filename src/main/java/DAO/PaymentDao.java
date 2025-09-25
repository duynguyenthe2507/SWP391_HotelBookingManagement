package DAO;

import Models.Payment;
import java.sql.*;
import java.util.*;

public class PaymentDao extends DBContext {

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        return new Payment(
                rs.getInt("paymentId"),
                rs.getInt("bookingId"),
                rs.getDouble("amount"),
                rs.getString("method"),
                rs.getString("status")
        );
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payment";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToPayment(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Payment getPaymentById(int id) {
        String sql = "SELECT * FROM Payment WHERE paymentId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToPayment(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addPayment(Payment p) {
        String sql = "INSERT INTO Payment(bookingId, amount, method, status) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, p.getBookingId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getMethod());
            ps.setString(4, p.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updatePayment(Payment p) {
        String sql = "UPDATE Payment SET bookingId=?, amount=?, method=?, status=? WHERE paymentId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, p.getBookingId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getMethod());
            ps.setString(4, p.getStatus());
            ps.setInt(5, p.getPaymentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deletePayment(int id) {
        String sql = "DELETE FROM Payment WHERE paymentId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
