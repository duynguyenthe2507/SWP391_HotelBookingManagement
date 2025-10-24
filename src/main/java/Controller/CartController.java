package Controller;

import Dao.CartDao;
import Models.CartItem;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedInUser");

        // Check login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        CartDao cartDao = new CartDao();

        // Check có action xoá hay không
        if ("remove".equals(action)) {
            try {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                cartDao.removeFromCart(cartId);

                // Sau khi xóa thì redirect về trang giỏ hàng để tải lại dữ liệu mới
                response.sendRedirect("cart");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("cart");
                return;
            }
        }

        // Lấy cart items
        List<CartItem> cartItems = cartDao.getCartByUserId(user.getUserId());

        double totalPrice = 0;
        for (CartItem item : cartItems) {
            totalPrice += item.getTotalPrice();
        }

        request.setAttribute("pageTitle", "Your Cart");
        request.setAttribute("currentPage", "Cart");

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalPrice", totalPrice);

        // Chuyển tiếp tới trang Cart
        request.getRequestDispatcher("/pages/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}