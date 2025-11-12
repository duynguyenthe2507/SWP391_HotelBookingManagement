package Controller.User;

import Dao.CartDao;
import Dao.RoomDao;
import Models.CartItem;
import Models.BookingDetail;
import Models.Room;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/cart/checkout"})
public class CartCheckoutController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CartCheckoutController.class.getName());
    private CartDao cartDao;
    private RoomDao roomDao;

    @Override
    public void init() throws ServletException {
        this.cartDao = new CartDao();
        this.roomDao = new RoomDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedInUser");

        // Kiểm tra đăng nhập
        if (user == null) {
            session.setAttribute("cartMessage", "Please login to continue booking.");
            session.setAttribute("cartMessageType", "WARNING");
            session.setAttribute("redirectUrl", request.getContextPath() + "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy danh sách cart items được chọn
            String[] selectedCartIds = request.getParameterValues("selectedItems");
            String checkInDateStr = request.getParameter("checkInDate");
            String checkOutDateStr = request.getParameter("checkOutDate");

            // Validate dữ liệu
            if (selectedCartIds == null || selectedCartIds.length == 0) {
                session.setAttribute("cartMessage", "Please select at least one room.");
                session.setAttribute("cartMessageType", "WARNING");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if (checkInDateStr == null || checkInDateStr.isEmpty() ||
                    checkOutDateStr == null || checkOutDateStr.isEmpty()) {
                session.setAttribute("cartMessage", "Please select check-in and check-out dates.");
                session.setAttribute("cartMessageType", "WARNING");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Parse dates
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDateTime checkIn = LocalDateTime.parse(checkInDateStr + " 14:00",
                    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            LocalDateTime checkOut = LocalDateTime.parse(checkOutDateStr + " 12:00",
                    DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

            // Validate dates
            if (!checkOut.isAfter(checkIn)) {
                session.setAttribute("cartMessage", "Check-out date must be after check-in date.");
                session.setAttribute("cartMessageType", "ERROR");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if (checkIn.toLocalDate().isBefore(java.time.LocalDate.now())) {
                session.setAttribute("cartMessage", "Check-in date cannot be in the past.");
                session.setAttribute("cartMessageType", "ERROR");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Lấy thông tin cart items
            List<BookingDetail> bookingDetailsList = new ArrayList<>();
            List<CartItem> allCartItems = cartDao.getCartByUserId(user.getUserId());

            for (String cartIdStr : selectedCartIds) {
                int cartId = Integer.parseInt(cartIdStr);

                // Tìm cart item tương ứng
                CartItem cartItem = allCartItems.stream()
                        .filter(item -> item.getCartId() == cartId)
                        .findFirst()
                        .orElse(null);

                if (cartItem != null) {
                    // Lấy quantity từ form
                    String quantityParam = request.getParameter("quantity_" + cartId);
                    int quantity = (quantityParam != null) ? Integer.parseInt(quantityParam) : cartItem.getQuantity();

                    // Lấy thông tin room
                    Room room = roomDao.getById(cartItem.getRoomId());
                    if (room == null) {
                        session.setAttribute("cartMessage", "Room not found: " + cartItem.getRoomName());
                        session.setAttribute("cartMessageType", "ERROR");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // Kiểm tra capacity
                    if (quantity > room.getCapacity()) {
                        session.setAttribute("cartMessage",
                                "Guests exceed capacity for room " + room.getName() + " (" + room.getCapacity() + ").");
                        session.setAttribute("cartMessageType", "WARNING");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }

                    // Tạo BookingDetail
                    BookingDetail detail = new BookingDetail(
                            room.getRoomId(),
                            room.getPrice(),
                            quantity,
                            room.getName(),
                            room.getImgUrl()
                    );
                    bookingDetailsList.add(detail);
                }
            }

            if (bookingDetailsList.isEmpty()) {
                session.setAttribute("cartMessage", "No valid items to book.");
                session.setAttribute("cartMessageType", "ERROR");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Lưu vào session để checkout
            session.setAttribute("cart", bookingDetailsList);
            session.setAttribute("cartCheckIn", checkIn);
            session.setAttribute("cartCheckOut", checkOut);

            LOGGER.log(Level.INFO, "Cart checkout prepared for user {0} with {1} items",
                    new Object[]{user.getUserId(), bookingDetailsList.size()});

            // Chuyển đến trang checkout
            response.sendRedirect(request.getContextPath() + "/checkout");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during cart checkout", e);
            session.setAttribute("cartMessage", "An error occurred: " + e.getMessage());
            session.setAttribute("cartMessageType", "ERROR");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}