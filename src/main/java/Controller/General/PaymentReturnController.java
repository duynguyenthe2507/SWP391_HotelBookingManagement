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

@WebServlet(name = "PaymentReturnServlet", urlPatterns = {"/paymentReturn"})
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
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                vnp_Params.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = vnp_Params.remove("vnp_SecureHash");
        String signValue = Utils.VnPayConfig.hashAllFields(vnp_Params);
        String txnRef = vnp_Params.get("vnp_TxnRef"); // bookingId
        String responseCode = vnp_Params.get("vnp_ResponseCode");

        LOGGER.log(Level.INFO, "Return from VNPAY: txnRef={0}, responseCode={1}", new Object[]{txnRef, responseCode});

        String message;
        if (signValue.equals(vnp_SecureHash)) {
            BookingDao bookingDao = new BookingDao();
            int bookingId = Integer.parseInt(txnRef);
            Booking booking = bookingDao.getBookingById(bookingId);

            if (booking != null) {
                if ("00".equals(responseCode)) {
                    bookingDao.updateBookingStatus(bookingId, "PAID");
                    message = "🎉 Thanh toán thành công! Mã đơn hàng: " + bookingId;
                } else {
                    bookingDao.updateBookingStatus(bookingId, "FAILED");
                    message = "❌ Thanh toán thất bại hoặc bị hủy. Mã đơn hàng: " + bookingId;
                }
            } else {
                message = "Không tìm thấy thông tin đơn hàng!";
            }
        } else {
            message = "❗ Chữ ký xác thực không hợp lệ. Dữ liệu có thể bị thay đổi.";
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("/pages/user/paymentResult.jsp").forward(request, response);
    }
}
