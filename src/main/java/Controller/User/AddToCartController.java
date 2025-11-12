package Controller.User;

import Dao.CartDao;
import Dao.WishlistDao;
import Models.Cart;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/add-to-cart"})
public class AddToCartController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedInUser");

        // Check login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int userId = user.getUserId();

            CartDao cartDao = new CartDao();

            // Check room đã có trong giỏ hàng chưa
            Cart existingItem = cartDao.getCartItemByUserAndRoom(userId, roomId);

            if (existingItem != null) {
                // Nếu đã tồn tại, cập nhật số lượng
                int newQuantity = existingItem.getQuantity() + quantity;
                cartDao.updateCartQuantity(existingItem.getCartId(), newQuantity);
            } else {
                // Nếu chưa tồn tại, thêm mới
                Cart newCartEntry = new Cart();
                newCartEntry.setUserId(userId);
                newCartEntry.setRoomId(roomId);
                newCartEntry.setQuantity(quantity);
                cartDao.addToCart(newCartEntry);
            }

            // Check source yêu cầu xóa item
            String source = request.getParameter("source");
            if ("wishlist".equals(source)) {
                int wishlistId = Integer.parseInt(request.getParameter("wishlistId"));
                WishlistDao wishlistDao = new WishlistDao();
                wishlistDao.removeFromWishlist(wishlistId);
            }

            // Chuyển hướng đến trang giỏ hàng
            response.sendRedirect("cart");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}