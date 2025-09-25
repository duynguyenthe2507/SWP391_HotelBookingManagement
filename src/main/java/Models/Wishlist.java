package Models;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Wishlist {

    private int wishlistId;
    private int userId;
    private int roomId;
}
