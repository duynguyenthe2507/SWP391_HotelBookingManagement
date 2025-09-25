package Models;
import lombok.*;
import java.time.LocalDateTime;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Feedback {
    private int feedbackId;
    private int userId;
    private int bookingId;
    private String content;
    private int rating;
    private LocalDateTime createdAt;
    
}
