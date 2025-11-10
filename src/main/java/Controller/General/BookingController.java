package Controller.General;

import Dao.RoomDao;
import Models.Booking;
import Models.BookingDetail; // <<< THÊM IMPORT
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

/**
 * Servlet này đã được SỬA LỖI LOGIC:
 * 1. Sửa lỗi 405 (Method Not Allowed).
 * 2. Sửa luồng đăng nhập:
 * - Nếu chưa đăng nhập, VALIDATE dữ liệu (phòng, ngày) trước.
 * - Nếu dữ liệu hợp lệ, LƯU giỏ hàng (cart) vào SESSION.
 * - Đặt redirectUrl là /checkout (thay vì /room-details).
 * - Chuyển đến /login.
 * 3. Nếu đã đăng nhập: Tạo booking 'pending' và FORWARD sang /createPayment.
 */
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

    /** Parse nhiều định dạng ngày linh hoạt (Giữ nguyên code gốc của bạn) **/
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
        throw new DateTimeParseException("Unsupported date format", dateStr, 0);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Sửa lỗi 405 (Method Not Allowed)
        // Nếu user bị redirect (GET) tới đây sau khi login, chuyển họ về trang phòng
        // (Logic mới ở doPost sẽ ngăn điều này xảy ra, nhưng đây là 1 phòng vệ tốt)
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
        // === KẾT THÚC BƯỚC 1 ===


        // === BƯỚC 2: KIỂM TRA PHÒNG (Validate room) ===
        
        // (BookingService và BookingDao của bạn đã được sửa lỗi này)
        if (!bookingService.isRoomAvailable(roomId, checkIn, checkOut)) {
            session.setAttribute("cartMessage", "Room is not available for selected dates.");
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
        // === KẾT THÚC BƯỚC 2 ===


        // === BƯỚC 3: KIỂM TRA ĐĂNG NHẬP (LOGIC MỚI THEO YÊU CẦU CỦA BẠN) ===
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            // User CHƯA đăng nhập. Lưu booking intent (giỏ hàng) vào session.
            LOGGER.log(Level.INFO, "User not logged in. Saving booking intent to session and redirecting to login.");

            // 1. Tạo giỏ hàng (cart)
            BookingDetail bookingDetail = new BookingDetail(
                    roomId, room.getPrice(), numGuests, room.getName(), room.getImgUrl()
            );
            List<BookingDetail> cart = new ArrayList<>();
            cart.add(bookingDetail);

            // 2. Lưu cart, ngày, và URL redirect (là /checkout)
            session.setAttribute("cart", cart);
            session.setAttribute("cartCheckIn", checkIn);
            session.setAttribute("cartCheckOut", checkOut);
            
            // 3. Đặt redirectUrl là /checkout (thay vì trang room-details)
            session.setAttribute("redirectUrl", request.getContextPath() + "/checkout"); 
            
            // 4. Chuyển đến trang login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // === KẾT THÚC BƯỚC 3 ===


        // === BƯỚC 4: USER ĐÃ ĐĂNG NHẬP - TẠO BOOKING THẬT VÀ FORWARD ===
        // (Nếu code chạy đến đây, user đã đăng nhập VÀ dữ liệu đã hợp lệ)
        
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
                    null, // Không có special request từ flow này
                    "pending",
                    (serviceIds != null) ? Arrays.asList(serviceIds) : null
            );

            if (bookingId != -1) {
                LOGGER.info(">>> BookingController: Booking created successfully (ID: " + bookingId + ").");
                Booking createdBooking = bookingService.getBookingById(bookingId);
                
                if (createdBooking == null) {
                     throw new Exception("Failed to retrieve newly created booking details for VNPAY.");
                }

                // Đính kèm attributes (Giống OrderController)
                request.setAttribute("bookingId", createdBooking.getBookingId());
                request.setAttribute("totalPrice", createdBooking.getTotalPrice());
                
                // FORWARD sang /createPayment (Giống OrderController)
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

