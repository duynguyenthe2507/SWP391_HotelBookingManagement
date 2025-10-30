package Controller.Receptionist;


import Models.BookingDetailsViewModel;
import Services.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/receptionist/booking-details")
public class BookingDetailsController extends HttpServlet {
    private BookingService bookingService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        HttpSession session = request.getSession();

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            session.setAttribute("bookingMessage", "Invalid Booking ID");
            response.sendRedirect(request.getContextPath() + "/receptionist/booking-list");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDetailsViewModel details = bookingService.getBookingDetails(bookingId);
            if (details == null) {
                session.setAttribute("bookingMessage", "Booking not found");
                response.sendRedirect(request.getContextPath() + "/receptionist/booking-list");
            } else {
                request.setAttribute("details", details);
                request.setAttribute("pageTitle", "Booking Details");
                request.setAttribute("currentPage", "Details");
                request.getRequestDispatcher("/pages/receptionist/bookingDetails.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("bookingMessage", "Invalid Booking ID format.");
            response.sendRedirect(request.getContextPath() + "/receptionist/booking-list");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        String roomIdStr = request.getParameter("roomId");
        HttpSession session = request.getSession();

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            session.setAttribute("bookingMessage", "Missing required parameters");
            response.sendRedirect(request.getContextPath() + "/receptionist/booking-list");
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            int roomId = Integer.parseInt(roomIdStr);
            boolean success = false;
            String message = "";

            if("checkin".equals(action)) {
                success = bookingService.checkInBooking(bookingId, roomId);
                message = success ? "Booking checkin successful" : "Booking checkin failed";
            } else if ("checkout".equals(action)) {
                success = bookingService.checkOutBooking(bookingId, roomId);
                message = success ? "Booking checkout successful" : "Booking checkout failed";
                if (success) {
                    session.setAttribute("bookingMessage", message + "Redirecting to create bill...");
                    response.sendRedirect(request.getContextPath() + "/receptionist/create-bill?bookingId=" + bookingId);
                    return;
                }
            } else if ("createBill".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/receptionist/create-bill?bookingId=" + bookingId);
                return;
            } else {
                message = "Invalid action";
            }

            session.setAttribute("bookingMessage", message);
            response.sendRedirect(request.getContextPath() + "/receptionist/booking-details?bookingId=" + bookingId);
        } catch (NumberFormatException e) {
            session.setAttribute("bookingMessage", "Invalid ID format");
            response.sendRedirect(request.getContextPath() + "/receptionist/booking-list");
        }
    }
}
