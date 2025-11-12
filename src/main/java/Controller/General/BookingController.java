package Controller.General;

import Dao.RoomDao;
import Models.Booking;
import Models.BookingDetail; 
import Models.Room;
import Models.Users;
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
import java.util.Arrays;
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
    private LocalDateTime parseFlexibleDate(String dateStr, String defaultTime) throws DateTimeParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            throw new DateTimeParseException("Date string is empty", dateStr, 0);
        }
        List<String> formats = List.of(
                "dd/MM/yyyy HH:mm", "d/M/yyyy HH:mm", "dd-MM-yyyy HH:mm",
                "d-M-yyyy HH:mm", "d MMMM, yyyy HH:mm", "d MMM yyyy HH:mm"
        );
        for (String fmt : formats) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern(fmt, Locale.ENGLISH);
                return LocalDateTime.parse(dateStr.trim() + " " + defaultTime, formatter);
            } catch (Exception ignored) {}
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.ENGLISH);
            return LocalDateTime.parse(dateStr.trim() + " " + defaultTime, formatter);
        } catch (Exception ignored) {}
        
        throw new DateTimeParseException("Unsupported date format", dateStr, 0);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "GET request to BookingController, redirecting to /rooms.");
        response.sendRedirect(request.getContextPath() + "/rooms");
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // === BƯỚC 1: LẤY VÀ KIỂM TRA DỮ LIỆU (Validate data first) ===
        String roomIdStr = request.getParameter("roomId");
        String checkInDateStr = request.getParameter("checkInDate");
        String checkOutDateStr = request.getParameter("checkOutDate");
        String numGuestsStr = request.getParameter("numGuests");
        String specialRequest = request.getParameter("specialRequest");
        String[] serviceIds = request.getParameterValues("serviceIds");

        LOGGER.log(Level.INFO, "Received booking request: roomId={0}, checkIn={1}, checkOut={2}, guests={3}",
                new Object[]{roomIdStr, checkInDateStr, checkOutDateStr, numGuestsStr});

        // === THÊM LOG CHẨN ĐOÁN MỚI ===
        if (serviceIds != null && serviceIds.length > 0) {
            LOGGER.log(Level.INFO, "Received serviceIds: " + String.join(", ", serviceIds));
        } else {
            LOGGER.log(Level.WARNING, "Received NO serviceIds. (serviceIds parameter is null or empty)");
        }
        // === KẾT THÚC LOG MỚI ===

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
            session.setAttribute("cartMessage", "Room ID or number of guests is invalid.");
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        } catch (DateTimeParseException e) {
            session.setAttribute("cartMessage", "Invalid date format. Please use calendar (dd/mm/yyyy).");
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        } catch (Exception e) {
            session.setAttribute("cartMessage", e.getMessage());
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        }
        if (!bookingService.isRoomAvailable(roomId, checkIn, checkOut)) {
            session.setAttribute("cartMessage", "Room is not available for Booking.");
            session.setAttribute("cartMessageType", "WARNING");
            response.sendRedirect(redirectOnErrorUrl);
            return;
        }

        Room room = roomDao.getById(roomId);
        if (room == null) {
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
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            LOGGER.log(Level.INFO, "User not logged in. Saving booking intent to session and redirecting to login.");
            BookingDetail bookingDetail = new BookingDetail(
                    roomId, room.getPrice(), numGuests, room.getName(), room.getImgUrl()
            );
            List<BookingDetail> cart = new ArrayList<>();
            cart.add(bookingDetail);
            session.setAttribute("cart", cart);
            session.setAttribute("cartCheckIn", checkIn);
            session.setAttribute("cartCheckOut", checkOut);
            if (serviceIds != null) {
                session.setAttribute("cartServiceIds", Arrays.asList(serviceIds));
            } else {
                session.removeAttribute("cartServiceIds");
            }
            session.setAttribute("redirectUrl", request.getContextPath() + "/checkout"); 
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            List<Integer> roomIds = List.of(roomId);
            List<Integer> quantities = List.of(numGuests);

            LOGGER.info(">>> BookingController: (User logged in) Calling bookingService.createBooking()...");
            int bookingId = bookingService.createBooking(
                    user.getUserId(),
                    roomIds,
                    checkIn,
                    checkOut,
                    quantities,
                    null, 
                    "pending",
                    (serviceIds != null) ? Arrays.asList(serviceIds) : null
            );

            if (bookingId != -1) {
                LOGGER.info(">>> BookingController: Booking created successfully (ID: " + bookingId + ").");
                Booking createdBooking = bookingService.getBookingById(bookingId);
                
                if (createdBooking == null) {
                     throw new Exception("Failed to retrieve newly created booking details for VNPAY.");
                }

                request.setAttribute("bookingId", createdBooking.getBookingId());
                request.setAttribute("totalPrice", createdBooking.getTotalPrice());
                
                LOGGER.info(">>> BookingController: Forwarding to /createPayment.");
                request.getRequestDispatcher("/createPayment").forward(request, response);

            } else {
                 LOGGER.log(Level.SEVERE, ">>> BookingController: bookingService.createBooking() returned -1.");
                 session.setAttribute("cartMessage", "Could not create your booking. Please try again.");
                 session.setAttribute("cartMessageType", "ERROR");
                 response.sendRedirect(redirectOnErrorUrl);
            }

        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error during booking creation process in BookingController", e);
             session.setAttribute("cartMessage", "An unexpected error occurred: " + e.getMessage());
             session.setAttribute("cartMessageType", "ERROR");
             response.sendRedirect(redirectOnErrorUrl);
        }
    }
}
