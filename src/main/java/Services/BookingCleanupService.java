package Services;

import Dao.BookingDao;
import Dao.RoomDao;
import Models.Booking;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * (Code này từ phân tích của bạn - Giải pháp 1)
 * Service này chạy ngầm (background job) để tự động hủy
 * các Booking 'pending' đã quá hạn (quá 15 phút),
 * giúp giải phóng các phòng bị "khóa".
 */
public class BookingCleanupService {
    
    private static final Logger LOGGER = Logger.getLogger(BookingCleanupService.class.getName());
    private static final int TIMEOUT_MINUTES = 15; // Timeout VNPay
    private static BookingCleanupService instance;
    private ScheduledExecutorService scheduler;
    
    private BookingCleanupService() {
        scheduler = Executors.newSingleThreadScheduledExecutor();
    }
    
    public static BookingCleanupService getInstance() {
        if (instance == null) {
            instance = new BookingCleanupService();
        }
        return instance;
    }
    
    /**
     * Bắt đầu job tự động (gọi khi khởi động ứng dụng)
     */
    public void start() {
        // Chạy mỗi 5 phút
        scheduler.scheduleAtFixedRate(this::cleanupExpiredBookings, 0, 5, TimeUnit.MINUTES);
        LOGGER.info("✅ Booking cleanup service started (runs every 5 minutes)");
    }
    
    /**
     * Dọn dẹp booking pending quá hạn
     */
    private void cleanupExpiredBookings() {
        LOGGER.info("🔄 Running booking cleanup...");
        
        // Dùng try-with-resources (BookingDao đã implements AutoCloseable)
        try (BookingDao bookingDao = new BookingDao()) { 
            List<Booking> pendingBookings = bookingDao.getBookingsByStatus("pending");
            LocalDateTime now = LocalDateTime.now();
            int cleanedCount = 0;
            
            if (pendingBookings.size() > 10) {
                 LOGGER.log(Level.WARNING, "⚠️ Too many pending bookings: {0}", pendingBookings.size());
            }

            for (Booking booking : pendingBookings) {
                LocalDateTime createdAt = booking.getCreatedAt();
                long minutesSinceCreation = java.time.Duration.between(createdAt, now).toMinutes();
                
                if (minutesSinceCreation > TIMEOUT_MINUTES) {
                    // Hủy booking và giải phóng phòng
                    // (Hàm updateBookingStatus đã có logic trả phòng về 'available')
                    boolean cancelled = bookingDao.updateBookingStatus(booking.getBookingId(), "cancelled"); 
                    
                    if (cancelled) {
                        cleanedCount++;
                        LOGGER.log(Level.INFO, "✅ Auto-cancelled expired booking #{0} (Created: {1}, Age: {2} mins)", 
                                new Object[]{booking.getBookingId(), createdAt, minutesSinceCreation});
                    }
                }
            }
            
            if (cleanedCount > 0) {
                LOGGER.log(Level.INFO, "✅ Cleanup completed: {0} booking(s) cancelled", cleanedCount);
            } else {
                LOGGER.info("✅ Cleanup completed: No expired bookings found");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Error during booking cleanup", e);
        }
    }
    
    /**
     * Dừng service (gọi khi shutdown ứng dụng)
     */
    public void stop() {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            LOGGER.info("🛑 Booking cleanup service stopped");
        }
    }
}