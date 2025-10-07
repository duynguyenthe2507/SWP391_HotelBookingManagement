package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {
    private int invoiceId;
    private int bookingId;
    private double totalRoomCost;
    private double totalServiceCost;
    private double taxAmount;
    private double totalAmount;
    private LocalDateTime issuedDate;
    private LocalDateTime updatedAt;
}
