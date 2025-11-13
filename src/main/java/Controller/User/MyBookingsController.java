package Controller.User;

import Models.Users;
import Services.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.time.format.DateTimeFormatter; 


@WebServlet(name = "MyBookingsController", urlPatterns = {"/my-bookings"})
public class MyBookingsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MyBookingsController.class.getName());
    private BookingService bookingService;
    
    private static final DateTimeFormatter JSP_DATE_FORMATTER = DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy");
    
    private static final int BOOKINGS_PER_PAGE = 5;

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = null;

        if (session != null) {
            user = (Users) session.getAttribute("user");
        }

        if (user == null) {
            LOGGER.log(Level.WARNING, "User not logged in, redirecting to login.");
            if (session == null) {
                session = request.getSession();
            }
            session.setAttribute("redirectUrl", request.getContextPath() + "/my-bookings");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            
            String keyword = request.getParameter("search"); 
            String status = request.getParameter("status");  
            int pageNumber = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    pageNumber = Integer.parseInt(pageParam);
                    if (pageNumber < 1) pageNumber = 1;
                } catch (NumberFormatException e) {
                    pageNumber = 1;
                }
            }
            int totalBookings = bookingService.countDetailedBookingsByUserId(user.getUserId(), keyword, status);
            int totalPages = (int) Math.ceil((double) totalBookings / BOOKINGS_PER_PAGE);
            if (totalPages == 0) totalPages = 1;
            if (pageNumber > totalPages) pageNumber = totalPages;
            List<Map<String, Object>> bookingList = bookingService.getDetailedBookingsByUserId(user.getUserId(), keyword, status, pageNumber, BOOKINGS_PER_PAGE);
            
            request.setAttribute("bookingList", bookingList);
            request.setAttribute("myDateFormatter", JSP_DATE_FORMATTER);
            
            request.setAttribute("currentPage", pageNumber);
            request.setAttribute("totalPages", totalPages);
            
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("statusFilter", status);
            
            LOGGER.log(Level.INFO, "Found {0} total bookings for user {1} (filter: {2}, {3}). Displaying page {4} of {5}.", 
                       new Object[]{totalBookings, user.getUserId(), keyword, status, pageNumber, totalPages});
            
            request.getRequestDispatcher("/pages/user/my-bookings.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching user bookings", e);
            request.setAttribute("errorMessage", "Could not retrieve your bookings: " + e.getMessage());
            request.getRequestDispatcher("/pages/user/my-bookings.jsp").forward(request, response);
        }
    }
}