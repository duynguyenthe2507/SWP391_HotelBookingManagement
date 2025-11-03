package Dao;

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
                rs.getTimestamp("issuedDate").toLocalDateTime(),
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
        String sql = "INSERT INTO Invoice(bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount) VALUES (?,?,?,?,?)";
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

    // Get invoice by ID
    public Invoice getById(int invoiceId) {
        String sql = "SELECT * FROM Invoice WHERE invoiceId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Get all bills with customer details for listing
    public List<Map<String, Object>> getAllBillsWithDetails() {
        List<Map<String, Object>> bills = new ArrayList<>();
        String sql = """
            SELECT i.invoiceId, i.bookingId, i.totalAmount, i.issuedDate,
                   u.firstName, u.lastName, u.mobilePhone,
                   b.checkinTime, b.checkoutTime, b.status AS bookingStatus
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN Users u ON b.userId = u.userId
            ORDER BY i.invoiceId ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> bill = new HashMap<>();
                bill.put("invoiceId", rs.getInt("invoiceId"));
                bill.put("bookingId", rs.getInt("bookingId"));
                bill.put("totalAmount", rs.getDouble("totalAmount"));
                bill.put("issuedDate", rs.getTimestamp("issuedDate"));
                bill.put("customerName", rs.getString("firstName") + " " + rs.getString("lastName"));
                bill.put("customerPhone", rs.getString("mobilePhone"));
                bill.put("checkinTime", rs.getTimestamp("checkinTime"));
                bill.put("checkoutTime", rs.getTimestamp("checkoutTime"));
                bill.put("bookingStatus", rs.getString("bookingStatus"));
                bills.add(bill);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bills;
    }

    // Pagination: list bills with details
    public List<Map<String, Object>> getBillsWithDetailsPaged(int offset, int limit) {
        List<Map<String, Object>> bills = new ArrayList<>();
        String sql = """
            SELECT i.invoiceId, i.bookingId, i.totalAmount, i.issuedDate,
                   u.firstName, u.lastName, u.mobilePhone,
                   b.checkinTime, b.checkoutTime, b.status AS bookingStatus
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN Users u ON b.userId = u.userId
            ORDER BY i.invoiceId ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Math.max(0, offset));
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> bill = new HashMap<>();
                    bill.put("invoiceId", rs.getInt("invoiceId"));
                    bill.put("bookingId", rs.getInt("bookingId"));
                    bill.put("totalAmount", rs.getDouble("totalAmount"));
                    bill.put("issuedDate", rs.getTimestamp("issuedDate"));
                    bill.put("customerName", rs.getString("firstName") + " " + rs.getString("lastName"));
                    bill.put("customerPhone", rs.getString("mobilePhone"));
                    bill.put("checkinTime", rs.getTimestamp("checkinTime"));
                    bill.put("checkoutTime", rs.getTimestamp("checkoutTime"));
                    bill.put("bookingStatus", rs.getString("bookingStatus"));
                    bills.add(bill);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bills;
    }

    public int countAllBills() {
        String sql = "SELECT COUNT(*) AS total FROM Invoice";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Search bills by customer name or phone
    public List<Map<String, Object>> searchBills(String searchTerm) {
        List<Map<String, Object>> bills = new ArrayList<>();
        String sql = """
            SELECT i.invoiceId, i.bookingId, i.totalAmount, i.issuedDate,
                   u.firstName, u.lastName, u.mobilePhone,
                   b.checkinTime, b.checkoutTime, b.status AS bookingStatus
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN Users u ON b.userId = u.userId
            WHERE u.firstName LIKE ?
               OR u.lastName LIKE ?
               OR u.mobilePhone LIKE ?
               OR (u.firstName + ' ' + u.lastName) LIKE ?
               OR (u.firstName + ' ' + COALESCE(u.middleName, '') + ' ' + u.lastName) LIKE ?
               OR (u.lastName + ' ' + u.firstName) LIKE ?
               OR CAST(i.invoiceId AS VARCHAR(20)) LIKE ?
               OR CAST(b.bookingId AS VARCHAR(20)) LIKE ?
            ORDER BY i.invoiceId ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern); // firstName
            ps.setString(2, searchPattern); // lastName
            ps.setString(3, searchPattern); // phone
            ps.setString(4, searchPattern); // first last
            ps.setString(5, searchPattern); // first middle last
            ps.setString(6, searchPattern); // last first
            ps.setString(7, searchPattern); // invoiceId
            ps.setString(8, searchPattern); // bookingId

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> bill = new HashMap<>();
                bill.put("invoiceId", rs.getInt("invoiceId"));
                bill.put("bookingId", rs.getInt("bookingId"));
                bill.put("totalAmount", rs.getDouble("totalAmount"));
                bill.put("issuedDate", rs.getTimestamp("issuedDate"));
                bill.put("customerName", rs.getString("firstName") + " " + rs.getString("lastName"));
                bill.put("customerPhone", rs.getString("mobilePhone"));
                bill.put("checkinTime", rs.getTimestamp("checkinTime"));
                bill.put("checkoutTime", rs.getTimestamp("checkoutTime"));
                bill.put("bookingStatus", rs.getString("bookingStatus"));
                bills.add(bill);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bills;
    }

    // Pagination + search
    public List<Map<String, Object>> searchBillsPaged(String searchTerm, int offset, int limit) {
        List<Map<String, Object>> bills = new ArrayList<>();
        String sql = """
            SELECT i.invoiceId, i.bookingId, i.totalAmount, i.issuedDate,
                   u.firstName, u.lastName, u.mobilePhone,
                   b.checkinTime, b.checkoutTime, b.status AS bookingStatus
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN Users u ON b.userId = u.userId
            WHERE u.firstName LIKE ?
               OR u.lastName LIKE ?
               OR u.mobilePhone LIKE ?
               OR (u.firstName + ' ' + u.lastName) LIKE ?
               OR (u.firstName + ' ' + COALESCE(u.middleName, '') + ' ' + u.lastName) LIKE ?
               OR (u.lastName + ' ' + u.firstName) LIKE ?
               OR CAST(i.invoiceId AS VARCHAR(20)) LIKE ?
               OR CAST(b.bookingId AS VARCHAR(20)) LIKE ?
            ORDER BY i.invoiceId ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            ps.setString(6, searchPattern);
            ps.setString(7, searchPattern);
            ps.setString(8, searchPattern);
            ps.setInt(9, Math.max(0, offset));
            ps.setInt(10, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> bill = new HashMap<>();
                    bill.put("invoiceId", rs.getInt("invoiceId"));
                    bill.put("bookingId", rs.getInt("bookingId"));
                    bill.put("totalAmount", rs.getDouble("totalAmount"));
                    bill.put("issuedDate", rs.getTimestamp("issuedDate"));
                    bill.put("customerName", rs.getString("firstName") + " " + rs.getString("lastName"));
                    bill.put("customerPhone", rs.getString("mobilePhone"));
                    bill.put("checkinTime", rs.getTimestamp("checkinTime"));
                    bill.put("checkoutTime", rs.getTimestamp("checkoutTime"));
                    bill.put("bookingStatus", rs.getString("bookingStatus"));
                    bills.add(bill);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bills;
    }

    public int countBillsBySearch(String searchTerm) {
        String sql = """
            SELECT COUNT(*) AS total
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN Users u ON b.userId = u.userId
            WHERE u.firstName LIKE ?
               OR u.lastName LIKE ?
               OR u.mobilePhone LIKE ?
               OR (u.firstName + ' ' + u.lastName) LIKE ?
               OR (u.firstName + ' ' + COALESCE(u.middleName, '') + ' ' + u.lastName) LIKE ?
               OR (u.lastName + ' ' + u.firstName) LIKE ?
               OR CAST(i.invoiceId AS VARCHAR(20)) LIKE ?
               OR CAST(b.bookingId AS VARCHAR(20)) LIKE ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            ps.setString(6, searchPattern);
            ps.setString(7, searchPattern);
            ps.setString(8, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Get detailed bill information including customer and booking details
    public Map<String, Object> getDetailedBillInfo(int invoiceId) {
        String sql = """
            SELECT i.*, b.checkinTime, b.checkoutTime, b.status as bookingStatus,
                   u.firstName, u.middleName, u.lastName, u.email, u.mobilePhone,
                   r.discountPercentage,
                   DATEDIFF(HOUR, b.checkinTime, b.checkoutTime) as durationHours
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN Users u ON b.userId = u.userId
            LEFT JOIN Rank r ON u.rankId = r.rankId
            WHERE i.invoiceId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> billInfo = new HashMap<>();

                // Invoice object
                Invoice invoice = map(rs);
                billInfo.put("invoice", invoice);

                // Customer information
                billInfo.put("firstName", rs.getString("firstName"));
                billInfo.put("middleName", rs.getString("middleName"));
                billInfo.put("lastName", rs.getString("lastName"));
                billInfo.put("email", rs.getString("email"));
                billInfo.put("mobilePhone", rs.getString("mobilePhone"));

                // Composite fields for compatibility
                String firstName = rs.getString("firstName") != null ? rs.getString("firstName") : "";
                String middleName = rs.getString("middleName") != null ? rs.getString("middleName") : "";
                String lastName = rs.getString("lastName") != null ? rs.getString("lastName") : "";
                billInfo.put("customerName", firstName + (middleName.isEmpty() ? "" : " " + middleName) + " " + lastName);
                billInfo.put("customerEmail", rs.getString("email"));
                billInfo.put("customerPhone", rs.getString("mobilePhone"));

                // Booking information
                billInfo.put("checkinTime", rs.getTimestamp("checkinTime"));
                billInfo.put("checkoutTime", rs.getTimestamp("checkoutTime"));
                billInfo.put("durationHours", rs.getInt("durationHours"));
                billInfo.put("bookingStatus", rs.getString("bookingStatus"));

                // Discount information
                billInfo.put("discountPercentage", rs.getDouble("discountPercentage"));

                return billInfo;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Get room details for a bill
    public List<Map<String, Object>> getBillRoomDetails(int invoiceId) {
        List<Map<String, Object>> roomDetails = new ArrayList<>();
        String sql = """
            SELECT bd.*, r.name AS roomName, c.name AS categoryName, r.capacity
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN BookingDetail bd ON b.bookingId = bd.bookingId
            INNER JOIN Room r ON bd.roomId = r.roomId
            INNER JOIN Category c ON r.categoryId = c.categoryId
            WHERE i.invoiceId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomName", rs.getString("roomName"));
                room.put("categoryName", rs.getString("categoryName"));
                room.put("capacity", rs.getInt("capacity"));
                room.put("guestCount", rs.getInt("guestCount"));
                room.put("priceAtBooking", rs.getDouble("priceAtBooking"));
                room.put("specialRequest", rs.getString("specialRequest"));
                room.put("specialRequests", rs.getString("specialRequest")); // For JSP compatibility
                roomDetails.add(room);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return roomDetails;
    }

    // Get service details for a bill
    public List<Map<String, Object>> getBillServiceDetails(int invoiceId) {
        List<Map<String, Object>> serviceDetails = new ArrayList<>();
        String sql = """
            SELECT sr.*, s.name AS serviceName, s.description
            FROM Invoice i
            INNER JOIN Booking b ON i.bookingId = b.bookingId
            INNER JOIN ServiceRequest sr ON b.bookingId = sr.bookingId
            INNER JOIN Services s ON sr.serviceTypeId = s.serviceId
            WHERE i.invoiceId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> service = new HashMap<>();
                service.put("serviceName", rs.getString("serviceName"));
                service.put("description", rs.getString("description"));
                service.put("price", rs.getDouble("price"));
                service.put("status", rs.getString("status"));
                serviceDetails.add(service);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return serviceDetails;
    }

    // Get bookings without invoices for creating new bills
    public List<Map<String, Object>> getBookingsWithoutInvoices() {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = """
            SELECT b.bookingId, b.checkinTime, b.checkoutTime, b.totalPrice, b.status,
                   u.firstName, u.lastName, u.mobilePhone
            FROM Booking b
            INNER JOIN Users u ON b.userId = u.userId
            LEFT JOIN Invoice i ON b.bookingId = i.bookingId
            WHERE i.invoiceId IS NULL AND b.status = 'confirmed'
            ORDER BY b.checkinTime DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("bookingId"));
                booking.put("checkinTime", rs.getTimestamp("checkinTime"));
                booking.put("checkoutTime", rs.getTimestamp("checkoutTime"));
                booking.put("totalPrice", rs.getDouble("totalPrice"));
                booking.put("status", rs.getString("status"));
                booking.put("customerName", rs.getString("firstName") + " " + rs.getString("lastName"));
                booking.put("customerPhone", rs.getString("mobilePhone"));
                bookings.add(booking);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bookings;
    }

    // Get room details for a booking (for bill creation)
    public List<Map<String, Object>> getBookingRoomDetails(int bookingId) {
        List<Map<String, Object>> roomDetails = new ArrayList<>();
        String sql = """
            SELECT bd.*, r.name AS roomName, c.name AS categoryName, r.capacity
            FROM BookingDetail bd
            INNER JOIN Room r ON bd.roomId = r.roomId
            INNER JOIN Category c ON r.categoryId = c.categoryId
            WHERE bd.bookingId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomName", rs.getString("roomName"));
                room.put("categoryName", rs.getString("categoryName"));
                room.put("capacity", rs.getInt("capacity"));
                room.put("guestCount", rs.getInt("guestCount"));
                room.put("priceAtBooking", rs.getDouble("priceAtBooking"));
                room.put("specialRequest", rs.getString("specialRequest"));
                roomDetails.add(room);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return roomDetails;
    }

    // Get service details for a booking (for bill creation)
    public List<Map<String, Object>> getBookingServiceDetails(int bookingId) {
        List<Map<String, Object>> serviceDetails = new ArrayList<>();
        String sql = """
            SELECT sr.*, s.name AS serviceName, s.description
            FROM ServiceRequest sr
            INNER JOIN Services s ON sr.serviceTypeId = s.serviceId
            WHERE sr.bookingId = ? AND sr.status = 'completed'
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> service = new HashMap<>();
                service.put("serviceName", rs.getString("serviceName"));
                service.put("description", rs.getString("description"));
                service.put("price", rs.getDouble("price"));
                service.put("status", rs.getString("status"));
                serviceDetails.add(service);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return serviceDetails;
    }
}