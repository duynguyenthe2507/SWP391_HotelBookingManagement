package Models;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Room {

    private int roomId;
    private String name;
    private String type;
    private double price;
    private int capacity;
    private String status;
    private String description;
}
