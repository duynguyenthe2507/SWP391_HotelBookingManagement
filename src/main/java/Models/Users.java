package Models;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Users {
    private int userId;
    private String mobilePhone;
    private String firstName;
    private String middleName;
    private String lastName;
    private LocalDate birthday;
    private String email;
    private String password;
    private String role;
    private Integer rankId;
    private boolean isBlackList;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
