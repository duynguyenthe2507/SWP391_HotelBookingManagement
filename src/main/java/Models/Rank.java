package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Rank {
    private int rankId;
    private String name;
    private String description;
    private int minBookings;
    private double discountPercentage;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
