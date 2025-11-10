package Controller.General;

import Models.Room;
import Services.RoomService; // Dùng RoomService từ Nguồn 3
import com.google.gson.Gson; // DÙNG GSON
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/api/available-rooms")
public class AvailableRoomsApiController extends HttpServlet {

    private RoomService roomService;
    private Gson gson = new Gson();
    private static final Logger LOGGER = Logger.getLogger(AvailableRoomsApiController.class.getName());

    @Override
    public void init() throws ServletException {
        this.roomService = new RoomService(); // Khởi tạo RoomService (Nguồn 3)
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String categoryIdParam = request.getParameter("categoryId");
            String checkInDate = request.getParameter("checkInDate");
            String checkOutDate = request.getParameter("checkOutDate");

            if (categoryIdParam == null || checkInDate == null || checkOutDate == null ||
                    checkInDate.isEmpty() || checkOutDate.isEmpty() || categoryIdParam.isEmpty()) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(Map.of("error", "Missing required parameters: categoryId, checkInDate, checkOutDate")));
                return;
            }

            Integer categoryId = Integer.parseInt(categoryIdParam);

            // Gọi RoomService (Nguồn 3) để tìm phòng
            List<Room> rooms = roomService.findAllRooms(
                    null, categoryId, null, null, null,
                    checkInDate, checkOutDate, "available",
                    1, 100 // Lấy tối đa 100 phòng
            );

            // Chuyển đổi thành JSON đơn giản
            List<Map<String, String>> availableRoomsJson = rooms.stream()
                    .map(room -> Map.of(
                            "id", String.valueOf(room.getRoomId()),
                            "name", room.getName()
                    ))
                    .collect(Collectors.toList());

            response.getWriter().write(gson.toJson(availableRoomsJson));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of("error", "Invalid categoryId format")));
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching available rooms", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of("error", e.getMessage())));
        }
    }
}