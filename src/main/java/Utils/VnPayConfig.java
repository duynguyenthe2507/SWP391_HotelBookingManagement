package Utils;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.http.HttpServletRequest;

public class VnPayConfig {

    private static final Logger LOGGER = Logger.getLogger(VnPayConfig.class.getName());

    // Các biến cấu hình (sẽ được load từ file properties)
    public static String VNP_TMN_CODE;
    public static String VNP_HASH_SECRET;
    public static String VNP_PAY_URL;
    public static String APP_BASE_URL; // URL gốc (Ngrok hoặc Localhost)

    // Context path của ứng dụng
    private static final String CONTEXT_PATH = "/hmbs";

    // Các URL đầy đủ (được tạo động)
    public static String VNP_IPN_URL;
    public static String VNP_RETURN_URL;

    // Khối static để tải cấu hình ngay khi class được nạp
    static {
        try (InputStream input = VnPayConfig.class.getClassLoader().getResourceAsStream("config.properties")) {
            Properties prop = new Properties();

            if (input == null) {
                LOGGER.log(Level.SEVERE, "Sorry, unable to find config.properties");
                // Fallback values hoặc throw RuntimeException tùy bạn
            } else {
                prop.load(input);

                // Đọc từ file config
                VNP_TMN_CODE = prop.getProperty("vnpay.tmnCode");
                VNP_HASH_SECRET = prop.getProperty("vnpay.hashSecret");
                VNP_PAY_URL = prop.getProperty("vnpay.payUrl");
                APP_BASE_URL = prop.getProperty("app.baseUrl");

                // Xử lý URL (xóa dấu gạch chéo cuối nếu có để tránh lỗi //)
                if (APP_BASE_URL != null && APP_BASE_URL.endsWith("/")) {
                    APP_BASE_URL = APP_BASE_URL.substring(0, APP_BASE_URL.length() - 1);
                }

                // Tạo các URL hoàn chỉnh
                VNP_IPN_URL = APP_BASE_URL + CONTEXT_PATH + "/ipnHandler";
                VNP_RETURN_URL = APP_BASE_URL + CONTEXT_PATH + "/paymentReturn";

                LOGGER.log(Level.INFO, "VnPayConfig loaded successfully. Base URL: {0}", APP_BASE_URL);
            }
        } catch (IOException ex) {
            LOGGER.log(Level.SEVERE, "Error loading config.properties", ex);
        }
    }

    // --- GIỮ NGUYÊN CÁC HÀM TIỆN ÍCH BÊN DƯỚI ---

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
                try {
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                } catch (UnsupportedEncodingException e) {
                    LOGGER.log(Level.SEVERE, "Error encoding field value", e);
                }

                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        String dataToHash = hashData.toString();
        LOGGER.log(Level.FINE, "[Hash] Data to hash: {0}", dataToHash);

        return hmacSHA512(VNP_HASH_SECRET, dataToHash);
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
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)
                || "0:0:0:0:0:0:0:1".equals(ipAddress) || "127.0.0.1".equals(ipAddress)) {
            ipAddress = "13.160.92.202"; // IP fallback
            LOGGER.log(Level.WARNING, "Using fallback IP: {0}", ipAddress);
        }
        return ipAddress;
    }

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