package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Booking {
    private int bookingId;
    private int userId;
    private LocalDateTime checkinTime;
    private LocalDateTime checkoutTime;
    private double durationHours;
    private String status; // pending / confirmed / cancelled
    private double totalPrice;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
