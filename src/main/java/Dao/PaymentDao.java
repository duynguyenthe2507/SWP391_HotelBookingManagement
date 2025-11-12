package Dao;

import Models.Payment;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Đã thêm hàm checkPaymentExists để tránh IPN xử lý trùng lặp.
 */
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

        // Map các trường VNPAY (giả định tên cột trong DB khớp, dựa trên CSDL bạn cung cấp)
        // CSDL của bạn không có vnpTransactionNo, vnpBankCode.
        // Tôi sẽ tạm thời comment chúng đi. 
        // BẠN NÊN THÊM CÁC CỘT NÀY VÀO BẢNG PAYMENT:
        // ALTER TABLE Payment ADD vnpTransactionNo VARCHAR(50);
        // ALTER TABLE Payment ADD vnpBankCode VARCHAR(20);
        
        // payment.setVnpTransactionNo(rs.getString("vnpTransactionNo"));
        // payment.setVnpBankCode(rs.getString("vnpBankCode"));
        
        return payment;
    }
    
    /**
     * Thêm một bản ghi thanh toán mới vào database.
     */
    public boolean insertPayment(Payment payment) {
        // SQL đã sửa (loại bỏ 2 cột vnpTransactionNo, vnpBankCode cho khớp CSDL)
        String sql = "INSERT INTO Payment(bookingId, amount, method, status, transactionTime, updatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getMethod());
            ps.setString(4, payment.getStatus());
            ps.setTimestamp(5, Timestamp.valueOf(payment.getTransactionTime()));
            ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now())); // updatedAt
            // ps.setString(7, payment.getVnpTransactionNo()); // Nên thêm cột này
            // ps.setString(8, payment.getVnpBankCode()); // Nên thêm cột này

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
    }

    /**
     * HÀM MỚI: Rất quan trọng để tránh IPN xử lý trùng lặp.
     * (Hàm này yêu cầu bạn thêm cột vnpTransactionNo vào bảng Payment)
     *
     * @param vnpTransactionNo Mã giao dịch VNPAY gửi về
     * @return true nếu đã tồn tại, false nếu chưa
     */
    public boolean checkPaymentExists(String vnpTransactionNo) {
        // NẾU BẠN KHÔNG THÊM CỘT, HÃY DÙNG LOGIC NÀY:
        // Kiểm tra xem đã có thanh toán 'completed' cho bookingId này chưa
        String sql = "SELECT COUNT(*) FROM Payment WHERE bookingId = ? AND status = 'completed'";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
             // Tạm thời dùng bookingId (vnp_TxnRef) làm key
             int bookingId = Integer.parseInt(vnpTransactionNo);
             ps.setInt(1, bookingId); 
             
             try (ResultSet rs = ps.executeQuery()) {
                 if (rs.next()) {
                     return rs.getInt(1) > 0;
                 }
             }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking payment existence for bookingId: " + vnpTransactionNo, e);
        }
        return false; // Mặc định là chưa tồn tại
        
        /*
        // LOGIC ĐÚNG (khi bạn đã thêm cột vnpTransactionNo):
        String sql = "SELECT COUNT(*) FROM Payment WHERE vnpTransactionNo = ?";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setString(1, vnpTransactionNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking payment existence for vnp_TransactionNo: " + vnpTransactionNo, e);
        }
        return false;
        */
    }

    // (Các hàm getPaymentsByBookingId và getPaymentById giữ nguyên như của bạn)
    public List<Payment> getPaymentsByBookingId(int bookingId) { /* ... code của bạn ... */ return new ArrayList<>(); }
    public Payment getPaymentById(int paymentId) { /* ... code của bạn ... */ return null; }
}

