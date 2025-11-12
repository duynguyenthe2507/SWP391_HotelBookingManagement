package Controller.General;

// === IMPORT CÁC DAO ===
import Dao.RoomDao;
import Dao.ServicesDao;
import Dao.FeedbackDao; 

// === IMPORT CÁC MODEL ===
import Models.Room;
import Models.Services;
import Models.Feedback;
import Models.Users;

// === IMPORT SERVICE ===
import Services.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.time.format.DateTimeFormatter; 

@WebServlet(name = "RoomDetailsController", urlPatterns = {"/room-details"})
public class RoomDetailsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RoomDetailsController.class.getName());
    
    // Khai báo các DAO và Service
    private RoomDao roomDao;
    private ServicesDao servicesDao;
    private FeedbackDao feedbackDao;
    private BookingService bookingService;
    
    private static final DateTimeFormatter JSP_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd MMM, yyyy");

    @Override
    public void init() throws ServletException {
        this.roomDao = new RoomDao();
        this.servicesDao = new ServicesDao();
        this.feedbackDao = new FeedbackDao();
        this.bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdStr = request.getParameter("roomId");
        int roomId;

        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid roomId parameter: " + roomIdStr);
            request.setAttribute("errorMessage", "Invalid room ID provided.");
            request.getRequestDispatcher("/pages/general/room-details.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession(false);
        Users user = null;
        if (session != null) {
            user = (Users) session.getAttribute("user");
        }

        try {
            Room room = roomDao.getById(roomId);

            if (room == null) {
                LOGGER.log(Level.WARNING, "Room not found with ID: " + roomId);
                request.setAttribute("errorMessage", "The room you are looking for could not be found.");
            } else {
                 request.setAttribute("room", room);
            }
            List<Services> servicesList = servicesDao.getAll();
            request.setAttribute("servicesList", servicesList);
            List<Feedback> feedbackList = feedbackDao.getReviewsByRoomId(roomId, 5);
            request.setAttribute("feedbackList", feedbackList); 
            int canReviewBookingId = 0;
            if (user != null && room != null) {
                canReviewBookingId = bookingService.findCompletedBookingId(user.getUserId(), room.getRoomId());
            }
            request.setAttribute("canReviewBookingId", canReviewBookingId);
            
            request.setAttribute("myDateFormatter", JSP_DATE_FORMATTER);

            request.getRequestDispatcher("/pages/general/room-details.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching room details/services/feedback", e);
            request.setAttribute("errorMessage", "An error occurred while loading room details: " + e.getMessage());
            request.getRequestDispatcher("/pages/general/room-details.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}