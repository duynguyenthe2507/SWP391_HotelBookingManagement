package Models;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GuestRequest {
    private Integer requestId;
    private Integer bookingId;
    private Integer userId;
    private String  requestType;   // Room Service, Housekeeping, Special Inquiry, ...
    private String  content;       // mô tả yêu cầu
    private String  status;        // pending | replied | resolved | cancelled
    private String  replyText;     // phản hồi của lễ tân (nếu có)
    private Integer repliedBy;     // userId của lễ tân (nullable)
    private Date    repliedAt;     // thời điểm phản hồi (nullable)
    private Date    createdAt;
    private Date    updatedAt;

    // --- mới thêm để hỗ trợ tính năng "đã xem" ---
    private Boolean isSeen;        // lễ tân đã mở yêu cầu hay chưa
    private Date    seenAt;        // thời điểm lễ tân mở yêu cầu
}