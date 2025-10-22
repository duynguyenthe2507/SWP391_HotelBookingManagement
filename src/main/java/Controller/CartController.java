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
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedInUser");

        // Check user login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy dữ liệu giỏ hàng từ DAO
        CartDao cartDao = new CartDao();
        List<CartItem> cartItems = cartDao.getCartByUserId(user.getUserId());
        System.out.println("So luong cart item lay duoc: " + cartItems.size());
        // Gửi data tới JSP
        request.setAttribute("cartItems", cartItems);

        // TÍNH TỔNG TIỀN
        double totalPrice = 0;
        for (CartItem item : cartItems) {
            totalPrice += item.getTotalPrice();
        }
        request.setAttribute("totalPrice", totalPrice);

        request.setAttribute("pageTitle", "Your Cart");
        request.setAttribute("currentPage", "Cart");

        // Chuyển tiếp tới trang Cart
        request.getRequestDispatcher("/pages/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}