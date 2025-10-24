package Controller;

import Dao.RoomDao;
import Dao.CategoryDao;
import Models.Room;
import Models.Category;
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

@WebServlet("/receptionist/room-fee-detail")
public class RoomFeeDetailController extends HttpServlet {
    
    private final RoomDao roomDao = new RoomDao();
    private final CategoryDao categoryDao = new CategoryDao();

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
            String roomIdParam = request.getParameter("roomId");
            System.out.println("RoomFeeDetailController: roomIdParam = " + roomIdParam);
            
            if (roomIdParam == null || roomIdParam.isEmpty()) {
                System.out.println("RoomFeeDetailController: No roomId parameter, redirecting to room-fees");
                response.sendRedirect(request.getContextPath() + "/receptionist/room-fees");
                return;
            }
            
            int roomId = Integer.parseInt(roomIdParam);
            System.out.println("RoomFeeDetailController: Parsed roomId = " + roomId);
            
            // Get detailed room information
            Room room = roomDao.getById(roomId);
            System.out.println("RoomFeeDetailController: Retrieved room = " + (room != null ? room.getName() : "null"));
            if (room == null) {
                System.out.println("RoomFeeDetailController: Room not found for ID: " + roomId);
                request.setAttribute("error", "Room not found.");
                request.getRequestDispatcher("/pages/receptionist/room-fee-detail.jsp").forward(request, response);
                return;
            }
            
            // Get category information
            Category category = categoryDao.getById(room.getCategoryId());
            
            // Get room with category info for detailed view
            List<Map<String, Object>> roomWithCategory = roomDao.getRoomWithCategoryInfo(roomId);
            
            // Get similar rooms in the same category
            List<Map<String, Object>> similarRooms = roomDao.getRoomsByCategory(category.getName());
            similarRooms.removeIf(roomInfo -> roomInfo.get("roomId").equals(roomId));
            
            // Set attributes for JSP
            request.setAttribute("room", room);
            request.setAttribute("category", category);
            request.setAttribute("roomWithCategory", roomWithCategory.isEmpty() ? null : roomWithCategory.get(0));
            request.setAttribute("similarRooms", similarRooms);
            
            // Forward to room fee detail page
            request.getRequestDispatcher("/pages/receptionist/room-fee-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid room ID.");
            try {
                request.getRequestDispatcher("/pages/receptionist/room-fee-detail.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/receptionist/room-fees");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading room details.");
            try {
                request.getRequestDispatcher("/pages/receptionist/room-fee-detail.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/receptionist/room-fees");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
