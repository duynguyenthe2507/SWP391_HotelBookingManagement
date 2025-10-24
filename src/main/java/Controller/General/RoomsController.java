package Controller.General;

import Dao.RoomDao;
import Models.Category;
import Models.Room;
import Services.RoomService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/rooms")
public class RoomsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RoomsController.class.getName());
    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.roomService = new RoomService(); 
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String searchKeyword = request.getParameter("search");
            String categoryIdParam = request.getParameter("categoryId");
            String minPriceParam = request.getParameter("minPrice");
            String maxPriceParam = request.getParameter("maxPrice");
            String minCapacityParam = request.getParameter("minCapacity");
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");
            String statusFilter = request.getParameter("statusFilter");

            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");

            Integer categoryId = (categoryIdParam != null && !categoryIdParam.isEmpty()) ? Integer.parseInt(categoryIdParam) : null;
            Double minPrice = (minPriceParam != null && !minPriceParam.isEmpty()) ? Double.parseDouble(minPriceParam) : null;
            Double maxPrice = (maxPriceParam != null && !maxPriceParam.isEmpty()) ? Double.parseDouble(maxPriceParam) : null;
            Integer minCapacity = (minCapacityParam != null && !minCapacityParam.isEmpty()) ? Integer.parseInt(minCapacityParam) : null;
            
            int pageNumber = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    pageNumber = Integer.parseInt(pageParam);
                    if (pageNumber < 1) pageNumber = 1;
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid page number format: " + pageParam, e);
                }
            }

            int pageSize = 6;
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 1) pageSize = 6; 
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid page size format: " + pageSizeParam, e);
                }
            }
            List<Room> rooms = roomService.findAllRooms(
                searchKeyword, categoryId, minPrice, maxPrice, minCapacity,
                checkInDate, checkOutDate, statusFilter, 
                pageNumber, pageSize
            );
            
            int totalRooms = roomService.getTotalRoomsCount(
                searchKeyword, categoryId, minPrice, maxPrice, minCapacity,
                checkInDate, checkOutDate, statusFilter 
            );
            
            int noOfPages = (int) Math.ceil((double) totalRooms / pageSize); 
            if (noOfPages == 0 && totalRooms > 0) noOfPages = 1; 

            List<Category> categories = roomService.getAllCategories();

            request.setAttribute("rooms", rooms); 
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", pageNumber);
            request.setAttribute("noOfPages", noOfPages); 
            request.setAttribute("search", searchKeyword);
            request.setAttribute("categoryId", categoryId); 
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);
            request.setAttribute("minCapacity", minCapacity);
            request.setAttribute("checkInDate", checkInDate); 
            request.setAttribute("checkOutDate", checkOutDate); 
            request.setAttribute("statusFilter", statusFilter); 
            request.getRequestDispatcher("/pages/general/rooms.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format in request parameters", e);
            request.setAttribute("errorMessage", "Vui lòng nhập định dạng số hợp lệ cho giá, sức chứa hoặc số trang.");
            request.getRequestDispatcher("/pages/general/rooms.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomsController", e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi tải danh sách phòng.");
            request.getRequestDispatcher("/pages/general/rooms.jsp").forward(request, response); 
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); 
    }
}