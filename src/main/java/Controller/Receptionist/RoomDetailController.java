package Controller.Receptionist;

import Dao.RoomDao;
import Dao.BookingDao;
import Models.Room;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/receptionist/room-detail")
public class RoomDetailController extends HttpServlet {
    
    private RoomDao roomDao;
    private BookingDao bookingDao;
    
    @Override
    public void init() {
        roomDao = new RoomDao();
        bookingDao = new BookingDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a receptionist
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null || !loggedInUser.getRole().equals("receptionist")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String roomIdParam = request.getParameter("id");
            if (roomIdParam == null || roomIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/receptionist/rooms");
                return;
            }
            
            int roomId = Integer.parseInt(roomIdParam);
            
            // Get room details
            Room room = roomDao.getById(roomId);
            if (room == null) {
                request.setAttribute("error", "Room not found");
                response.sendRedirect(request.getContextPath() + "/receptionist/rooms");
                return;
            }
            
            // Get booking history for this room
            List<Map<String, Object>> bookingHistory = bookingDao.getBookingHistoryByRoom(roomId);
            
            // Get current booking if room is booked
            Map<String, Object> currentBooking = null;
            if ("booked".equalsIgnoreCase(room.getStatus())) {
                currentBooking = bookingDao.getCurrentBookingByRoom(roomId);
            }
            
            // Set attributes
            request.setAttribute("room", room);
            request.setAttribute("bookingHistory", bookingHistory);
            request.setAttribute("currentBooking", currentBooking);
            
            // Forward to JSP
            request.getRequestDispatcher("/pages/receptionist/room-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receptionist/rooms");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/receptionist/room-detail.jsp").forward(request, response);
        }
    }
}

