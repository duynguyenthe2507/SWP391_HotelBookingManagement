package Models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WishlistItem {
    private int wishlistId;
    private int userId;

    private int roomId;
    private String roomName;
    private double price;
    private String roomImgUrl;
}