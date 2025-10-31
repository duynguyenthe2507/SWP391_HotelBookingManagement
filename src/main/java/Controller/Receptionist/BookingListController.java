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
import java.util.List;
import java.util.Map;

@WebServlet("/receptionist/booking-list")
public class BookingListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");

        // Kiểm tra quyền truy cập
        if (loggedInUser == null  || !"receptionist".equals(loggedInUser.getRole()) ) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        BookingDao bookingDao = new BookingDao();

        // Lấy tham số filter, search, pagination (nếu có)
        String statusFilter = request.getParameter("status");
        String checkInFilter = request.getParameter("checkInDate"); // Định dạng YYYY-MM-DD
        String searchKeyword = request.getParameter("search");
        int page = 1;
        int size = 10; // Số booking mỗi trang
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) { page = 1; }

        // Lấy dữ liệu từ DAO
        List<Map<String, Object>> bookings = bookingDao.findBookings(statusFilter, checkInFilter, searchKeyword, page, size);
        int totalItems = bookingDao.countBookings(statusFilter, checkInFilter, searchKeyword);
        int totalPages = (int) Math.ceil((double) totalItems / size);

        // Đặt thuộc tính cho JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("checkInFilter", checkInFilter);
        request.setAttribute("searchKeyword", searchKeyword);

        request.getRequestDispatcher("/pages/receptionist/booking-list.jsp").forward(request, response);
    }
}