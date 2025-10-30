package Controller.General;

import Dao.RoomDao;
import Models.BookingDetail;
import Models.Room;
import Services.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "BookingController", urlPatterns = {"/booking/add"})
public class BookingController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookingController.class.getName());
    private BookingService bookingService;
    private RoomDao roomDao;

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
        this.roomDao = new RoomDao();
    }

    /** 
     * Trả về LocalDateTime sau khi parse với nhiều định dạng phổ biến 
     * Hỗ trợ cả dd/MM/yyyy, dd-MM-yyyy, d MMMM, yyyy (English).
     */
    private LocalDateTime parseFlexibleDate(String dateStr, String defaultTime) throws DateTimeParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            throw new DateTimeParseException("Date string is empty", dateStr, 0);
        }

        List<String> formats = List.of(
            "dd/MM/yyyy HH:mm",
            "d/M/yyyy HH:mm",
            "dd-MM-yyyy HH:mm",
            "d-M-yyyy HH:mm",
            "d MMMM, yyyy HH:mm",   // e.g. 1 November, 2025
            "d MMM yyyy HH:mm"      // e.g. 1 Nov 2025
        );

        for (String fmt : formats) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern(fmt, Locale.ENGLISH);
                return LocalDateTime.parse(dateStr.trim() + " " + defaultTime, formatter);
            } catch (Exception ignored) {}
        }

        // Nếu tất cả định dạng đều fail
        throw new DateTimeParseException("Unsupported date format", dateStr, 0);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String roomIdStr = request.getParameter("roomId");
        String checkInDateStr = request.getParameter("checkInDate");
        String checkOutDateStr = request.getParameter("checkOutDate");
        String numGuestsStr = request.getParameter("numGuests");

        LOGGER.log(Level.INFO, "Received booking request: roomId={0}, checkIn={1}, checkOut={2}, guests={3}",
                new Object[]{roomIdStr, checkInDateStr, checkOutDateStr, numGuestsStr});

        String redirectOnErrorUrl = (roomIdStr != null && !roomIdStr.isEmpty())
                ? request.getContextPath() + "/room-details?roomId=" + roomIdStr
                : request.getContextPath() + "/rooms";

        int roomId, numGuests;
        LocalDateTime checkIn, checkOut;

        try {
            roomId = Integer.parseInt(roomIdStr);
            numGuests = Integer.parseInt(numGuestsStr);
            if (numGuests <= 0) throw new IllegalArgumentException("Number of guests must be positive.");

            checkIn = parseFlexibleDate(checkInDateStr, "14:00");
            checkOut = parseFlexibleDate(checkOutDateStr, "12:00");

            if (!checkOut.isAfter(checkIn)) {
                throw new Exception("Check-out date must be after check-in date.");
            }
            if (checkIn.toLocalDate().isBefore(java.time.LocalDate.now())) {
                throw new Exception("Check-in date cannot be in the past.");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid input (roomId/numGuests)", e);
            session.setAttribute("cartMessage", "Room ID or number of guests is invalid.");
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        } catch (DateTimeParseException e) {
            LOGGER.log(Level.WARNING, "Invalid date format: " + checkInDateStr + " / " + checkOutDateStr, e);
            session.setAttribute("cartMessage", "Invalid date format. Please use calendar (dd/mm/yyyy).");
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Validation error: " + e.getMessage());
            session.setAttribute("cartMessage", e.getMessage());
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        }

        // Check availability
        if (!bookingService.isRoomAvailable(roomId, checkIn, checkOut)) {
            LOGGER.log(Level.WARNING, "Room not available: " + roomId);
            session.setAttribute("cartMessage", "Room is not available for selected dates.");
            session.setAttribute("cartMessageType", "WARNING");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        }

        // Get room info
        Room room = roomDao.getById(roomId);
        if (room == null) {
            LOGGER.log(Level.SEVERE, "Room not found in DB: " + roomId);
            session.setAttribute("cartMessage", "Error retrieving room info.");
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        if (numGuests > room.getCapacity()) {
            session.setAttribute("cartMessage", "Guests exceed capacity (" + room.getCapacity() + ").");
            session.setAttribute("cartMessageType", "WARNING");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        }

        // Add to cart
        BookingDetail cartItem = new BookingDetail(
                roomId, room.getPrice(), numGuests, room.getName(), room.getImgUrl()
        );

        List<BookingDetail> cart = new ArrayList<>();
        cart.add(cartItem);

        session.setAttribute("cart", cart);
        session.setAttribute("cartCheckIn", checkIn);
        session.setAttribute("cartCheckOut", checkOut);
        session.setAttribute("cartMessage", "Room '" + room.getName() + "' added to your booking.");
        session.setAttribute("cartMessageType", "SUCCESS");

        LOGGER.info("Room " + roomId + " added to booking cart → Redirect to /checkout");
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}
