package Dao;

import Models.Payment;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(PaymentDao.class.getName());

    public PaymentDao() {
        super();
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("paymentId"));
        payment.setBookingId(rs.getInt("bookingId"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setMethod(rs.getString("method"));
        payment.setStatus(rs.getString("status"));
        
        Timestamp transactionTimeTs = rs.getTimestamp("transactionTime");
        payment.setTransactionTime(transactionTimeTs != null ? transactionTimeTs.toLocalDateTime() : null);
        
        Timestamp updatedAtTs = rs.getTimestamp("updatedAt");
        payment.setUpdatedAt(updatedAtTs != null ? updatedAtTs.toLocalDateTime() : null);

        // Map các trường VNPAY (giả định tên cột trong DB khớp)
        payment.setVnpTransactionNo(rs.getString("vnpTransactionNo"));
        payment.setVnpBankCode(rs.getString("vnpBankCode"));
        
        return payment;
    }

    /**
     * Thêm một bản ghi thanh toán mới vào database.
     * Hàm này quản lý connection riêng.
     */
    public boolean insertPayment(Payment payment) {
        String sql = "INSERT INTO Payment(bookingId, amount, method, status, transactionTime, updatedAt, vnpTransactionNo, vnpBankCode) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Sử dụng connection từ DBContext cha (được khởi tạo trong constructor)
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getMethod());
            ps.setString(4, payment.getStatus());
            ps.setTimestamp(5, Timestamp.valueOf(payment.getTransactionTime()));
            ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now())); // updatedAt
            ps.setString(7, payment.getVnpTransactionNo());
            ps.setString(8, payment.getVnpBankCode());

            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error in insertPayment for bookingId: " + payment.getBookingId(), e);
            e.printStackTrace();
            return false;
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Unexpected error in insertPayment", e);
             e.printStackTrace();
             return false;
        }
        // Connection được quản lý (đóng) bởi lớp DBContext cha khi servlet kết thúc
    }

    /**
     * Lấy danh sách các thanh toán cho một booking.
     * Hàm này tạo connection riêng.
     */
    public List<Payment> getPaymentsByBookingId(int bookingId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE bookingId = ? ORDER BY transactionTime DESC";

        // Tạo DBContext tạm thời để quản lý connection cho thao tác đọc này
        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getPaymentsByBookingId for bookingId: " + bookingId, e);
            e.printStackTrace();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting connection in getPaymentsByBookingId", e);
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy một thanh toán bằng ID của nó.
     * Hàm này tạo connection riêng.
     */
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM Payment WHERE paymentId = ?";
        Payment payment = null;

        try (Connection c = new DBContext().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    payment = mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error in getPaymentById for paymentId: " + paymentId, e);
            e.printStackTrace();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting connection in getPaymentById", e);
            e.printStackTrace();
        }
        return payment;
    }
}

