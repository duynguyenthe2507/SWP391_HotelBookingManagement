package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingHistory {
    private int historyId;
    private int userId; // FK -> Users
    private int bookingId; // FK -> Booking
    private LocalDateTime completedAt;
}
