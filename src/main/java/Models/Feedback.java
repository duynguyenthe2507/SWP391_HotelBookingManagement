package Models;

import java.time.LocalDateTime;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

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
    private LocalDateTime updatedAt;
    
    private String userFirstName;
    private String userLastName;
    private String userAvatarUrl;

    public Feedback(int userId, int bookingId, String content, int rating) {
        this.userId = userId;
        this.bookingId = bookingId;
        this.content = content;
        this.rating = rating;
    }
}