package Controller.General;

import Models.BookingDetail;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
// === THÊM IMPORT MỚI ===
import java.time.format.DateTimeFormatter;
// === KẾT THÚC IMPORT ===
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet này xử lý Giai đoạn 3: Trang Checkout.
 * URL: /checkout
 * Nhiệm vụ:
 * 1. Kiểm tra xem người dùng đã đăng nhập chưa (qua HttpSession).
 * 2. Nếu chưa, lưu URL hiện tại (/checkout) vào session và redirect sang trang login.
 * 3. Nếu đã đăng nhập, lấy thông tin giỏ hàng (cart), ngày check-in/out từ session.
 * 4. Tính toán tổng tiền dựa trên giá phòng và số đêm.
 * 5. Forward sang trang checkout.jsp để hiển thị thông tin và cho phép chọn phương thức thanh toán.
 */
@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CheckoutController.class.getName());
    // === THÊM FORMATTER MỚI ĐỂ HIỂN THỊ ===
    private static final DateTimeFormatter DISPLAY_FORMATTER = DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy");
    // === KẾT THÚC THÊM ===

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); 

        // 1. Kiểm tra đăng nhập
        Users loggedInUser = null;
        if (session != null) {
            loggedInUser = (Users) session.getAttribute("user");
        }

        if (loggedInUser == null) {
            LOGGER.log(Level.INFO, "User not logged in. Redirecting to login page.");
            if (session == null) {
                 session = request.getSession(); 
            }
            session.setAttribute("redirectUrl", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy thông tin giỏ hàng từ session
        List<BookingDetail> cart = (session != null) ? (List<BookingDetail>) session.getAttribute("cart") : null;
        LocalDateTime cartCheckIn = (session != null) ? (LocalDateTime) session.getAttribute("cartCheckIn") : null;
        LocalDateTime cartCheckOut = (session != null) ? (LocalDateTime) session.getAttribute("cartCheckOut") : null;

        if (cart == null || cart.isEmpty() || cartCheckIn == null || cartCheckOut == null) {
            LOGGER.log(Level.WARNING, "Cart is empty or date information is missing for user {0}. Redirecting to rooms page.", loggedInUser.getUserId());
            session.setAttribute("cartMessage", "Your booking session is empty or expired. Please select a room again.");
            session.setAttribute("cartMessageType", "WARNING");
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        // 3. Tính toán tổng tiền và số đêm
        double totalPrice = 0;
        long numberOfNights = 0;
        try {
            numberOfNights = Duration.between(cartCheckIn.toLocalDate().atStartOfDay(), cartCheckOut.toLocalDate().atStartOfDay()).toDays();
            if (numberOfNights <= 0) {
                 numberOfNights = 1;
                 LOGGER.log(Level.INFO, "Calculated duration is less than or equal to 0 days, defaulting to 1 night.");
            }

            for (BookingDetail item : cart) {
                totalPrice += item.getPriceAtBooking() * numberOfNights;
            }

             LOGGER.log(Level.INFO, "Calculated total price: {0} for {1} night(s). CheckIn: {2}, CheckOut: {3}",
                        new Object[]{totalPrice, numberOfNights, cartCheckIn, cartCheckOut});

        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error calculating total price or duration for checkout.", e);
             session.setAttribute("cartMessage", "Error calculating booking details. Please try selecting the room again.");
             session.setAttribute("cartMessageType", "ERROR");
             response.sendRedirect(request.getContextPath() + "/rooms");
             return;
        }


        // 4. Đặt các thuộc tính vào request để JSP hiển thị
        request.setAttribute("cart", cart);
        
        // === SỬA LỖI: Chuyển LocalDateTime thành String đã định dạng ===
        request.setAttribute("cartCheckInFormatted", cartCheckIn.format(DISPLAY_FORMATTER));
        request.setAttribute("cartCheckOutFormatted", cartCheckOut.format(DISPLAY_FORMATTER));
        // === KẾT THÚC SỬA LỖI ===
        
        request.setAttribute("numberOfNights", numberOfNights);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("user", loggedInUser); 

        // 5. Forward sang trang checkout.jsp
        LOGGER.log(Level.INFO, "Forwarding user {0} to checkout page.", loggedInUser.getUserId());
        request.getRequestDispatcher("/pages/user/checkout.jsp").forward(request, response); // Đảm bảo đường dẫn JSP đúng
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.WARNING, "Received POST request on CheckoutController, redirecting to GET.");
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}

