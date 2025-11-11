package Controller.General;

import Dao.PaymentDao;
import Models.Booking;
import Models.Payment;
import Services.BookingService;
import Utils.VnPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "IpnHandlerController", urlPatterns = {"/ipnHandler"})
public class IpnHandlerController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(IpnHandlerController.class.getName());
    private BookingService bookingService;
    private PaymentDao paymentDao;

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
        this.paymentDao = new PaymentDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        processIpnRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        processIpnRequest(req, resp);
    }

    private void processIpnRequest(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        Map<String, String> vnp_Params = new HashMap<>();
        
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = req.getParameter(fieldName); 
            
            if (fieldValue != null && fieldValue.length() > 0) {
                vnp_Params.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = vnp_Params.remove("vnp_SecureHash");
        vnp_Params.remove("vnp_SecureHashType");

        resp.setContentType("application/json");

        String signValue = VnPayConfig.hashAllFields(vnp_Params);

        LOGGER.log(Level.INFO, "[IPN] Calculated Hash: {0}", signValue);
        LOGGER.log(Level.INFO, "[IPN] Received Hash: {0}", vnp_SecureHash);

        if (vnp_SecureHash == null || !signValue.equals(vnp_SecureHash)) { 
            LOGGER.log(Level.SEVERE, "[IPN] ❌ Invalid VNPAY checksum!");
            resp.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Checksum\"}");
            return;
        }
            
        LOGGER.info("[IPN] ✅ Signature verification SUCCESS.");
        
        // ✅ Lấy các tham số đã decoded
        String vnp_TxnRef = vnp_Params.get("vnp_TxnRef");
        String vnp_ResponseCode = vnp_Params.get("vnp_ResponseCode");
        String vnp_TransactionStatus = vnp_Params.get("vnp_TransactionStatus");
        String vnp_AmountStr = vnp_Params.get("vnp_Amount");
        String vnp_PayDateStr = vnp_Params.get("vnp_PayDate");
        String vnp_TransactionNo = vnp_Params.get("vnp_TransactionNo");
        String vnp_BankCode = vnp_Params.get("vnp_BankCode");

        try {
            int bookingId;
            if (vnp_TxnRef.contains("_")) {
                bookingId = Integer.parseInt(vnp_TxnRef.split("_")[0]);
            } else {
                bookingId = Integer.parseInt(vnp_TxnRef);
            }
            
            double amountVNPAY = Double.parseDouble(vnp_AmountStr) / 100.0;

            LocalDateTime transactionDateTime = LocalDateTime.now();
            if (vnp_PayDateStr != null && !vnp_PayDateStr.isEmpty()) {
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                    transactionDateTime = LocalDateTime.parse(vnp_PayDateStr, formatter);
                } catch (DateTimeParseException e) {
                    LOGGER.log(Level.SEVERE, "[IPN] Error parsing vnp_PayDate", e);
                }
            }

            // 1. Kiểm tra Booking tồn tại
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null) {
                LOGGER.log(Level.SEVERE, "[IPN] Booking not found: {0}", bookingId);
                resp.getWriter().write("{\"RspCode\":\"01\",\"Message\":\"Order not found\"}");
                return;
            }

            if (Math.abs(booking.getTotalPrice() - amountVNPAY) > 0.01) {
                LOGGER.log(Level.SEVERE, "[IPN] Amount mismatch! DB: {0}, VNPay: {1}",
                        new Object[]{booking.getTotalPrice(), amountVNPAY});
                resp.getWriter().write("{\"RspCode\":\"04\",\"Message\":\"Invalid amount\"}");
                return;
            }
            
            if (!"pending".equalsIgnoreCase(booking.getStatus())) {
                LOGGER.log(Level.WARNING, "[IPN] Booking {0} already processed (Status: {1})",
                        new Object[]{bookingId, booking.getStatus()});
                resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Already processed\"}");
                return;
            }

            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setAmount(amountVNPAY);
            payment.setMethod("VNPAY");
            payment.setTransactionTime(transactionDateTime);
            payment.setUpdatedAt(LocalDateTime.now());
            payment.setVnpTransactionNo(vnp_TransactionNo);
            payment.setVnpBankCode(vnp_BankCode);
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                if (bookingService.confirmBooking(bookingId)) {
                    LOGGER.log(Level.INFO, "[IPN] ✅ Booking {0} confirmed", bookingId);
                    payment.setStatus("completed");
                    paymentDao.insertPayment(payment);
                    resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Success\"}");
                } else {
                    LOGGER.log(Level.SEVERE, "[IPN] ❌ Failed to confirm booking {0}", bookingId);
                    resp.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Update failed\"}");
                }
            } else {
                bookingService.cancelBooking(bookingId);
                LOGGER.log(Level.WARNING, "[IPN] ❌ Transaction failed (Code: {0}), Booking {1} cancelled",
                        new Object[]{vnp_ResponseCode, bookingId});
                payment.setStatus("failed");
                paymentDao.insertPayment(payment);
                resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Order cancelled\"}");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "[IPN] Invalid number format", e);
            resp.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Invalid format\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[IPN] Unexpected error", e);
            resp.getWriter().write("{\"RspCode\":\"99\",\"Message\":\"Unknown error\"}");
        }
    }
}