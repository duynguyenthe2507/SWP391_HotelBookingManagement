package Controller.General;

import Services.BookingService;
import Utils.VnPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PaymentReturnController", urlPatterns = {"/paymentReturn"})
public class PaymentReturnController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentReturnController.class.getName());
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        System.out.println("========================================");
        System.out.println(">>> PAYMENT RETURN CONTROLLER ĐƯỢC GỌI");
        System.out.println("========================================");

        Map<String, String> vnp_Params = new HashMap<>();
        
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            
            if (fieldValue != null && fieldValue.length() > 0) {
                vnp_Params.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = vnp_Params.remove("vnp_SecureHash");
        vnp_Params.remove("vnp_SecureHashType");
        String computedHash = VnPayConfig.hashAllFields(vnp_Params);

        String txnRef = vnp_Params.get("vnp_TxnRef");
        String responseCode = vnp_Params.get("vnp_ResponseCode");

        LOGGER.log(Level.INFO, "[Return] txnRef={0}, responseCode={1}", 
                   new Object[]{txnRef, responseCode});
        LOGGER.log(Level.INFO, "[Return] Computed Hash={0}", computedHash);
        LOGGER.log(Level.INFO, "[Return] Received Hash={0}", vnp_SecureHash);

        String message;

        if (vnp_SecureHash == null || !computedHash.equals(vnp_SecureHash)) {
            LOGGER.warning("[Return] ❌ Signature verification FAILED!");
            message = "❗ Chữ ký không hợp lệ.";
        } else {
            LOGGER.info("[Return] ✅ Signature verification SUCCESS.");
            
            // Parse bookingId
            int bookingId = 0;
            try {
                if (txnRef != null) {
                    bookingId = Integer.parseInt(txnRef.contains("_") ? txnRef.split("_")[0] : txnRef);
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.SEVERE, "Invalid txnRef: " + txnRef, e);
            }
            
            // ✅ QUAN TRỌNG: Confirm booking khi thanh toán thành công
            if ("00".equals(responseCode) && bookingId > 0) {
                System.out.println(">>> Attempting to confirm booking ID: " + bookingId);
                
                try {
                    boolean confirmed = bookingService.confirmBooking(bookingId);
                    
                    if (confirmed) {
                        System.out.println(">>> ✅ BOOKING CONFIRMED SUCCESSFULLY!");
                        LOGGER.log(Level.INFO, "[Return] ✅ Booking {0} confirmed, room set to BOOKED", bookingId);
                    } else {
                        System.out.println(">>> ❌ FAILED TO CONFIRM BOOKING!");
                        LOGGER.log(Level.WARNING, "[Return] ⚠️ Failed to confirm booking {0}", bookingId);
                    }
                } catch (Exception e) {
                    System.out.println(">>> ❌ EXCEPTION while confirming booking!");
                    e.printStackTrace();
                    LOGGER.log(Level.SEVERE, "[Return] ❌ Error confirming booking " + bookingId, e);
                }
            } else if ("24".equals(responseCode) && bookingId > 0) {
                // User hủy thanh toán → Hủy booking
                System.out.println(">>> User cancelled payment, cancelling booking ID: " + bookingId);
                try {
                    bookingService.cancelBooking(bookingId);
                    LOGGER.log(Level.INFO, "[Return] Booking {0} cancelled (user cancelled payment)", bookingId);
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "[Return] Error cancelling booking " + bookingId, e);
                }
            }
            
            // Tạo message cho user
            switch (responseCode) {
                case "00":
                    message = String.format(
                        "🎉 <strong>Thanh toán thành công!</strong><br><br>" +
                        "📋 Mã đơn hàng: <strong>#%d</strong><br>" +
                        "✅ Phòng đã được đặt thành công!<br>" +
                        "Cảm ơn bạn đã tin tưởng chúng tôi!",
                        bookingId
                    );
                    break;
                case "24":
                    message = String.format(
                        "⚠️ <strong>Bạn đã hủy thanh toán</strong><br><br>" +
                        "📋 Mã đơn hàng: <strong>#%d</strong><br>" +
                        "Đơn hàng đã được hủy.<br>" +
                        "Bạn có thể thử lại bất cứ lúc nào.",
                        bookingId
                    );
                    break;
                default:
                    message = String.format(
                        "❌ <strong>Giao dịch thất bại</strong><br><br>" +
                        "📋 Mã đơn hàng: <strong>#%d</strong><br>" +
                        "⚠️ Mã lỗi: <strong>%s</strong><br>" +
                        "Vui lòng thử lại hoặc liên hệ hỗ trợ.",
                        bookingId,
                        responseCode
                    );
                    break;
            }
        }

        System.out.println("========================================");
        request.setAttribute("message", message);
        request.getRequestDispatcher("/pages/user/paymentResult.jsp").forward(request, response);
    }
}