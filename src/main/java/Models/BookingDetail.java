package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingDetail {
    private int bookingDetailId;
    private int bookingId;
    private int roomId;
    private double priceAtBooking;
    private int guestCount;
    private String specialRequest;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
