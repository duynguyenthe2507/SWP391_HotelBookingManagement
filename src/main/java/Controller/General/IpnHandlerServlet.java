package Controller.General;

import Dao.PaymentDao;
import Models.Booking;
import Models.Payment;
import Services.BookingService;
import Utility.VnPayConfig; // Đảm bảo import đúng
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet này xử lý Giai đoạn 5: Nhận thông báo IPN (Instant Payment Notification) từ VNPAY.
 * Đã sửa lỗi parse ngày và so sánh double.
 */
@WebServlet(name = "IpnHandlerServlet", urlPatterns = {"/ipnHandler"})
public class IpnHandlerServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(IpnHandlerServlet.class.getName());
    private BookingService bookingService;
    private PaymentDao paymentDao;

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
        this.paymentDao = new PaymentDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processIpnRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processIpnRequest(req, resp);
    }

    private void processIpnRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, String> fields = new HashMap<>();
        // Đọc tất cả tham số (sử dụng UTF-8)
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = URLDecoder.decode(params.nextElement(), StandardCharsets.UTF_8.toString());
            String fieldValue = URLDecoder.decode(req.getParameter(fieldName), StandardCharsets.UTF_8.toString());
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) fields.remove("vnp_SecureHashType");
        if (fields.containsKey("vnp_SecureHash")) fields.remove("vnp_SecureHash");

        resp.setContentType("application/json");

        // Xác thực chữ ký
        String signValue = VnPayConfig.hashAllFields(fields);
        LOGGER.log(Level.INFO, "Received IPN request. Calculated Hash: {0}, Received Hash: {1}", new Object[]{signValue, vnp_SecureHash});

        if (signValue.equals(vnp_SecureHash)) {
            String vnp_TxnRef = req.getParameter("vnp_TxnRef"); // Mã Booking ID
            String vnp_ResponseCode = req.getParameter("vnp_ResponseCode"); // "00" là thành công
            String vnp_TransactionStatus = req.getParameter("vnp_TransactionStatus"); // "00" là thành công
            String vnp_AmountStr = req.getParameter("vnp_Amount"); // Số tiền (đã nhân 100)
            String vnp_PayDateStr = req.getParameter("vnp_PayDate"); // yyyyMMddHHmmss
            String vnp_TransactionNo = req.getParameter("vnp_TransactionNo"); // Mã GD VNPAY
            String vnp_BankCode = req.getParameter("vnp_BankCode"); // Mã ngân hàng

            try {
                int bookingId = Integer.parseInt(vnp_TxnRef);
                double amountVNPAY = Double.parseDouble(vnp_AmountStr) / 100.0; // Đổi về VND

                // Parse ngày thanh toán
                LocalDateTime transactionDateTime = LocalDateTime.now(); // Mặc định
                if (vnp_PayDateStr != null && !vnp_PayDateStr.isEmpty()) {
                    try {
                        DateTimeFormatter vnpDateFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                        transactionDateTime = LocalDateTime.parse(vnp_PayDateStr, vnpDateFormatter);
                    } catch (DateTimeParseException e) {
                        LOGGER.log(Level.SEVERE, "Error parsing vnp_PayDate: " + vnp_PayDateStr, e);
                    }
                }

                // 1. Kiểm tra Booking tồn tại
                Booking booking = bookingService.getBookingById(bookingId);
                if (booking == null) {
                    LOGGER.log(Level.SEVERE, "Booking not found for ID: {0}", bookingId);
                    resp.getWriter().write("{\"RspCode\":\"01\",\"Message\":\"Order not found\"}");
                    return;
                }

                // 2. Kiểm tra số tiền
                // So sánh double với sai số nhỏ
                boolean checkAmount = Math.abs(booking.getTotalPrice() - amountVNPAY) < 0.01;
                if (!checkAmount) {
                    LOGGER.log(Level.SEVERE, "Amount mismatch! DB Amount: {0}, VNPAY Amount: {1}",
                            new Object[]{booking.getTotalPrice(), amountVNPAY});
                    resp.getWriter().write("{\"RspCode\":\"04\",\"Message\":\"Invalid amount\"}");
                    return;
                }
                
                // 3. Kiểm tra trạng thái đơn hàng (chỉ xử lý nếu đang "pending")
                if (!"pending".equalsIgnoreCase(booking.getStatus())) {
                    LOGGER.log(Level.WARNING, "Order status is not 'pending' (ID: {0}, Status: {1}). Already processed?",
                            new Object[]{bookingId, booking.getStatus()});
                    // Trả về 00 vì đơn hàng đã được xử lý trước đó (thành công hoặc thất bại)
                    resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Order already confirmed/processed\"}");
                    return;
                }

                // --- Nếu tất cả kiểm tra đều qua ---

                // Tạo đối tượng Payment để lưu lại
                Payment payment = new Payment();
                payment.setBookingId(bookingId);
                payment.setAmount(amountVNPAY);
                payment.setMethod("VNPAY");
                payment.setTransactionTime(transactionDateTime);
                payment.setUpdatedAt(LocalDateTime.now());
                payment.setVnpTransactionNo(vnp_TransactionNo);
                payment.setVnpBankCode(vnp_BankCode);

                // 4. Xử lý kết quả thanh toán
                if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                    // Giao dịch THÀNH CÔNG
                    boolean updateSuccess = bookingService.confirmBooking(bookingId);
                    
                    if (updateSuccess) {
                        LOGGER.log(Level.INFO, "Booking {0} status updated to 'confirmed' successfully.", bookingId);
                        payment.setStatus("completed");
                        paymentDao.insertPayment(payment);
                        resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
                    } else {
                        LOGGER.log(Level.SEVERE, "Failed to update booking {0} status to 'confirmed'.", bookingId);
                        resp.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Update Booking Failed\"}");
                    }
                } else {
                    // Giao dịch THẤT BẠI
                    boolean cancelSuccess = bookingService.cancelBooking(bookingId);
                    LOGGER.log(Level.WARNING, "VNPAY transaction failed (Code: {0}). Booking {1} status update to cancelled: {2}",
                            new Object[]{vnp_ResponseCode, bookingId, cancelSuccess});
                    
                    payment.setStatus("failed");
                    paymentDao.insertPayment(payment);
                    // Vẫn trả về 00 cho VNPAY vì đã xử lý (hủy đơn) thành công phía Merchant
                    resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
                }

            } catch (NumberFormatException e) {
                LOGGER.log(Level.SEVERE, "Error parsing Booking ID or Amount from IPN.", e);
                resp.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Invalid Input Format\"}");
            } catch (Exception e) {
                 LOGGER.log(Level.SEVERE, "Unexpected error processing IPN.", e);
                 e.printStackTrace(); // In lỗi chi tiết ra log
                 resp.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Unknown error\"}");
            }
        } else {
            LOGGER.log(Level.SEVERE, "Invalid VNPAY checksum!");
            resp.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Checksum\"}");
        }
    }
}

