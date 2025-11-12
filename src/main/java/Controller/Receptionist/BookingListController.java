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

        HttpSession session = request.getSession(false);

        // CRITICAL FIX: Check both "loggedInUser" AND "user"
        Users loggedInUser = null;
        if (session != null) {
            loggedInUser = (Users) session.getAttribute("loggedInUser");

            if (loggedInUser == null) {
                loggedInUser = (Users) session.getAttribute("user");
                LOGGER.log(Level.INFO, "loggedInUser was null, using 'user' attribute instead");
            }
        }

        LOGGER.log(Level.INFO, "Session exists: {0}, User found: {1}",
                new Object[]{session != null, loggedInUser != null});

        if (loggedInUser != null) {
            LOGGER.log(Level.INFO, "User details - ID: {0}, Role: {1}, Name: {2}",
                    new Object[]{loggedInUser.getUserId(), loggedInUser.getRole(), loggedInUser.getFirstName()});
        }

        // FIX: Case-insensitive role check
        if (loggedInUser == null ||
                (loggedInUser.getRole() == null ||
                        !loggedInUser.getRole().trim().equalsIgnoreCase("receptionist"))) {

            LOGGER.log(Level.WARNING, "Access denied - User is null or not receptionist. Role: {0}",
                    loggedInUser != null ? loggedInUser.getRole() : "NULL");

            if (session == null) {
                session = request.getSession();
            }
            session.setAttribute("redirectUrl", request.getContextPath() + "/receptionist/booking-list");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LOGGER.log(Level.INFO, "User authorized: {0}", loggedInUser.getFirstName());

        BookingDao bookingDao = null;

        try {
            bookingDao = new BookingDao();
            LOGGER.log(Level.INFO, "BookingDao initialized successfully");

            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String checkInFilter = request.getParameter("checkInDate");
            String searchKeyword = request.getParameter("search");

            int page = 1;
            int size = 10; // Changed to 10 for better initial view

            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid page parameter, defaulting to 1");
                page = 1;
            }

            LOGGER.log(Level.INFO, "Query parameters - Status: {0}, CheckIn: {1}, Search: {2}, Page: {3}",
                    new Object[]{statusFilter, checkInFilter, searchKeyword, page});

            // Fetch bookings with error handling
            List<Map<String, Object>> bookings = null;
            int totalItems = 0;

            try {
                LOGGER.log(Level.INFO, "Calling bookingDao.findBookings...");
                bookings = bookingDao.findBookings(statusFilter, checkInFilter, searchKeyword, page, size);
                LOGGER.log(Level.INFO, "findBookings returned {0} results", bookings != null ? bookings.size() : "NULL");

                LOGGER.log(Level.INFO, "Calling bookingDao.countBookings...");
                totalItems = bookingDao.countBookings(statusFilter, checkInFilter, searchKeyword);
                LOGGER.log(Level.INFO, "countBookings returned {0}", totalItems);

            } catch (Exception daoEx) {
                LOGGER.log(Level.SEVERE, "DAO operation failed!", daoEx);
                daoEx.printStackTrace();
                bookings = new ArrayList<>();
                totalItems = 0;
            }

            int totalPages = (totalItems > 0) ? (int) Math.ceil((double) totalItems / size) : 1;

            LOGGER.log(Level.INFO, "Final stats - Bookings: {0}, Total: {1}, Pages: {2}",
                    new Object[]{bookings != null ? bookings.size() : 0, totalItems, totalPages});

            // Set attributes for JSP
            request.setAttribute("bookings", bookings != null ? bookings : new ArrayList<>());
            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("checkInFilter", checkInFilter);
            request.setAttribute("searchKeyword", searchKeyword);

            LOGGER.log(Level.INFO, "Forwarding to JSP...");
            request.getRequestDispatcher("/pages/receptionist/booking-list.jsp").forward(request, response);
            LOGGER.log(Level.INFO, "=== BookingListController.doGet COMPLETED SUCCESSFULLY ===");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "CRITICAL ERROR in BookingListController", e);
            e.printStackTrace();

            if (session == null) {
                session = request.getSession();
            }
            session.setAttribute("bookingMessage", "Error loading bookings: " + e.getMessage());

            // Still forward to show the page with error message
            request.setAttribute("bookings", new ArrayList<>());
            request.setAttribute("page", 1);
            request.setAttribute("size", 10);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalItems", 0);

            try {
                request.getRequestDispatcher("/pages/receptionist/booking-list.jsp").forward(request, response);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Failed to forward to JSP", ex);
                response.sendRedirect(request.getContextPath() + "/");
            }
        } finally {
            if (bookingDao != null) {
                try {
                    bookingDao.closeConnection();
                    LOGGER.log(Level.INFO, "BookingDao connection closed");
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error closing BookingDao connection", e);
                }
            }
        }
    }
}