package Controller.General;

import Dao.BookingDao;
import Models.Booking;
import Utils.VnPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PaymentReturnController", urlPatterns = {"/paymentReturn"})
public class PaymentReturnController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentReturnController.class.getName());

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

        Map<String, String> vnp_Params = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                vnp_Params.put(fieldName, fieldValue);
            }
        }

        // Lấy SecureHash và loại bỏ khỏi map để tránh ảnh hưởng khi ký lại
        String vnp_SecureHash = vnp_Params.remove("vnp_SecureHash");
        String computedHash = VnPayConfig.hashAllFields(vnp_Params);

        String txnRef = vnp_Params.get("vnp_TxnRef"); // bookingId
        String responseCode = vnp_Params.get("vnp_ResponseCode");

        LOGGER.log(Level.INFO, "[VNPay Return] txnRef={0}, responseCode={1}", new Object[]{txnRef, responseCode});

        String message;

        // 1️⃣ Kiểm tra tính hợp lệ của chữ ký
        if (!computedHash.equals(vnp_SecureHash)) {
            LOGGER.warning("VNPay signature verification failed!");
            message = "❗ Dữ liệu không hợp lệ hoặc bị thay đổi trong quá trình truyền.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/pages/user/paymentResult.jsp").forward(request, response);
            return;
        }

        // 2️⃣ Kiểm tra txnRef hợp lệ
        int bookingId;
        try {
            bookingId = Integer.parseInt(txnRef);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid bookingId from VNPay: {0}", txnRef);
            message = "Không tìm thấy mã đơn hàng hợp lệ.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/pages/user/paymentResult.jsp").forward(request, response);
            return;
        }

        // 3️⃣ Tìm đơn hàng trong DB
        BookingDao bookingDao = new BookingDao();
        Booking booking = bookingDao.getBookingById(bookingId);
        if (booking == null) {
            LOGGER.log(Level.WARNING, "Booking not found in database: {0}", bookingId);
            message = "Không tìm thấy đơn hàng trong hệ thống.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/pages/user/paymentResult.jsp").forward(request, response);
            return;
        }

        // 4️⃣ Xử lý kết quả thanh toán
        switch (responseCode) {
            case "00": // Thành công
                bookingDao.updateBookingStatus(bookingId, "PAID");
                message = "🎉 Thanh toán thành công! Cảm ơn bạn đã đặt phòng. Mã đơn hàng: " + bookingId;
                LOGGER.log(Level.INFO, "Payment success for booking #{0}", bookingId);
                break;

            case "24": // Người dùng hủy thanh toán
                bookingDao.updateBookingStatus(bookingId, "CANCELLED");
                message = "⚠️ Bạn đã hủy giao dịch thanh toán. Đơn hàng #" + bookingId + " chưa được thanh toán.";
                LOGGER.log(Level.INFO, "Payment cancelled for booking #{0}", bookingId);
                break;

            default: // Các mã lỗi khác
                bookingDao.updateBookingStatus(bookingId, "FAILED");
                message = "❌ Giao dịch thất bại (Mã lỗi: " + responseCode + "). Mã đơn hàng: " + bookingId;
                LOGGER.log(Level.WARNING, "Payment failed for booking #{0}, responseCode={1}",
                        new Object[]{bookingId, responseCode});
                break;
        }

        // 5️⃣ Gửi kết quả ra trang JSP
        request.setAttribute("message", message);
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("responseCode", responseCode);
        request.getRequestDispatcher("/pages/user/paymentResult.jsp").forward(request, response);
    }
}
