package DAL;

import Models.Invoice;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class InvoiceDao extends DBContext {

    private Invoice map(ResultSet rs) throws SQLException {
        return new Invoice(
                rs.getInt("invoiceId"),
                rs.getInt("bookingId"),
                rs.getDouble("totalAmount"),
                rs.getString("paymentMethod"),
                rs.getString("status"),
                rs.getTimestamp("issuedAt").toLocalDateTime()
        );
    }

    public List<Invoice> getAll() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoice";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Invoice getByBookingId(int bookingId) {
        String sql = "SELECT * FROM Invoice WHERE bookingId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Invoice i) {
        String sql = "INSERT INTO Invoice(bookingId, totalAmount, paymentMethod, status) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, i.getBookingId());
            ps.setDouble(2, i.getTotalAmount());
            ps.setString(3, i.getPaymentMethod());
            ps.setString(4, i.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Invoice i) {
        String sql = "UPDATE Invoice SET totalAmount=?, paymentMethod=?, status=? WHERE invoiceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, i.getTotalAmount());
            ps.setString(2, i.getPaymentMethod());
            ps.setString(3, i.getStatus());
            ps.setInt(4, i.getInvoiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Invoice WHERE invoiceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
