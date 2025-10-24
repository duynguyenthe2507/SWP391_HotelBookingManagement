package Services;

import Dao.RoomDao;
import Models.Category;
import Models.Room;
import java.util.List;

public class RoomService {
    private RoomDao roomDao;
    public RoomService() {
        this.roomDao = new RoomDao();
    }
    public RoomService(RoomDao roomDao) {
        this.roomDao = roomDao;
    }

    public Room getRoomById(int roomId) {
        return roomDao.getById(roomId);
    }
    public List<Room> findAllRooms(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice, 
                                   Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter,
                                   int pageNumber, int pageSize) {
        return roomDao.findAllRooms(searchKeyword, categoryId, minPrice, maxPrice, 
                                    minCapacity, checkInDate, checkOutDate, statusFilter, 
                                    pageNumber, pageSize);
    }
    public int getTotalRoomsCount(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice, 
                                  Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter) {
        return roomDao.getTotalRoomsCount(searchKeyword, categoryId, minPrice, maxPrice, 
                                        minCapacity, checkInDate, checkOutDate, statusFilter);
    }
    public List<Category> getAllCategories() {
        return roomDao.getAllCategories();
    }
}