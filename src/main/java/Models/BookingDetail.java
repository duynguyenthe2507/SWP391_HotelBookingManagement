package Models;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class BookingDetail {

    private int bookingDetailId;
    private int bookingId;
    private int roomId;
    private double priceAtBooking;
    private int guestCount;
    private String specialRequest;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String roomName;
    private String roomImgUrl;
    
    private LocalDateTime checkInDate;
    private LocalDateTime checkOutDate;


    public BookingDetail() {
    }

    public BookingDetail(int bookingDetailId, int bookingId, int roomId, double priceAtBooking,
                         int guestCount, String specialRequest, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.bookingDetailId = bookingDetailId;
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.priceAtBooking = priceAtBooking;
        this.guestCount = guestCount;
        this.specialRequest = specialRequest;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public BookingDetail(int roomId, double priceAtBooking, int guestCount, String roomName, String roomImgUrl) {
        this.roomId = roomId;
        this.priceAtBooking = priceAtBooking;
        this.guestCount = guestCount;
        this.roomName = roomName;
        this.roomImgUrl = roomImgUrl;
    }
    
}

