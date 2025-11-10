package Controller.Admin;

import Dao.UsersDao;
import Dao.RankDao;
import Models.Users;
import Models.Rank;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewUserDetailController", urlPatterns = "/admin/user-details")
public class ViewUserDetailController extends HttpServlet {

    private UsersDao usersDao = new UsersDao();
    private RankDao rankDao = new RankDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy userId từ parameter
        String userIdParam = request.getParameter("id");

        if (userIdParam == null || userIdParam.isEmpty()) {
            request.setAttribute("error", "User ID is required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/user-list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Lấy thông tin user từ DAO
            Users user = usersDao.getById(userId);

            if (user == null) {
                request.setAttribute("error", "User not found");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/user-list.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Lấy thông tin rank nếu có
            String rankName = "N/A";
            if (user.getRankId() != null && user.getRankId() > 0) {
                Rank rank = rankDao.getById(user.getRankId());
                if (rank != null) {
                    rankName = rank.getName();
                }
            }

            // Set attributes cho JSP
            request.setAttribute("user", user);
            request.setAttribute("rankName", rankName);

            // Forward đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/user-details.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid User ID");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/user-list.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy userId từ parameter
        String userIdParam = request.getParameter("userId");
        String action = request.getParameter("action");

        if (userIdParam == null || userIdParam.isEmpty()) {
            request.setAttribute("error", "User ID is required");
            response.sendRedirect(request.getContextPath() + "/viewuser");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Lấy user hiện tại để giữ nguyên các thông tin khác
            Users user = usersDao.getById(userId);
            if (user == null) {
                request.setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/viewuser");
                return;
            }

            String newRole = user.getRole();
            boolean newStatus = user.isActive();

            // Xử lý action
            if ("updateRole".equals(action)) {
                String role = request.getParameter("role");
                if (role != null && (role.equals("receptionist") || role.equals("user"))) {
                    // Map "user" to "customer" vì trong database role là "customer" không phải
                    // "user"
                    newRole = role.equals("user") ? "customer" : role;
                } else {
                    request.setAttribute("error", "Invalid role");
                    response.sendRedirect(request.getContextPath() + "/admin/user-details?id=" + userId);
                    return;
                }
            } else if ("toggleStatus".equals(action)) {
                // Toggle status: active <-> inactive
                newStatus = !user.isActive();
            } else {
                request.setAttribute("error", "Invalid action");
                response.sendRedirect(request.getContextPath() + "/admin/user-details?id=" + userId);
                return;
            }

            // Update trong database
            boolean success = usersDao.updateRoleAndStatus(userId, newRole, newStatus);

            if (success) {
                request.setAttribute("success", "User updated successfully");
            } else {
                request.setAttribute("error", "Failed to update user");
            }

            // Redirect về trang user-details để hiển thị lại với thông tin mới
            response.sendRedirect(request.getContextPath() + "/admin/user-details?id=" + userId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid User ID");
            response.sendRedirect(request.getContextPath() + "/viewuser");
        }
    }
}
