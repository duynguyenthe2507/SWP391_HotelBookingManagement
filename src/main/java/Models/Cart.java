package Models;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cart {

    private int cartId;
    private int userId;
    private int roomId;
    private int quantity;

}
