package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Payment {
    private int paymentId;
    private int bookingId;
    private double amount;
    private String method; // Ví dụ: "COD", "VNPAY"
    private String status; // pending / completed / failed
    private LocalDateTime transactionTime; // Thời điểm giao dịch (khi VNPAY báo về hoặc khi COD)
    private LocalDateTime updatedAt;

    // === PHẦN BỔ SUNG: Các trường thông tin từ VNPAY ===
    private String vnpTransactionNo; // Mã giao dịch bên phía VNPAY
    private String vnpBankCode;      // Mã ngân hàng (VNPAYQR, NCB, VISA,...)
    // === KẾT THÚC PHẦN BỔ SUNG ===

    // Lombok @Data sẽ tự tạo getters/setters cho các trường mới.
}

