package Models;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Payment {

    private int paymentId;
    private int bookingId;
    private double amount;
    private String method;
    private String status;
}
