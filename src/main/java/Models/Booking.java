package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Booking {

    private int bookingId;
    private int userId;
    private int roomId;
    private LocalDateTime checkinTime;
    private LocalDateTime checkoutTime;
    private double durationHours;
    private String status;
    private double totalPrice;

}
