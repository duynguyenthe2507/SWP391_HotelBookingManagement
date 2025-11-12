package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Booking {
    private int bookingId;
    private Integer userId;
    private Integer receptionistId;
    private String guestName;
    private int roomId;
    private LocalDateTime checkinTime;
    private LocalDateTime checkoutTime;
    private int guestCount;
    private String specialRequest;
    private String status;
    private double totalPrice;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}