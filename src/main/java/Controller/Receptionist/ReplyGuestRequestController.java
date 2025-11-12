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
        "/receptionist/requests",            // list + filter theo status
        "/receptionist/requests/detail",     // xem chi tiết -> markSeen
        "/receptionist/requests/send-reply", // POST trả lời
        "/receptionist/requests/resolve",    // POST đánh dấu đã xử lý
        "/receptionist/requests/delete"      // POST xóa request
})
public class ReplyGuestRequestController extends HttpServlet {

    private GuestRequestDao dao;

    @Override
    public void init() {
        dao = new GuestRequestDao();
    }

    /**
     * Lấy userId từ session (dựa theo UserRequestController)
     */
    private Integer currentUserId(HttpServletRequest req) {
        Object userObj = req.getSession().getAttribute("user");
        if (userObj != null && userObj instanceof Users) {
            return ((Users) userObj).getUserId();
        }
        return null;
    }

    /**
     * Kiểm tra role có phải receptionist không
     */
    private boolean isReceptionist(HttpServletRequest req) {
        Object userObj = req.getSession().getAttribute("user");
        if (userObj instanceof Users) {
            String role = ((Users) userObj).getRole();
            return "receptionist".equalsIgnoreCase(role);
        }
        return false;
    }

    /**
     * Kiểm tra role và chuyển hướng phù hợp
     */
    private boolean checkRoleAndRedirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Object userObj = req.getSession().getAttribute("user");

        if (userObj instanceof Users) {
            String role = ((Users) userObj).getRole();

            // Nếu là customer -> chuyển sang UserRequestController
            if ("customer".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/user/requests");
                return false;
            }

            // Nếu là admin -> chuyển về trang admin
            if ("admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/viewuser");
                return false;
            }

            // Nếu là receptionist -> cho phép truy cập
            if ("receptionist".equalsIgnoreCase(role)) {
                return true;
            }

            // Role không xác định
            req.getSession().setAttribute("flash_error", "Bạn không có quyền truy cập chức năng này");
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

        // Kiểm tra đăng nhập
        if (userId == null) {
            HttpSession session = req.getSession();
            String queryString = req.getQueryString();
            String fullUrl = req.getRequestURI() + (queryString != null ? "?" + queryString : "");
            session.setAttribute("redirectUrl", fullUrl);
            session.setAttribute("loginMessage", "Vui lòng đăng nhập để sử dụng chức năng này");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Kiểm tra role và chuyển hướng nếu cần
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        String path = req.getServletPath();
        try {
            switch (path) {
                case "/receptionist/requests": {
                    String status = req.getParameter("status"); // all/pending/replied/resolved/cancelled
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
                        req.getSession().setAttribute("flash_error", "Request ID không hợp lệ");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    GuestRequest item = dao.findById(id);
                    if (item == null) {
                        req.getSession().setAttribute("flash_error", "Không tìm thấy request #" + id);
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    // Đánh dấu đã xem
                    try {
                        dao.markSeen(id, userId);
                    } catch (Exception e) {
                        // Ignore nếu column chưa có
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

        // Kiểm tra đăng nhập
        if (userId == null) {
            resp.sendError(401, "Bạn cần đăng nhập để sử dụng chức năng này");
            return;
        }

        // Kiểm tra role và chuyển hướng nếu cần
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
                        req.getSession().setAttribute("flash_error", "Request ID không hợp lệ");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    if (replyText == null || replyText.trim().isEmpty()) {
                        req.getSession().setAttribute("flash_error", "Vui lòng nhập nội dung phản hồi");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                        return;
                    }

                    boolean ok = dao.reply(id, replyText.trim(), userId);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "✅ Đã trả lời yêu cầu #" + id + " thành công!");
                    } else {
                        req.getSession().setAttribute("flash_error", "❌ Trả lời thất bại. Vui lòng thử lại.");
                    }

                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                    break;
                }

                case "/receptionist/requests/resolve": {
                    int id = parseInt(req.getParameter("id"), 0);

                    if (id <= 0) {
                        req.getSession().setAttribute("flash_error", "Request ID không hợp lệ");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    boolean ok = dao.resolve(id, userId);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "✅ Đã đánh dấu hoàn tất yêu cầu #" + id);
                    } else {
                        req.getSession().setAttribute("flash_error", "❌ Cập nhật thất bại. Vui lòng thử lại.");
                    }

                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                    break;
                }

                case "/receptionist/requests/delete": {
                    int id = parseInt(req.getParameter("id"), 0);

                    if (id <= 0) {
                        req.getSession().setAttribute("flash_error", "Request ID không hợp lệ");
                        resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                        return;
                    }

                    boolean ok = dao.delete(id);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "✅ Đã xóa yêu cầu #" + id + " thành công!");
                    } else {
                        req.getSession().setAttribute("flash_error", "❌ Không thể xóa yêu cầu #" + id);
                    }

                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                    break;
                }

                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
        }
    }
}