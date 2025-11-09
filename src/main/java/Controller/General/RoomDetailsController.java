package Controller.General;

import Dao.RoomDao;
import Models.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RoomDetailsServlet", urlPatterns = {"/room-details"})
public class RoomDetailsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RoomDetailsController.class.getName());
    private RoomDao roomDao;

    @Override
    public void init() throws ServletException {
        this.roomDao = new RoomDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String roomIdStr = request.getParameter("roomId");
        int roomId = 0;

        try {
            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                throw new NumberFormatException("Room ID is missing from URL parameter.");
            }
            roomId = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid or missing Room ID parameter.", e);
            request.setAttribute("errorMessage", "Room ID không hợp lệ hoặc bị thiếu.");
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        try {
            Room room = roomDao.getById(roomId); 

            if (room != null) {
                request.setAttribute("room", room);
                request.setAttribute("activeMenu", "rooms"); 
                request.getRequestDispatcher("/pages/general/room-details.jsp").forward(request, response);
            } else {
                LOGGER.log(Level.WARNING, "No room found with ID: {0}", roomId);
                request.getSession().setAttribute("cartMessage", "Không tìm thấy phòng với ID " + roomId + "."); 
                request.getSession().setAttribute("cartMessageType", "ERROR");
                request.getRequestDispatcher("/pages/general/rooms.jsp").forward(request, response);            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing RoomDetailsServlet GET request for RoomID: " + roomId, e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải chi tiết phòng: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         LOGGER.log(Level.WARNING, "POST request received by RoomDetailsServlet, which is not supported. Redirecting to home.");
         response.sendRedirect(request.getContextPath() + "/home");
    }
}

