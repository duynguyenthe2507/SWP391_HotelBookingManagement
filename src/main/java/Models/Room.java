package Models;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Room {

    private int roomId;
    private String name;
    private int categoryId;
    private double price;
    private int capacity;
    private String status;
    private String description;
    private String imgUrl;
    private LocalDateTime updatedAt;

    private Category category;
}

