package Controller.General;

import Dao.RoomDao; 
import Models.Category;
import Models.Room;
import Services.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(name = "RoomsServlet", urlPatterns = {"/old-rooms"})
public class RoomsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RoomsServlet.class.getName());
    private static final DateTimeFormatter DATE_PICKER_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final LocalTime DEFAULT_CHECK_IN_TIME = LocalTime.of(14, 0); 
    private static final LocalTime DEFAULT_CHECK_OUT_TIME = LocalTime.of(12, 0); 

    private BookingService bookingService;
    private RoomDao roomDao; 

    @Override
    public void init() throws ServletException {
        this.bookingService = new BookingService();
        this.roomDao = new RoomDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            String searchKeyword = request.getParameter("search");
            String categoryIdStr = request.getParameter("categoryId");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            String minCapacityStr = request.getParameter("minCapacity");
            String checkInDateStr = request.getParameter("checkInDate");
            String checkOutDateStr = request.getParameter("checkOutDate");
            String statusFilter = request.getParameter("statusFilter"); // (Thường là "available" nếu bạn thêm bộ lọc này)
            String pageStr = request.getParameter("page");

            Integer categoryId = parseInteger(categoryIdStr);
            Double minPrice = parseDouble(minPriceStr);
            Double maxPrice = parseDouble(maxPriceStr);
            Integer minCapacity = parseInteger(minCapacityStr);

            LocalDateTime checkIn = parseDate(checkInDateStr, DEFAULT_CHECK_IN_TIME);
            LocalDateTime checkOut = parseDate(checkOutDateStr, DEFAULT_CHECK_OUT_TIME);

             if (checkIn != null && checkOut == null) {
                 checkIn = null; 
             } else if (checkIn == null && checkOut != null) {
                 checkOut = null; 
             } else if (checkIn != null && checkOut != null && !checkOut.isAfter(checkIn)) {
                 
                 checkIn = null;
                 checkOut = null;
                 request.setAttribute("dateError", "Check-out date must be after check-in date.");
             }
            
        
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid page number format: {0}", pageStr);
                    currentPage = 1;
                }
            }
            int pageSize = 6;
            List<Category> categories = roomDao.getAllCategories();

            // Lấy tổng số phòng (để phân trang)
            int totalRooms = bookingService.getAvailableRoomsCount(
                    checkIn, checkOut, searchKeyword, categoryId, minPrice, maxPrice, minCapacity
            );
            List<Room> rooms = bookingService.getAvailableRooms(
                    checkIn, checkOut, searchKeyword, categoryId, minPrice, maxPrice,
                    minCapacity, currentPage, pageSize
            );
            int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

            request.setAttribute("rooms", rooms);
            request.setAttribute("categories", categories);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalRooms", totalRooms);

            request.setAttribute("activeMenu", "rooms");

            request.getRequestDispatcher("/pages/general/rooms.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing RoomsServlet GET request", e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải danh sách phòng. Vui lòng thử lại. Lỗi: " + e.getMessage());
            e.printStackTrace(); 
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response); // Chuyển đến trang lỗi chung
        }
    }

    
    private Integer parseInteger(String str) {
        if (str == null || str.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(str);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Failed to parse Integer: {0}", str);
            return null;
        }
    }

    
    private Double parseDouble(String str) {
        if (str == null || str.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(str);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Failed to parse Double: {0}", str);
            return null;
        }
    }

 
    private LocalDateTime parseDate(String dateStr, LocalTime time) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        try {
            LocalDate date = LocalDate.parse(dateStr.trim(), DATE_PICKER_FORMATTER);
            return date.atTime(time);
        } catch (DateTimeParseException e) {
            LOGGER.log(Level.WARNING, "Failed to parse date string: {0} with format dd/MM/yyyy", dateStr);
            return null;
        }
    }
}

