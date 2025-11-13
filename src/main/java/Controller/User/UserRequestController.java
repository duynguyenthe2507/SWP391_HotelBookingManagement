package Controller.User;

import Dao.GuestRequestDao;
import Dao.BookingDao;
import Models.GuestRequest;
import Models.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import Models.Users;

@WebServlet(name = "UserRequestController", urlPatterns = {
        "/user/requests",
        "/user/requests/create",
        "/user/requests/cancel"
})
public class UserRequestController extends HttpServlet {

    private GuestRequestDao dao;
    private BookingDao bookingDao;

    @Override
    public void init() {
        dao = new GuestRequestDao();
        bookingDao = new BookingDao(); // Khởi tạo DAO
    }

    private Integer currentUserId(HttpServletRequest req) {
        Object userObj = req.getSession().getAttribute("user");
        if (userObj != null && userObj instanceof Users) {
            return ((Users) userObj).getUserId();
        }
        return null;
    }

    private int parseIntSafe(String s, int defaultValue) {
        if (s == null || s.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    // Kiểm tra quyền & Redirect
    private boolean checkRoleAndRedirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Object userObj = req.getSession().getAttribute("user");

        if (userObj instanceof Users) {
            String role = ((Users) userObj).getRole();

            // Nếu là Receptionist -> Chuyển trang quản lý
            if ("receptionist".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                return false;
            }

            // Nếu là Admin -> Chuyển trang Admin
            if ("admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/viewuser");
                return false;
            }

            // Nếu là Customer -> OK
            if ("customer".equalsIgnoreCase(role)) {
                return true;
            }

            // Role không hợp lệ
            req.getSession().setAttribute("error", "You do not have permission to access this feature.");
            resp.sendRedirect(req.getContextPath() + "/");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Integer userId = currentUserId(req);

        // Kiểm tra đăng nhập
        if (userId == null) {
            HttpSession session = req.getSession();
            String queryString = req.getQueryString();
            String fullUrl = req.getRequestURI() + (queryString != null ? "?" + queryString : "");
            session.setAttribute("redirectUrl", fullUrl);
            session.setAttribute("loginMessage", "Please login to use this feature.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Kiểm tra quyền
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        try {
            switch (path) {
                case "/user/requests":
                    // Lấy danh sách request của user
                    List<GuestRequest> items = dao.findByUser(userId);
                    req.setAttribute("items", items);
                    req.getRequestDispatcher("/pages/user/my-requests.jsp").forward(req, resp);
                    break;

                case "/user/requests/create":
                    // Form tạo mới
                    String bookingIdParam = req.getParameter("bookingId");

                    if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
                        try {
                            int bookingId = Integer.parseInt(bookingIdParam);

                            // Check booking tồn tại
                            Booking booking = bookingDao.getBookingById(bookingId);

                            if (booking == null) {
                                req.getSession().setAttribute("flash_error", "Booking not found #" + bookingId);
                                resp.sendRedirect(req.getContextPath() + "/user/requests");
                                return;
                            }
                            // Check booking chính chủ
                            if (booking.getUserId() == null || booking.getUserId() != userId) {
                                req.getSession().setAttribute("flash_error",
                                        "You are not authorized to create a request for Booking #" + bookingId +
                                                ". This booking does not belong to you.");
                                resp.sendRedirect(req.getContextPath() + "/user/requests");
                                return;
                            }

                            req.setAttribute("booking", booking);
                            req.setAttribute("bookingId", bookingId);

                        } catch (NumberFormatException e) {
                            req.setAttribute("error", "Invalid Booking ID.");
                        }
                    }

                    req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                    break;

                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        Integer userId = currentUserId(req);

        // Kiểm tra quyền
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        try {
            switch (path) {
                case "/user/requests/create": {
                    // Parse dữ liệu
                    String bookingIdStr = req.getParameter("bookingId");
                    int bookingId = parseIntSafe(bookingIdStr, 0);

                    String requestType = req.getParameter("requestType");
                    String content = req.getParameter("content");

                    // Validate Booking ID
                    if (bookingId <= 0) {
                        req.setAttribute("error", "Invalid Booking ID.");
                        req.setAttribute("bookingId", bookingIdStr);
                        req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                        return;
                    }

                    // Check booking tồn tại & chính chủ
                    Booking booking = bookingDao.getBookingById(bookingId);

                    if (booking == null) {
                        req.getSession().setAttribute("flash_error", "Booking not found #" + bookingId);
                        resp.sendRedirect(req.getContextPath() + "/user/requests");
                        return;
                    }

                    if (booking.getUserId() == null || !booking.getUserId().equals(userId)) {
                        req.getSession().setAttribute("flash_error",
                                "⛔ PERMISSION DENIED for Booking #" + bookingId +
                                        "! This booking belongs to user #" + booking.getUserId() +
                                        ", not user #" + userId);
                        resp.sendRedirect(req.getContextPath() + "/user/requests");
                        return;
                    }

                    // Validate Request Type
                    if (requestType == null || requestType.trim().isEmpty()) {
                        req.setAttribute("error", "Please select a request type.");
                        req.setAttribute("bookingId", bookingId);
                        req.setAttribute("booking", booking);
                        req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                        return;
                    }

                    // Validate Content
                    if (content == null || content.trim().isEmpty()) {
                        req.setAttribute("error", "Please enter request content.");
                        req.setAttribute("bookingId", bookingId);
                        req.setAttribute("requestType", requestType);
                        req.setAttribute("booking", booking);
                        req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                        return;
                    }

                    // Tạo request mới
                    GuestRequest gr = new GuestRequest();
                    gr.setBookingId(bookingId);
                    gr.setUserId(userId);
                    gr.setRequestType(requestType.trim());
                    gr.setContent(content.trim());

                    Integer newId = dao.create(gr);

                    if (newId != null) {
                        req.getSession().setAttribute("flash_success",
                                "✅ Request #" + newId + " sent successfully for Booking #" + bookingId + "!");
                    } else {
                        req.getSession().setAttribute("flash_success",
                                "✅ Request sent successfully!");
                    }

                    resp.sendRedirect(req.getContextPath() + "/user/requests");
                    break;
                }

                case "/user/requests/cancel": {
                    String requestIdStr = req.getParameter("id");
                    int requestId = parseIntSafe(requestIdStr, 0);

                    if (requestId <= 0) {
                        req.getSession().setAttribute("flash_error", "Invalid Request ID.");
                        resp.sendRedirect(req.getContextPath() + "/user/requests");
                        return;
                    }

                    boolean ok = dao.cancel(requestId, userId);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "Request #" + requestId + " cancelled.");
                    } else {
                        req.getSession().setAttribute("flash_error",
                                "Cannot cancel (Not yours or not pending).");
                    }

                    resp.sendRedirect(req.getContextPath() + "/user/requests");
                    break;
                }

                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Error occurred: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user/requests");
        }
    }
}