package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Services {
    private int serviceId;
    private String name;
    private double price;
    private String description;
    private LocalDateTime updatedAt;
}
