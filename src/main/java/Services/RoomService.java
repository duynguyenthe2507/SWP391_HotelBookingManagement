package Services;

import Dao.RoomDao;
import Models.Category;
import Models.Room;

import java.time.LocalDateTime; 
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoomService {

    private static final Logger LOGGER = Logger.getLogger(RoomService.class.getName());
    private RoomDao roomDao;

    public RoomService() {
        this.roomDao = new RoomDao();
    }

    public Room getRoomById(int roomId) {
        try {
            return roomDao.getById(roomId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.getRoomById for ID: " + roomId, e);
            e.printStackTrace(); 
            return null; 
        }
    }

    public List<Room> findAllRooms(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice,
                                   Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter,
                                   int pageNumber, int pageSize) {
        try {
            return roomDao.findAllRooms(searchKeyword, categoryId, minPrice, maxPrice,
                                         minCapacity, checkInDate, checkOutDate, statusFilter,
                                         pageNumber, pageSize);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.findAllRooms", e);
            e.printStackTrace();
            return new ArrayList<>(); 
        }
    }

    public int getTotalRoomsCount(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice,
                                  Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter) {
        try {
            return roomDao.getTotalRoomsCount(searchKeyword, categoryId, minPrice, maxPrice,
                                               minCapacity, checkInDate, checkOutDate, statusFilter);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.getTotalRoomsCount", e);
            e.printStackTrace();
            return 0;
        }
    }
    public List<Category> getAllCategories() {
        try {
            return roomDao.getAllCategories();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomService.getAllCategories", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

