package Controller.User;

import Dao.WishlistDao;
import Models.Users;
import Models.Wishlist;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/add-to-wishlist"})
public class AddWishlistController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedInUser");

        // Lấy trang mà người dùng vừa gửi request
        String referer = request.getHeader("Referer");

        // Kiểm tra đăng nhập
        if (user == null) {
            // Lưu lại trang đang xem để quay lại sau khi đăng nhập
            session.setAttribute("redirectUrl", referer);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy thông tin từ form
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int userId = user.getUserId();

            WishlistDao wishlistDao = new WishlistDao();

            // Kiểm tra xem phòng đã có trong wishlist chưa
            boolean alreadyExists = wishlistDao.checkIfExists(userId, roomId);

            if (alreadyExists) {
                session.setAttribute("wishlistMessage", "Room is already in your wishlist!");
            } else {
                // Tạo đối tượng Wishlist và thêm vào DB
                Wishlist newItem = new Wishlist();
                newItem.setUserId(userId);
                newItem.setRoomId(roomId);

                boolean success = wishlistDao.addToWishlist(newItem);

                if (success) {
                    session.setAttribute("wishlistMessage", "Added to wishlist!");
                } else {
                    session.setAttribute("wishlistMessage", "Failed to add to wishlist.");
                }
            }

            // Chuyển hướng người dùng
            response.sendRedirect(request.getContextPath() + "/wishlist");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }
}