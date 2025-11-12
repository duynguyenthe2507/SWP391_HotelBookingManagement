package Controller.General;

import Models.Booking;
import Models.BookingDetail;
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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "OrderController", urlPatterns = {"/order/create"})
public class OrderController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OrderController.class.getName());
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("!!!!!!!!!!!!!! ORDER CONTROLLER DOPOST BẮT ĐẦU !!!!!!!!!!!!!!");
        LOGGER.info(">>> OrderController doPost started.");

        HttpSession session = request.getSession(false);

        if (session == null) {
            System.out.println("!!! ORDER CONTROLLER LỖI: SESSION IS NULL !!!");
            LOGGER.severe("Session is null. Cannot proceed with order creation.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        List<BookingDetail> cart = (List<BookingDetail>) session.getAttribute("cart");
        LocalDateTime cartCheckIn = (LocalDateTime) session.getAttribute("cartCheckIn");
        LocalDateTime cartCheckOut = (LocalDateTime) session.getAttribute("cartCheckOut");
        
        List<String> serviceIds = (List<String>) session.getAttribute("cartServiceIds"); 

        List<String> specialRequests = (cart != null) ? cart.stream()
                .map(BookingDetail::getSpecialRequest)
                .collect(Collectors.toList()) : new ArrayList<>();
        
        String paymentMethod = request.getParameter("paymentMethod");

        System.out.println("Order Data Check: UserID=" + (user != null ? user.getUserId() : "null") +
                           ", CartItems=" + (cart != null ? cart.size() : "null") +
                           ", CheckIn=" + cartCheckIn + ", CheckOut=" + cartCheckOut +
                           ", PaymentMethod=" + paymentMethod);
        if (serviceIds != null) {
            LOGGER.log(Level.INFO, "[OrderController] Found {0} serviceIds in session: {1}", 
                       new Object[]{serviceIds.size(), String.join(", ", serviceIds)});
        } else {
            LOGGER.log(Level.WARNING, "[OrderController] serviceIds in session is NULL.");
        }


        if (user == null || cart == null || cart.isEmpty() || cartCheckIn == null || cartCheckOut == null || paymentMethod == null || paymentMethod.isEmpty()) {
             System.out.println("!!! ORDER CONTROLLER LỖI: THIẾU DỮ LIỆU ĐẦU VÀO !!!");
            LOGGER.log(Level.SEVERE, "Missing required data for order creation.");
            session.setAttribute("cartMessage", "Your booking session is incomplete or expired. Please start over.");
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        List<Integer> roomIds = cart.stream().map(BookingDetail::getRoomId).collect(Collectors.toList());
        List<Integer> quantities = cart.stream().map(BookingDetail::getGuestCount).collect(Collectors.toList());

        int bookingId = -1;
        try {
            System.out.println(">>> OrderController: Đang gọi bookingService.createBooking()...");
            bookingId = bookingService.createBooking(
                    user.getUserId(),
                    roomIds,
                    cartCheckIn,
                    cartCheckOut,
                    quantities,
                    specialRequests,
                    "pending",
                    serviceIds 
            );
            System.out.println(">>> OrderController: bookingService.createBooking() trả về: " + bookingId);


            if (bookingId != -1) {
                System.out.println(">>> OrderController: TẠO BOOKING THÀNH CÔNG (ID: " + bookingId + ")");
                LOGGER.info("Booking created successfully with ID: " + bookingId);

                session.removeAttribute("cart");
                session.removeAttribute("cartCheckIn");
                session.removeAttribute("cartCheckOut");
                session.removeAttribute("cartServiceIds"); // Xóa service IDs

                if ("COD".equalsIgnoreCase(paymentMethod)) {
                    System.out.println(">>> OrderController: Thanh toán COD. Redirect sang success page.");
                    
                    bookingService.confirmBooking(bookingId); 
                    session.setAttribute("successMessage", "Your booking #" + bookingId + " has been placed successfully! Please pay upon check-in.");
                    
                    response.sendRedirect(request.getContextPath() + "/paymentResult.jsp?bookingId=" + bookingId + "&RspCode=00&cod=true");
                    return;

                } else if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
                    System.out.println(">>> OrderController: Thanh toán VNPAY. Forward sang /createPayment.");
                     Booking createdBooking = bookingService.getBookingById(bookingId);
                     if (createdBooking == null) {
                          System.out.println("!!! ORDER CONTROLLER LỖI: Không thể lấy lại booking vừa tạo (ID: " + bookingId + ") !!!");
                          throw new Exception("Failed to retrieve newly created booking details for VNPAY.");
                     }

                    request.setAttribute("bookingId", bookingId);
                    request.setAttribute("totalPrice", createdBooking.getTotalPrice()); // Gửi tổng tiền ĐÚNG (đã tính bởi BookingService)
                    request.getRequestDispatcher("/createPayment").forward(request, response);
                    return;

                } else {
                     System.out.println("!!! ORDER CONTROLLER LỖI: Phương thức thanh toán không hợp lệ: " + paymentMethod + " !!!");
                     session.setAttribute("cartMessage", "Invalid payment method selected.");
                     session.setAttribute("cartMessageType", "ERROR");
                     response.sendRedirect(request.getContextPath() + "/checkout");
                     return;
                }

            } else {
                System.out.println("!!! ORDER CONTROLLER LỖI: bookingService.createBooking() trả về -1 !!!");
                LOGGER.log(Level.SEVERE, "BookingService.createBooking failed (returned -1) for user {0}.", user.getUserId());
                session.setAttribute("cartMessage", "Could not create your booking. Please check room availability again or contact support.");
                session.setAttribute("cartMessageType", "ERROR");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

        } catch (Exception e) {
             System.out.println("!!!!!!!!!!!!!! EXCEPTION caught in OrderController !!!!!!!!!!!!!!");
             e.printStackTrace(); 
            LOGGER.log(Level.SEVERE, "Error during order creation process for user " + (user != null ? user.getUserId() : "unknown"), e);
            session.setAttribute("cartMessage", "An unexpected error occurred: " + e.getMessage());
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
    }
}