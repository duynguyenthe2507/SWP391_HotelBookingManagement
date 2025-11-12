package Models;

import java.util.List;
import java.util.Map;
import Models.Feedback;


public class BookingDetailsViewModel {
    private Booking booking;
    private Room room;
    private String customerName;
    private String receptionistName;
    private List<Map<String, Object>> services;
    private Integer invoiceId;
    private Feedback feedback;

    public BookingDetailsViewModel() {
    }

    public BookingDetailsViewModel(Booking booking, Room room, String customerName, String receptionistName, List<Map<String, Object>> services, Integer invoiceId, Feedback feedback) {
        this.booking = booking;
        this.room = room;
        this.customerName = customerName;
        this.receptionistName = receptionistName;
        this.services = services;
        this.invoiceId = invoiceId;
        this.feedback = feedback;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getReceptionistName() {
        return receptionistName;
    }

    public void setReceptionistName(String receptionistName) {
        this.receptionistName = receptionistName;
    }

    public List<Map<String, Object>> getServices() {
        return services;
    }

    public void setServices(List<Map<String, Object>> services) {
        this.services = services;
    }

    public Integer getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(Integer invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Feedback getFeedback() {
        return feedback;
    }

    public void setFeedback(Feedback feedback) {
        this.feedback = feedback;
    }
}