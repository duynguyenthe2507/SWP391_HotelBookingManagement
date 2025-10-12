package Controller;

import DAL.RoomDao;
import DAL.CategoryDao;
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

@WebServlet("/receptionist/room-fees")
public class ViewRoomFeeController extends HttpServlet {
    
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
            // Get all rooms with their fees and category information
            List<Map<String, Object>> roomsWithCategory = roomDao.getRoomsWithCategoryInfo();
            
            // Get all categories for reference
            List<Category> categories = categoryDao.getAll();
            
            // Set attributes for JSP
            request.setAttribute("roomsWithCategory", roomsWithCategory);
            request.setAttribute("categories", categories);
            
            // Forward to receptionist room fees page
            request.getRequestDispatcher("/pages/receptionist/room-fees.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading room fees.");
            request.getRequestDispatcher("/pages/receptionist/room-fees.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
