package Controller.General;

import Models.Room;
import Services.RoomService; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RoomDetailsController", urlPatterns = {"/room-details"})
public class RoomDetailsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RoomDetailsController.class.getName());
    private RoomService roomService; 
    @Override
    public void init() throws ServletException {
        super.init();
       
        this.roomService = new RoomService(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "/pages/general/room-details.jsp";
        
        try {
            String roomIdParam = request.getParameter("roomId");
            int roomId = 0;
            if (roomIdParam != null && !roomIdParam.isEmpty()) {
                roomId = Integer.parseInt(roomIdParam);
            }

            Room room = roomService.getRoomById(roomId); 

            if (room != null) {
                request.setAttribute("room", room);
            } else {
                request.setAttribute("errorMessage", "Room with ID " + roomId + " not found.");
                LOGGER.log(Level.WARNING, "Attempted to access non-existent room with ID: {0}", roomId);
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid roomId parameter: {0}", request.getParameter("roomId"));
            request.setAttribute("errorMessage", "Invalid room ID format.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDetailsController", e);
            request.setAttribute("errorMessage", "An error occurred while retrieving room details.");
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
}