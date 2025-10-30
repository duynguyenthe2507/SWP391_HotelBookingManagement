package Utils;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Lớp cấu hình chứa các thông tin và hàm tiện ích cho VNPAY.
 */
public class VnPayConfig {

    private static final Logger LOGGER = Logger.getLogger(VnPayConfig.class.getName());

    // --- Thông tin cấu hình Merchant ---
    public static final String VNP_TMN_CODE = "G443SY3R";
    public static final String VNP_HASH_SECRET = "WQWWG735659GLAIEXRWV88DVKL20KZVA";
    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    // --- Thông tin URL (Cần khớp với NGROK và Context Path) ---
    // <<< URL NGROK CỦA BẠN (Cần cập nhật nếu khởi động lại ngrok) >>>
    private static final String NGROK_URL = "https://unshrunken-ardith-nondichotomous.ngrok-free.dev"; 
    
    // <<< Context Path ứng dụng của bạn (Lấy từ lỗi 404) >>>
    private static final String CONTEXT_PATH = "/HotelAManagement"; 

    /**
     * URL IPN (Server-to-Server) trỏ đến IpnHandlerServlet.
     */
    public static final String VNP_IPN_URL = NGROK_URL + CONTEXT_PATH + "/ipnHandler";

    /**
     * URL Return (Client) trỏ đến trang kết quả JSP.
     * Đảm bảo file này tồn tại ở /pages/user/paymentResult.jsp
     */
    public static final String VNP_RETURN_URL = NGROK_URL + CONTEXT_PATH + "/paymentReturn";


    // --- Các hàm tiện ích ---

    /**
     * Hàm tạo chữ ký bảo mật HmacSHA512.
     */
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                LOGGER.log(Level.SEVERE, "Key or data for HMAC SHA512 is null");
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error generating HMAC SHA512", ex);
            return "";
        }
    }

    /**
     * Hàm tạo chuỗi hash để xác thực chữ ký từ VNPAY IPN.
     */
    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(fieldValue); // IPN hash KHÔNG encode URL
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }
        return hmacSHA512(VNP_HASH_SECRET, hashData.toString());
    }

    public static String getIpAddress(HttpServletRequest request) {
        String ipAddress;
        try {
            ipAddress = request.getHeader("X-FORWARDED-FOR");
            if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                 ipAddress = request.getHeader("Proxy-Client-IP");
            }
             if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                 ipAddress = request.getHeader("WL-Proxy-Client-IP");
            }
             if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                ipAddress = request.getRemoteAddr();
                if ("127.0.0.1".equals(ipAddress) || "0:0:0:0:0:0:0:1".equals(ipAddress)) {
                     try {
                        java.net.InetAddress inetAddress = java.net.InetAddress.getLocalHost();
                        ipAddress = inetAddress.getHostAddress();
                     } catch (java.net.UnknownHostException e) {
                         ipAddress = "127.0.0.1";
                     }
                 }
            }
             if (ipAddress != null && ipAddress.length() > 15 && ipAddress.indexOf(",") > 0) {
                 ipAddress = ipAddress.substring(0, ipAddress.indexOf(","));
             }
        } catch (Exception e) {
            ipAddress = "Invalid IP:" + e.getMessage();
        }
         if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress) || "0:0:0:0:0:0:0:1".equals(ipAddress) || "127.0.0.1".equals(ipAddress) ) {
             ipAddress = "13.160.92.202"; // IP giả lập
             LOGGER.log(Level.WARNING, "Using fallback IP: {0}", ipAddress);
         }
        return ipAddress;
    }

    /**
     * Tạo một số ngẫu nhiên cho mã tham chiếu.
     */
    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}

