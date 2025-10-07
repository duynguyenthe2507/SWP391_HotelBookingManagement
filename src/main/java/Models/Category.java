package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Category {
    private int categoryId;
    private String name;
    private String description;
    private LocalDateTime updatedAt;
}
