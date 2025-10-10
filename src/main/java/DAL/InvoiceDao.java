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
                rs.getDouble("totalRoomCost"),
                rs.getDouble("totalServiceCost"),
                rs.getDouble("taxAmount"),
                rs.getDouble("totalAmount"),
                rs.getTimestamp("issuedAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt").toLocalDateTime()
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
        String sql = "INSERT INTO Invoice(bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount,) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, i.getBookingId());
            ps.setDouble(2, i.getTotalRoomCost());
            ps.setDouble(3, i.getTotalServiceCost());
            ps.setDouble(4, i.getTaxAmount());
            ps.setDouble(5, i.getTotalAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Invoice i) {
        String sql = "UPDATE Invoice SET totalAmount=?, totalRoomCost=?, totalServiceCost=?, taxAmount=? WHERE invoiceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, i.getTotalAmount());
            ps.setDouble(2, i.getTotalRoomCost());
            ps.setDouble(3, i.getTotalServiceCost());
            ps.setDouble(4, i.getTaxAmount());
            ps.setInt(5, i.getInvoiceId());
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
