package Controller.Receptionist;

import Dao.GuestRequestDao;
import Models.GuestRequest;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ReplyGuestRequestController", urlPatterns = {
        "/receptionist/requests",            // List & Filter
        "/receptionist/requests/detail",     // Chi tiết & Đánh dấu đã xem
        "/receptionist/requests/send-reply", // Trả lời (POST)
        "/receptionist/requests/resolve",    // Hoàn tất (POST)
        "/receptionist/requests/delete"      // Xóa (POST)
})
public class ReplyGuestRequestController extends HttpServlet {

    private GuestRequestDao dao;

    @Override
    public void init() {
        dao = new GuestRequestDao();
    }

    // Lấy User ID từ session
    private Integer currentUserId(HttpServletRequest req) {
        Object userObj = req.getSession().getAttribute("user");
        if (userObj != null && userObj instanceof Users) {
            return ((Users) userObj).getUserId();
        }
        return null;
    }

    // Kiểm tra quyền Receptionist
    private boolean isReceptionist(HttpServletRequest req) {
        Object userObj = req.getSession().getAttribute("user");
        if (userObj instanceof Users) {
            String role = ((Users) userObj).getRole();
            return "receptionist".equalsIgnoreCase(role);
        }
        return false;
    }

    // Check role & redirect
    private boolean checkRoleAndRedirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Object userObj = req.getSession().getAttribute("user");

        if (userObj instanceof Users) {
            String role = ((Users) userObj).getRole();

            // Nếu Customer -> User Controller
            if ("customer".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/user/requests");
                return false;
            }

            // Nếu Admin -> Admin page
            if ("admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/viewuser");
                return false;
            }

            // Nếu Receptionist -> OK
            if ("receptionist".equalsIgnoreCase(role)) {
                return true;
            }

            // Role lạ
            req.getSession().setAttribute("flash_error", "Access denied.");
            resp.sendRedirect(req.getContextPath() + "/");
            return false;
        }

        return true;
    }

    private int parseInt(String s, int def) {
        if (s == null || s.trim().isEmpty()) return def;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = currentUserId(req);

        // Check login
        if (userId == null) {
            HttpSession session = req.getSession();
            String queryString = req.getQueryString();
            String fullUrl = req.getRequestURI() + (queryString != null ? "?" + queryString : "");
            session.setAttribute("redirectUrl", fullUrl);
            session.setAttribute("loginMessage", "Please login to use this feature.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Check role
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        String path = req.getServletPath();
        try {
            switch (path) {
                case "/receptionist/requests": {
                    String status = req.getParameter("status"); // Filter status
                    if (status == null || status.isEmpty()) status = "all";

                    List<GuestRequest> items = dao.findAll(status);
                    req.setAttribute("items", items);
                    req.setAttribute("status", status);
                    req.getRequestDispatcher("/pages/receptionist/requests-list.jsp").forward(req, resp);
                    break;
                }

                case "/receptionist/requests/detail": {
                    int id = parseInt(req.getParameter("id"), 0);

                    if (id <= 0) {
                        req.getSession().setAttribute("flash_error", "Invalid Request ID.");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    GuestRequest item = dao.findById(id);
                    if (item == null) {
                        req.getSession().setAttribute("flash_error", "Request not found #" + id);
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    // Đánh dấu đã xem
                    try {
                        dao.markSeen(id, userId);
                    } catch (Exception e) {
                        // Bỏ qua nếu chưa có cột này
                    }

                    req.setAttribute("item", item);
                    req.getRequestDispatcher("/pages/receptionist/request-reply.jsp").forward(req, resp);
                    break;
                }

                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = currentUserId(req);

        // Check login
        if (userId == null) {
            resp.sendError(401, "Login required.");
            return;
        }

        // Check role
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        String path = req.getServletPath();
        try {
            switch (path) {
                case "/receptionist/requests/send-reply": {
                    int id = parseInt(req.getParameter("id"), 0);
                    String replyText = req.getParameter("replyText");

                    // Validation
                    if (id <= 0) {
                        req.getSession().setAttribute("flash_error", "Invalid Request ID.");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    if (replyText == null || replyText.trim().isEmpty()) {
                        req.getSession().setAttribute("flash_error", "Please enter reply content.");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                        return;
                    }

                    boolean ok = dao.reply(id, replyText.trim(), userId);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "✅ Replied to request #" + id + " successfully!");
                    } else {
                        req.getSession().setAttribute("flash_error", "❌ Reply failed. Please try again.");
                    }

                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                    break;
                }

                case "/receptionist/requests/resolve": {
                    int id = parseInt(req.getParameter("id"), 0);

                    if (id <= 0) {
                        req.getSession().setAttribute("flash_error", "Invalid Request ID.");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    boolean ok = dao.resolve(id, userId);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "✅ Marked request #" + id + " as resolved.");
                    } else {
                        req.getSession().setAttribute("flash_error", "❌ Update failed. Please try again.");
                    }

                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                    break;
                }

                case "/receptionist/requests/delete": {
                    int id = parseInt(req.getParameter("id"), 0);

                    if (id <= 0) {
                        req.getSession().setAttribute("flash_error", "Invalid Request ID.");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    boolean ok = dao.delete(id);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "✅ Deleted request #" + id + " successfully!");
                    } else {
                        req.getSession().setAttribute("flash_error", "❌ Could not delete request #" + id);
                    }

                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                    break;
                }

                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error occurred: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
        }
    }
}