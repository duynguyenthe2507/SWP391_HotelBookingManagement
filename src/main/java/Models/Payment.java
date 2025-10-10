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
    private String method;
    private String status; // pending / completed / failed
    private LocalDateTime transactionTime;
    private LocalDateTime updatedAt;
}
