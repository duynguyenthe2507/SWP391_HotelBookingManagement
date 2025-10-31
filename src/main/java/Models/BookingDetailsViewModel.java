package Models;

import lombok.*;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingDetailsViewModel {
    private Booking booking;
    private Room room;
    private String customerName;
    private String receptionistName;
    private List<Map<String, Object>> services;
}