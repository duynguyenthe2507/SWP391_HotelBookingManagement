package Controller.Receptionist;

import Dao.BookingDao;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/receptionist/booking-list")
public class BookingListController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookingListController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.log(Level.INFO, "=== BookingListController.doGet STARTED ===");

        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");

        // Kiểm tra quyền truy cập
        if (loggedInUser == null || !"receptionist".equalsIgnoreCase(loggedInUser.getRole())) {
            LOGGER.log(Level.WARNING, "Access denied - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LOGGER.log(Level.INFO, "User authorized: {0}", loggedInUser.getFirstName());

        BookingDao bookingDao = null;

        try {
            bookingDao = new BookingDao();

            // Lấy tham số filter, search, pagination
            String statusFilter = request.getParameter("status");
            String checkInFilter = request.getParameter("checkInDate");
            String searchKeyword = request.getParameter("search");

            int page = 1;
            int size = 5;

            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid page parameter, defaulting to 1");
                page = 1;
            }

            LOGGER.log(Level.INFO, "Fetching bookings - Status: {0}, CheckIn: {1}, Search: {2}, Page: {3}",
                    new Object[]{statusFilter, checkInFilter, searchKeyword, page});

            // Lấy dữ liệu từ DAO
            List<Map<String, Object>> bookings = bookingDao.findBookings(
                    statusFilter, checkInFilter, searchKeyword, page, size
            );

            int totalItems = bookingDao.countBookings(statusFilter, checkInFilter, searchKeyword);
            int totalPages = (int) Math.ceil((double) totalItems / size);

            LOGGER.log(Level.INFO, "Retrieved {0} bookings, total: {1}",
                    new Object[]{bookings != null ? bookings.size() : 0, totalItems});

            // Đặt thuộc tính cho JSP
            request.setAttribute("bookings", bookings != null ? bookings : new ArrayList<>());
            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("checkInFilter", checkInFilter);
            request.setAttribute("searchKeyword", searchKeyword);

            request.getRequestDispatcher("/pages/receptionist/booking-list.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading booking list", e);
            session.setAttribute("bookingMessage", "Error loading bookings: " + e.getMessage());

            // Vẫn forward để hiển thị trang với thông báo lỗi
            request.setAttribute("bookings", new ArrayList<>());
            request.setAttribute("page", 1);
            request.setAttribute("size", 10);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalItems", 0);

            request.getRequestDispatcher("/pages/receptionist/booking-list.jsp").forward(request, response);
        } finally {
            // Đóng connection
            if (bookingDao != null) {
                try {
                    bookingDao.closeConnection();
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error closing BookingDao connection", e);
                }
            }
        }
    }
}