package Models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Lớp này dùng để chứa dữ liệu JOIN từ bảng Cart và Room
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartItem {
    // Thuộc tính từ bảng Cart
    private int cartId;
    private int userId;
    private int quantity;

    // Thuộc tính từ bảng Room (JOIN vào)
    private int roomId;
    private String roomName;
    private double price;
    private String roomImgUrl; // Giả sử bảng Room có cột imgUrl

    // Thuộc tính tính toán
    public double getTotalPrice() {
        return price * quantity;
    }
}