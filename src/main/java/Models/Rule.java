package Models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Rule {
    private int ruleId;
    private String title;
    private String description;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
