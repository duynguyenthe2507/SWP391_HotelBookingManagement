package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ServiceRequest {
    private int requestId;
    private int bookingId;
    private int serviceTypeId;
    private double price;
    private String status; // requested / completed / cancelled
    private LocalDateTime updatedAt;
}
