package Models;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Wishlist {
    private int wishlistId;
    private int userId;
    private int roomId;
    private LocalDateTime updatedAt;
}
