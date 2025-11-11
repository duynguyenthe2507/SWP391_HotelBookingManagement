package Controller.Receptionist;


import Dao.GuestRequestDao;
import Models.GuestRequest;
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
        "/receptionist/requests/resolve"     // POST đánh dấu đã xử lý
})
public class ReplyGuestRequestController extends HttpServlet {

    private GuestRequestDao dao;

    @Override
    public void init() {
        dao = new GuestRequestDao();
    }

    private Integer staffId(HttpServletRequest req) {
        // Lấy id lễ tân từ session (tuỳ hệ thống)
        Object uid = req.getSession().getAttribute("userId");
        return (uid instanceof Integer) ? (Integer) uid : null;
    }

    private boolean isReceptionist(HttpServletRequest req) {
        // Tuỳ hệ thống phân quyền; ví dụ session attribute "role"
        Object role = req.getSession().getAttribute("role");
        return role != null && "receptionist".equalsIgnoreCase(role.toString());
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isReceptionist(req)) { resp.sendError(403); return; }

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
                    GuestRequest item = dao.findById(id);
                    if (item == null) { resp.sendError(404); return; }

                    // Đánh dấu đã xem (nếu DB có cột isSeen/seenAt)
                    try { dao.markSeen(id, staffId(req)); } catch (Exception ignore) {}

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
        if (!isReceptionist(req)) { resp.sendError(403); return; }

        String path = req.getServletPath();
        Integer sid = staffId(req);
        if (sid == null) { resp.sendError(401); return; }

        try {
            switch (path) {
                case "/receptionist/requests/send-reply": {
                    int id = parseInt(req.getParameter("id"), 0);
                    String replyText = req.getParameter("replyText");
                    boolean ok = dao.reply(id, replyText, sid);
                    req.getSession().setAttribute(ok ? "flash_success" : "flash_error",
                            ok ? "Đã trả lời yêu cầu #" + id : "Trả lời thất bại.");
                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                    break;
                }
                case "/receptionist/requests/resolve": {
                    int id = parseInt(req.getParameter("id"), 0);
                    boolean ok = dao.resolve(id, sid);
                    req.getSession().setAttribute(ok ? "flash_success" : "flash_error",
                            ok ? "Đã đánh dấu hoàn tất yêu cầu #" + id : "Cập nhật thất bại.");
                    resp.sendRedirect(req.getContextPath() + "/receptionist/requests/detail?id=" + id);
                    break;
                }
                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
