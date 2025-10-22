package Controller;

import Dao.WishlistDao;
import Models.Users;
import Models.WishlistItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/wishlist"})
public class WishlistController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        WishlistDao wishlistDao = new WishlistDao();
        List<WishlistItem> wishlistItems = wishlistDao.getWishlistByUserId(user.getUserId());
        System.out.println("So luong wishlist item lay duoc: " + wishlistItems.size());

        request.setAttribute("wishlistItems", wishlistItems);
        request.setAttribute("pageTitle", "Your Wishlist");
        request.setAttribute("currentPage", "Wishlist");

        request.getRequestDispatcher("/pages/user/wishlist.jsp").forward(request, response);
    }
}