package Services;

import Dao.BookingDao;
import Dao.RoomDao;
import Dao.ServicesDao;
import Models.Booking;
import Models.Services;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingService {

    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());

    private BookingDao bookingDao;
    private RoomDao roomDao;
    private ServicesDao servicesDao;

    // Sử dụng constructor để khởi tạo các DAO
    public BookingService() {
        this.bookingDao = new BookingDao();
        this.roomDao = new RoomDao();
        this.servicesDao = new ServicesDao();
    }

    public boolean createOfflineBooking(Booking booking, String[] serviceIds) {
        try {
            int bookingId = bookingDao.insertOfflineBooking(booking);
            if (bookingId == -1) {
                LOGGER.log(Level.WARNING, "Failed to insert booking into database.");
                return false; // Lỗi khi tạo booking
            }
            LOGGER.log(Level.INFO, "Inserted new booking with ID: {0}", bookingId);

            // Liên kết các dịch vụ đã chọn (nếu có)
            if (serviceIds != null && serviceIds.length > 0) {
                // Lấy Map của tất cả services để có thông tin giá
                // Gọi phương thức instance trên đối tượng instance servicesDao
                Map<Integer, Services> servicesMap = servicesDao.getAllServicesAsMap();

                if (servicesMap == null || servicesMap.isEmpty()) {
                    LOGGER.log(Level.WARNING, "Could not retrieve services map for linking.");
                } else {
                    bookingDao.linkServicesToBooking(bookingId, serviceIds, servicesMap);
                    LOGGER.log(Level.INFO, "Linked {0} services to booking ID: {1}", new Object[]{serviceIds.length, bookingId});
                }
            }

            // Cập nhật trạng thái phòng thành "booked"
            boolean statusUpdated = roomDao.updateRoomStatus(booking.getRoomId(), "booked");
            if (!statusUpdated) {
                LOGGER.log(Level.WARNING, "Failed to update room status for roomId: {0}", booking.getRoomId());
            } else {
                LOGGER.log(Level.INFO, "Updated room status to 'booked' for roomId: {0}", booking.getRoomId());
            }

            return true;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating offline booking", e);
            return false;
        }
    }
}