package Models;

import lombok.*;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Guideline {
    private int guidelineId;
    private Integer serviceId; // nullable
    private String title;
    private String content;
    private String imageUrl;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}