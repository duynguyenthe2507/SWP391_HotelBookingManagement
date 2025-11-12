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
    private BookingDao bookingDao;  // Thêm BookingDao để kiểm tra

    @Override
    public void init() {
        dao = new GuestRequestDao();
        bookingDao = new BookingDao();  // Khởi tạo BookingDao
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

    /**
     * Kiểm tra role và chuyển hướng phù hợp
     * @return true nếu user có quyền truy cập (là customer), false nếu cần chuyển hướng
     */
    private boolean checkRoleAndRedirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Object userObj = req.getSession().getAttribute("user");

        if (userObj instanceof Users) {
            String role = ((Users) userObj).getRole();

            // Nếu là receptionist -> chuyển sang ReplyGuestRequestController
            if ("receptionist".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/receptionist/requests");
                return false;
            }

            // Nếu là admin -> chuyển về trang admin
            if ("admin".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/viewuser");
                return false;
            }

            // Nếu là customer -> cho phép truy cập
            if ("customer".equalsIgnoreCase(role)) {
                return true;
            }

            // Role không xác định
            req.getSession().setAttribute("error", "Bạn không có quyền truy cập chức năng này");
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
            session.setAttribute("loginMessage", "Vui lòng đăng nhập để sử dụng chức năng này");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Kiểm tra role và chuyển hướng nếu cần
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        try {
            switch (path) {
                case "/user/requests":
                    // Danh sách yêu cầu của chính user
                    List<GuestRequest> items = dao.findByUser(userId);
                    req.setAttribute("items", items);
                    req.getRequestDispatcher("/pages/user/my-requests.jsp").forward(req, resp);
                    break;

                case "/user/requests/create":
                    // Mở form tạo yêu cầu mới
                    String bookingIdParam = req.getParameter("bookingId");

                    if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
                        try {
                            int bookingId = Integer.parseInt(bookingIdParam);

                            // KIỂM TRA QUAN TRỌNG: Booking có thuộc về user này không? =====
                            Booking booking = bookingDao.getBookingById(bookingId);

                            if (booking == null) {
                                req.getSession().setAttribute("flash_error",
                                        "Không tìm thấy booking #" + bookingId);
                                resp.sendRedirect(req.getContextPath() + "/user/requests");
                                return;
                            }
                            // Kiểm tra booking có thuộc về user hiện tại không
                            if (booking.getUserId() == null || booking.getUserId() != userId) {
                                req.getSession().setAttribute("flash_error",
                                        "Bạn không có quyền tạo yêu cầu cho booking #" + bookingId +
                                                ". Booking này không thuộc về bạn.");
                                resp.sendRedirect(req.getContextPath() + "/user/requests");
                                return;
                            }
                            // Nếu hợp lệ, set thông tin booking để hiển thị
                            req.setAttribute("booking", booking);
                            req.setAttribute("bookingId", bookingId);

                        } catch (NumberFormatException e) {
                            req.setAttribute("error", "Booking ID không hợp lệ");
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
        // Kiểm tra role và chuyển hướng nếu cần
        if (!checkRoleAndRedirect(req, resp)) {
            return;
        }

        try {
            switch (path) {
                case "/user/requests/create": {
                    // Parse bookingId an toàn
                    String bookingIdStr = req.getParameter("bookingId");
                    int bookingId = parseIntSafe(bookingIdStr, 0);

                    String requestType = req.getParameter("requestType");
                    String content = req.getParameter("content");

                    // Validation 1: Booking ID phải hợp lệ
                    if (bookingId <= 0) {
                        req.setAttribute("error", "Booking ID không hợp lệ");
                        req.setAttribute("bookingId", bookingIdStr);
                        req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                        return;
                    }

                    // KIỂM TRA QUAN TRỌNG NHẤT: Booking có thuộc về user này không?
                    Booking booking = bookingDao.getBookingById(bookingId);

                    if (booking == null) {
                        req.getSession().setAttribute("flash_error",
                                "Không tìm thấy booking #" + bookingId);
                        resp.sendRedirect(req.getContextPath() + "/user/requests");
                        return;
                    }

                    // Kiểm tra userId của booking có khớp với userId đang đăng nhập không
                    if (booking.getUserId() == null || !booking.getUserId().equals(userId)) {
                        req.getSession().setAttribute("flash_error",
                                "⛔ BẠN KHÔNG CÓ QUYỀN tạo yêu cầu cho Booking #" + bookingId +
                                        "! Booking này thuộc về user #" + booking.getUserId() +
                                        ", không phải user #" + userId);
                        resp.sendRedirect(req.getContextPath() + "/user/requests");
                        return;
                    }

                    // Validation 2: Request Type
                    if (requestType == null || requestType.trim().isEmpty()) {
                        req.setAttribute("error", "Vui lòng chọn loại yêu cầu");
                        req.setAttribute("bookingId", bookingId);
                        req.setAttribute("booking", booking);
                        req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                        return;
                    }

                    // Validation 3: Content
                    if (content == null || content.trim().isEmpty()) {
                        req.setAttribute("error", "Vui lòng nhập nội dung yêu cầu");
                        req.setAttribute("bookingId", bookingId);
                        req.setAttribute("requestType", requestType);
                        req.setAttribute("booking", booking);
                        req.getRequestDispatcher("/pages/user/request-create.jsp").forward(req, resp);
                        return;
                    }

                    // Tạo request mới (ĐÃ ĐƯỢC VALIDATE)
                    GuestRequest gr = new GuestRequest();
                    gr.setBookingId(bookingId);
                    gr.setUserId(userId);
                    gr.setRequestType(requestType.trim());
                    gr.setContent(content.trim());

                    Integer newId = dao.create(gr);

                    if (newId != null) {
                        req.getSession().setAttribute("flash_success",
                                "✅ Đã gửi yêu cầu #" + newId + " thành công cho Booking #" + bookingId + "!");
                    } else {
                        req.getSession().setAttribute("flash_success",
                                "✅ Đã gửi yêu cầu thành công!");
                    }

                    resp.sendRedirect(req.getContextPath() + "/user/requests");
                    break;
                }

                case "/user/requests/cancel": {
                    String requestIdStr = req.getParameter("id");
                    int requestId = parseIntSafe(requestIdStr, 0);

                    if (requestId <= 0) {
                        req.getSession().setAttribute("flash_error", "Request ID không hợp lệ");
                        resp.sendRedirect(req.getContextPath() + "/user/requests");
                        return;
                    }

                    boolean ok = dao.cancel(requestId, userId);

                    if (ok) {
                        req.getSession().setAttribute("flash_success", "Đã hủy yêu cầu #" + requestId);
                    } else {
                        req.getSession().setAttribute("flash_error",
                                "Không thể hủy (không thuộc bạn hoặc không còn ở trạng thái pending)");
                    }

                    resp.sendRedirect(req.getContextPath() + "/user/requests");
                    break;
                }

                default:
                    resp.sendError(404);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user/requests");
        }
    }
}