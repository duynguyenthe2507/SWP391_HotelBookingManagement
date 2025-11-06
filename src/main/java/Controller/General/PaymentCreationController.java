package Controller.General;

import Utils.VnPayConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

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
        
        LOGGER.info("PaymentCreationController started");
        
        Integer bookingIdAttr = (Integer) req.getAttribute("bookingId");
        Double totalPriceAttr = (Double) req.getAttribute("totalPrice");

        if (bookingIdAttr == null || totalPriceAttr == null) {
            LOGGER.log(Level.SEVERE, "BookingId or TotalPrice is missing");
            req.getSession().setAttribute("cartMessage", "Lỗi: Thiếu thông tin đơn hàng");
            req.getSession().setAttribute("cartMessageType", "ERROR");
            resp.sendRedirect(req.getContextPath() + "/checkout"); 
            return;
        }

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_OrderInfo = "Thanh toan don hang HMBS " + bookingIdAttr;
        String orderType = "other";
        String vnp_TxnRef = bookingIdAttr + "_" + System.currentTimeMillis();
        String vnp_IpAddr = VnPayConfig.getIpAddress(req);
        String vnp_TmnCode = VnPayConfig.VNP_TMN_CODE;
        long amount = (long) (totalPriceAttr * 100);

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
        vnp_Params.put("vnp_ReturnUrl", VnPayConfig.VNP_RETURN_URL);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        // ✅ QUAN TRỌNG: KHÔNG THÊM vnp_IpnUrl vào đây
        // Vì VNPay Sandbox không hỗ trợ IPN URL trong request
        // Phải cấu hình trong Dashboard

        // Sort params
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                // Build query URL
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                
                // Build hashData
                hashData.append(fieldName); 
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString())); 
                
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        
        String queryUrl = query.toString();
        String hashDataString = hashData.toString();
        
        String vnp_SecureHash = VnPayConfig.hmacSHA512(VnPayConfig.VNP_HASH_SECRET, hashDataString);
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash; 
        String paymentUrl = VnPayConfig.VNP_PAY_URL + "?" + queryUrl;
        
        LOGGER.log(Level.INFO, "Redirecting to VNPAY: {0}", paymentUrl);
        resp.sendRedirect(paymentUrl);
    }
}