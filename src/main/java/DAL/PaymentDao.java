package DAL;

import Models.Payment;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class PaymentDao extends DBContext {

    private Payment map(ResultSet rs) throws SQLException {
        return new Payment(
                rs.getInt("paymentId"),
                rs.getInt("bookingId"),
                rs.getDouble("amount"),
                rs.getString("method"),
                rs.getString("status"),
                rs.getTimestamp("transactionTime").toLocalDateTime()
        );
    }

    public List<Payment> getAll() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payment";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Payment> getByBookingId(int bookingId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Payment p) {
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

    public boolean update(Payment p) {
        String sql = "UPDATE Payment SET amount=?, method=?, status=? WHERE paymentId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, p.getAmount());
            ps.setString(2, p.getMethod());
            ps.setString(3, p.getStatus());
            ps.setInt(4, p.getPaymentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Payment WHERE paymentId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
