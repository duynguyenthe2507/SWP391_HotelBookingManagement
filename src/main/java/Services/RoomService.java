package Services;

import Dao.RoomDao;
import Models.Category;
import Models.Room;

// Thêm các import cần thiết
import java.time.LocalDateTime; // Import LocalDateTime
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Lớp Service này chuyên xử lý các nghiệp vụ liên quan đến
 * TÌM KIẾM và LẤY THÔNG TIN phòng và loại phòng.
 * Nó được gọi bởi RoomsController.
 */
public class RoomService {

    private static final Logger LOGGER = Logger.getLogger(RoomService.class.getName());
    private RoomDao roomDao;
    // private CategoryDao categoryDao; // Bạn có thể thêm CategoryDao riêng nếu muốn

    public RoomService() {
        this.roomDao = new RoomDao();
        // this.categoryDao = new CategoryDao();
    }

    /**
     * Lấy 1 phòng bằng ID, có xử lý lỗi.
     */
    public Room getRoomById(int roomId) {
        try {
            return roomDao.getById(roomId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.getRoomById for ID: " + roomId, e);
            e.printStackTrace(); // In lỗi ra log
            return null; // Trả về null nếu có lỗi
        }
    }

    /**
     * Lấy danh sách phòng đã lọc và phân trang, có xử lý lỗi.
     * (Sử dụng String cho ngày tháng, để RoomDao tự parse)
     */
    public List<Room> findAllRooms(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice,
                                   Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter,
                                   int pageNumber, int pageSize) {
        try {
            // Truyền thẳng String ngày tháng xuống DAO
            return roomDao.findAllRooms(searchKeyword, categoryId, minPrice, maxPrice,
                                         minCapacity, checkInDate, checkOutDate, statusFilter,
                                         pageNumber, pageSize);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.findAllRooms", e);
            e.printStackTrace();
            return new ArrayList<>(); // Trả về danh sách rỗng nếu có lỗi
        }
    }

    /**
     * Lấy tổng số phòng khớp với bộ lọc, có xử lý lỗi.
     * (Sử dụng String cho ngày tháng, để RoomDao tự parse)
     */
    public int getTotalRoomsCount(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice,
                                  Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter) {
        try {
            // Truyền thẳng String ngày tháng xuống DAO
            return roomDao.getTotalRoomsCount(searchKeyword, categoryId, minPrice, maxPrice,
                                               minCapacity, checkInDate, checkOutDate, statusFilter);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.getTotalRoomsCount", e);
            e.printStackTrace();
            return 0; // Trả về 0 nếu có lỗi
        }
    }

    /**
     * Lấy tất cả các loại phòng (Categories), có xử lý lỗi.
     */
    public List<Category> getAllCategories() {
        try {
            // Giả định hàm này nằm trong RoomDao
            return roomDao.getAllCategories();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.getAllCategories", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

