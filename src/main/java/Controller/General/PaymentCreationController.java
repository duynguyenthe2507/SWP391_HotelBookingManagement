package Controller.General;

import Utils.VnPayConfig; // Đảm bảo import đúng
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets; // Sửa thành UTF-8
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet này xử lý việc tạo URL thanh toán VNPAY (bước cuối của Giai đoạn 4).
 * Đã sửa lỗi Checksum (sử dụng UTF-8).
 */
@WebServlet(name = "PaymentCreationController", urlPatterns = {"/createPayment"})
public class PaymentCreationController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentCreationController.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer bookingIdAttr = (Integer) req.getAttribute("bookingId");
        Double totalPriceAttr = (Double) req.getAttribute("totalPrice");

        if (bookingIdAttr == null || totalPriceAttr == null) {
            LOGGER.log(Level.SEVERE, "BookingId or TotalPrice is missing in request attributes.");
            req.getSession().setAttribute("cartMessage", "Lỗi tạo thanh toán: Thiếu thông tin đơn hàng.");
            req.getSession().setAttribute("cartMessageType", "ERROR");
            resp.sendRedirect(req.getContextPath() + "/checkout"); // Quay lại trang checkout
            return;
        }

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_OrderInfo = "Thanh toan don hang HMBS " + bookingIdAttr; // Mô tả thanh toán (không dấu cho chắc)
        String orderType = "other"; // Loại hàng hóa
        String vnp_TxnRef = String.valueOf(bookingIdAttr); // Mã Booking ID
        String vnp_IpAddr = VnPayConfig.getIpAddress(req);
        String vnp_TmnCode = VnPayConfig.VNP_TMN_CODE; // Đảm bảo gọi đúng tên biến

        long amount = (long) (totalPriceAttr * 100); // VNPAY yêu cầu * 100

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VnPayConfig.VNP_RETURN_URL); // Đảm bảo gọi đúng tên biến
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // Sắp xếp tham số và Tạo checksum
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                
                // === SỬA LỖI CHECKSUM: Dùng UTF-8 ===
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                // === KẾT THÚC SỬA LỖI ===

                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = VnPayConfig.hmacSHA512(VnPayConfig.VNP_HASH_SECRET, hashData.toString()); // Đảm bảo gọi đúng tên biến
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = VnPayConfig.VNP_PAY_URL + "?" + queryUrl; // Đảm bảo gọi đúng tên biến

        LOGGER.log(Level.INFO, "Redirecting user to VNPAY URL: {0}", paymentUrl);
        resp.sendRedirect(paymentUrl);
    }
}

