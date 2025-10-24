package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Room {
    private int roomId;
    private String name;
    private int categoryId;
    private double price;
    private int capacity;
    private String status; // available / booked / maintenance
    private String description;
    private LocalDateTime updatedAt;
    private String imgUrl;
    private Category category;
}
