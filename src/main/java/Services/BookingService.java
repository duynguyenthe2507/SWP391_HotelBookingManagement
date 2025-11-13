package Services;

// === SỬA LỖI: Thêm các import DAO tường minh ===
import Dao.BookingDao;
import Dao.BookingDetailDao;
import Dao.InvoiceDao;
import Dao.RoomDao;
import Dao.ServicesDao;
import Dao.FeedbackDao; // <<< THÊM IMPORT
// === HẾT SỬA LỖI ===

import Models.Booking;
import Models.BookingDetail;
import Models.BookingDetailsViewModel;
import Models.Category;
import Models.Room;
import Models.Services;
import Models.Feedback; // <<< THÊM IMPORT

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ... (Các comment cũ) ...
 * === CẬP NHẬT (13/11/2025) ===
 * 6. Sửa logic tính 'finalTotalPrice' để NHÂN tiền dịch vụ với số đêm.
 */
public class BookingService {

    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private BookingDao bookingDao;
    private RoomDao roomDao;
    private ServicesDao servicesDao;
    private BookingDetailDao bookingDetailDao;
    private InvoiceDao invoiceDao;
    private FeedbackDao feedbackDao; // <<< THÊM DAO MỚI

    public BookingService() {
        this.bookingDao = new BookingDao();
        this.roomDao = new RoomDao();
        this.servicesDao = new ServicesDao();
        this.bookingDetailDao = new BookingDetailDao();
        this.invoiceDao = new InvoiceDao();
        this.feedbackDao = new FeedbackDao(); // <<< KHỞI TẠO DAO
    }

    // ============ OFFLINE BOOKING METHODS (Code gốc của bạn - Chính xác) ============
    public boolean createOfflineBooking(Booking booking, String[] serviceIds) {
        try {
            int bookingId = bookingDao.insertOfflineBooking(booking);
            if (bookingId == -1) {
                LOGGER.log(Level.WARNING, "Failed to insert booking into database.");
                return false;
            }
            LOGGER.log(Level.INFO, "Inserted new booking with ID: {0}", bookingId);

            if (serviceIds != null && serviceIds.length > 0) {
                Map<Integer, Services> servicesMap = servicesDao.getAllServicesAsMap();

                if (servicesMap == null || servicesMap.isEmpty()) {
                    LOGGER.log(Level.WARNING, "Could not retrieve services map for linking.");
                } else {
                    // Sửa lỗi: Tên bảng đúng là ServiceRequest
                    bookingDao.linkServicesToBooking(bookingId, serviceIds, servicesMap);
                    LOGGER.log(Level.INFO, "Linked {0} services to booking ID: {1}", new Object[]{serviceIds.length, bookingId});
                }
            }

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

    public BookingDetailsViewModel getBookingDetails(int bookingId) {
        Map<String, Object> basicDetails = bookingDao.getBookingDetailsById(bookingId);
        if (basicDetails == null) {
            return null;
        }
        List<Map<String, Object>> servicesUsed = servicesDao.getServicesByBookingId(bookingId);
        
        // === LOGIC MỚI ===
        // Lấy feedback (nếu có) liên quan đến booking này
        Feedback feedback = feedbackDao.getReviewByBookingId(bookingId);
        // === KẾT THÚC LOGIC MỚI ===
        
        BookingDetailsViewModel viewModel = new BookingDetailsViewModel();
        viewModel.setBooking((Booking) basicDetails.get("booking"));
        viewModel.setRoom((Room) basicDetails.get("room"));
        viewModel.setCustomerName((String) basicDetails.get("customerName"));
        viewModel.setReceptionistName((String) basicDetails.get("receptionistName"));
        viewModel.setServices(servicesUsed);
        viewModel.setFeedback(feedback); // <<< GÁN FEEDBACK VÀO VIEWMODEL
        
        // (Logic lấy invoiceId của bạn - giữ nguyên nếu có)
        
        return viewModel;
    }

    public boolean checkInBooking(int bookingId, int roomId) {
        try {
            boolean bookingUpdated = bookingDao.updateBookingStatusAndCheckInTime(bookingId, "checked-in", LocalDateTime.now());
            if (!bookingUpdated) {
                return false;
            }
            boolean roomUpdated = roomDao.updateRoomStatus(roomId, "occupied");
            if (!roomUpdated) {
                return false;
            }
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during checking in for bookingId:" + bookingId, e);
            return false;
        }
    }

    public boolean checkOutBooking(int bookingId, int roomId) {
        try {
            boolean bookingUpdated = bookingDao.updateBookingStatusAndCheckOutTime(bookingId, "checked-out", LocalDateTime.now());
            if (!bookingUpdated) {
                return false;
            }
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during checking out for bookingId:" + bookingId, e);
            return false;
        }
    }

    // ============ ONLINE BOOKING METHODS (ĐÃ SỬA LỖI) ============
    /**
     * SỬA LỖI 2: Thêm 'setRoomId'
     * SỬA LỖI 3: Sửa logic tính 'finalTotalPrice' để bao gồm tiền dịch vụ
    */
    public int createBooking(int userId, List<Integer> roomIds, LocalDateTime checkIn, LocalDateTime checkOut,
                             List<Integer> quantities, List<String> specialRequests, String initialStatus,
                             List<String> serviceIds) {

        System.out.println(">>> [BookingService] createBooking STARTING...");

        // Validate input (Code gốc của bạn - Chính xác)
        if (roomIds == null || roomIds.isEmpty()) {
            System.out.println("!!! BOOKING SERVICE LỖI: roomIds is null or empty !!!");
            LOGGER.log(Level.WARNING, "No rooms selected for booking.");
            return -1;
        }
        if (quantities == null || quantities.size() != roomIds.size()) {
            System.out.println("!!! BOOKING SERVICE LỖI: quantities size mismatch !!!");
            LOGGER.log(Level.WARNING, "Quantities list size must match the number of room IDs.");
            return -1;
        }
        if (checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            System.out.println("!!! BOOKING SERVICE LỖI: Invalid dates !!!");
            LOGGER.log(Level.WARNING, "Invalid check-in ({0}) or check-out ({1}) dates.", new Object[]{checkIn, checkOut});
            return -1;
        }

        // Check room availability and gather price information
        List<Room> selectedRooms = new ArrayList<>();
        double baseTotalPrice = 0; // Đây chỉ là tổng giá phòng (chưa nhân số đêm)

        for (int i = 0; i < roomIds.size(); i++) {
            Integer roomId = roomIds.get(i);
            Integer quantity = quantities.get(i);

            try {
                // HÀM NÀY (isRoomAvailable) ĐÃ ĐƯỢC SỬA LỖI LOGIC 1
                if (!isRoomAvailable(roomId, checkIn, checkOut)) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " is NOT available (isRoomAvailable=false) !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: isRoomAvailable() returned false for RoomID {0}", roomId);
                    return -1;
                }

                Room room = roomDao.getById(roomId);
                if (room == null) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " is NULL in DB !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: roomDao.getById() returned null for RoomID {0}", roomId);
                    return -1;
                }

                // (Đã xóa logic kiểm tra 'room.getStatus()' bị lỗi)
                if (quantity <= 0 || quantity > room.getCapacity()) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " capacity exceeded (Qty: " + quantity + ", Cap: " + room.getCapacity() + ") !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: Guest count {0} exceeds capacity {1} for RoomID {2}", new Object[]{quantity, room.getCapacity(), roomId});
                    return -1;
                }

                selectedRooms.add(room);
                baseTotalPrice += room.getPrice(); // Cộng dồn giá các phòng

            } catch (Exception e) {
                System.out.println("!!!!!!!!!!!!!! EXCEPTION caught in BookingService loop !!!!!!!!!!!!!!");
                e.printStackTrace();
                LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: Exception during availability check for RoomID " + roomId, e);
                return -1;
            }
        }

        System.out.println(">>> [BookingService] All rooms are available. Proceeding to DAO insert...");

        // === SỬA LỖI 3 & 6: LOGIC TÍNH TỔNG TIỀN (ĐÃ CẬP NHẬT) ===
        
        // 1. Tính số đêm
        long durationNights = Duration.between(checkIn.toLocalDate().atStartOfDay(), checkOut.toLocalDate().atStartOfDay()).toDays();
        if (durationNights <= 0) {
            durationNights = 1;
            LOGGER.log(Level.INFO, "Booking duration is less than a day, calculating price for 1 night.");
        }
        
        // 2. Tính tiền phòng
        double totalRoomPrice = baseTotalPrice * durationNights;
        double totalServicesPrice = 0;
        
        // 3. Lấy Map dịch vụ (lấy 1 lần)
        Map<Integer, Services> servicesMap = servicesDao.getAllServicesAsMap();

        // 4. Tính tiền dịch vụ (Chưa nhân số đêm)
        if (serviceIds != null && !serviceIds.isEmpty() && servicesMap != null) {
            LOGGER.log(Level.INFO, "Calculating total price for {0} services.", serviceIds.size());
            for (String serviceIdStr : serviceIds) {
                try {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    if (servicesMap.containsKey(serviceId)) {
                        totalServicesPrice += servicesMap.get(serviceId).getPrice();
                    } else {
                        LOGGER.log(Level.WARNING, "Service ID {0} not found in services map.", serviceId);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid service ID format: {0}", serviceIdStr);
                }
            }
        }
        
        // 5. [SỬA LỖI] Nhân tiền dịch vụ với số đêm
        double finalServicesPrice = totalServicesPrice * durationNights;
        
        // 6. Tính tổng tiền cuối cùng
        double finalTotalPrice = totalRoomPrice + finalServicesPrice;
        
        LOGGER.log(Level.INFO, "Final Price Calculated: Room ({0}) + Services ({1}) = {2} (Services * {3} nights)",
                new Object[]{totalRoomPrice, finalServicesPrice, finalTotalPrice, durationNights});
        
        // === KẾT THÚC SỬA LỖI ===

        // Create Booking object
        Booking newBooking = new Booking();
        newBooking.setUserId(userId);
        newBooking.setCheckinTime(checkIn);
        newBooking.setCheckoutTime(checkOut);
        newBooking.setStatus(initialStatus);
        newBooking.setTotalPrice(finalTotalPrice); // <-- Dòng này bây giờ sẽ dùng TỔNG TIỀN ĐÚNG

        // === SỬA LỖI 2: 'roomId cannot be NULL' ===
        newBooking.setRoomId(roomIds.get(0));
        // === KẾT THÚC SỬA LỖI 2 ===

        // Create list of BookingDetail objects (Code gốc của bạn - Chính xác)
        List<BookingDetail> bookingDetails = new ArrayList<>();
        for (int i = 0; i < selectedRooms.size(); i++) {
            Room room = selectedRooms.get(i);
            Integer quantity = quantities.get(i);
            String specialRequest = (specialRequests != null && i < specialRequests.size()) ? specialRequests.get(i) : null;
            BookingDetail detail = new BookingDetail(room.getRoomId(), room.getPrice(), quantity, null, null);
            detail.setSpecialRequest(specialRequest);
            bookingDetails.add(detail);
        }

        // Call BookingDao (Code gốc của bạn - Chính xác)
        System.out.println(">>> [BookingService] Calling bookingDao.insertBookingWithDetails...");
        boolean success = bookingDao.insertBookingWithDetails(newBooking, bookingDetails);

        if (success) {
            System.out.println(">>> [BookingService] bookingDao.insertBookingWithDetails SUCCEEDED. Returning Booking ID: " + newBooking.getBookingId());
            LOGGER.log(Level.INFO, "New booking created successfully with ID: {0} for user {1}.",
                    new Object[]{newBooking.getBookingId(), userId});
            
            // Logic liên kết dịch vụ (bây giờ đã có sẵn 'servicesMap')
            if (serviceIds != null && !serviceIds.isEmpty()) {
                try {
                    // Map đã được lấy ở trên, không cần lấy lại
                    // Map<Integer, Services> servicesMap = servicesDao.getAllServicesAsMap();
                    bookingDao.linkServicesToBooking(newBooking.getBookingId(), serviceIds.toArray(new String[0]), servicesMap);

                    LOGGER.log(Level.INFO, "Linked {0} services to new booking {1}",
                            new Object[]{serviceIds.size(), newBooking.getBookingId()});
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Booking created but FAILED to link services", e);
                }
            }
            return newBooking.getBookingId();
        } else {
            System.out.println("!!! BOOKING SERVICE LỖI: bookingDao.insertBookingWithDetails() returned false !!!");
            LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: bookingDao.insertBookingWithDetails() returned false for user {0}.", userId);
            return -1;
        }
    }

    // ============ COMMON BOOKING STATUS METHODS (Code gốc của bạn - Chính xác) ============
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        if (newStatus == null || !List.of("pending", "confirmed", "cancelled", "completed", "checked-in").contains(newStatus.toLowerCase())) {
            // (Đã thêm 'checked-in' từ hàm offline)
            LOGGER.log(Level.WARNING, "Attempted to update booking {0} with invalid status: {1}", new Object[]{bookingId, newStatus});
            return false;
        }
        boolean success = bookingDao.updateBookingStatus(bookingId, newStatus);
        if (success) {
            LOGGER.log(Level.INFO, "Booking {0} status updated to '{1}'.", new Object[]{bookingId, newStatus});
        } else {
            LOGGER.log(Level.WARNING, "Failed to update booking {0} status to '{1}'. Check DAO logs.", new Object[]{bookingId, newStatus});
        }
        return success;
    }

    public boolean cancelBooking(int bookingId) {
        try {
            Booking booking = getBookingById(bookingId);
            if (booking == null) {
                LOGGER.log(Level.WARNING, "Booking {0} not found.", bookingId);
                return false;
            }

            if ("completed".equalsIgnoreCase(booking.getStatus())) {
                LOGGER.log(Level.WARNING, "Booking {0} already completed", bookingId);
                return false;
            }

            // ✅ FIX: Gọi updateBookingStatus sẽ tự động update Room status
            boolean success = updateBookingStatus(bookingId, "cancelled");

            if (success) {
                LOGGER.log(Level.INFO, "✅ Booking {0} cancelled successfully", bookingId);
            } else {
                LOGGER.log(Level.SEVERE, "❌ Failed to cancel booking {0}", bookingId);
            }

            return success;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error cancelling booking " + bookingId, e);
            e.printStackTrace();
            return false;
        }
    }

    public boolean confirmBooking(int bookingId) {
        try {
            Booking booking = getBookingById(bookingId);
            if (booking == null) {
                LOGGER.log(Level.WARNING, "Booking {0} not found.", bookingId);
                return false;
            }

            if (!"pending".equalsIgnoreCase(booking.getStatus())) {
                LOGGER.log(Level.WARNING, "Booking {0} status is {1}, not pending",
                        new Object[]{bookingId, booking.getStatus()});
                return false;
            }

            // ✅ FIX: Gọi updateBookingStatus sẽ tự động update Room status
            boolean success = updateBookingStatus(bookingId, "confirmed");

            if (success) {
                LOGGER.log(Level.INFO, "✅ Booking {0} confirmed successfully", bookingId);
            } else {
                LOGGER.log(Level.SEVERE, "❌ Failed to confirm booking {0}", bookingId);
            }

            return success;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error confirming booking " + bookingId, e);
            e.printStackTrace();
            return false;
        }
    }

    public boolean completeBooking(int bookingId) {
        // (Code gốc của bạn - Chính xác)
        Booking booking = getBookingById(bookingId);
        if (booking != null) {
            if (!"confirmed".equalsIgnoreCase(booking.getStatus())) {
                LOGGER.log(Level.WARNING, "Booking {0} cannot be completed because its status is {1} (must be 'confirmed').",
                        new Object[]{bookingId, booking.getStatus()});
                return false;
            }
        } else {
            LOGGER.log(Level.WARNING, "Booking {0} not found, cannot complete.", bookingId);
            return false;
        }
        return updateBookingStatus(bookingId, "completed");
    }

    // ============ READ/QUERY METHODS (Code gốc của bạn - Chính xác) ============
    public List<Booking> getAllBookings() {
        try {
            return bookingDao.getAllBookings();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all bookings.", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public Booking getBookingById(int bookingId) {
        try {
            return bookingDao.getBookingById(bookingId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving booking by ID: " + bookingId, e);
            e.printStackTrace();
            return null;
        }
    }

    public Room getRoomById(int roomId) {
        try {
            return roomDao.getById(roomId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving room by ID: " + roomId, e);
            e.printStackTrace();
            return null;
        }
    }

    public List<Category> getAllCategories() {
        try {
            return roomDao.getAllCategories();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all categories.", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Booking> getBookingsByUserId(int userId) {
        try {
            return bookingDao.getBookingsByUserId(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving bookings for user: " + userId, e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // === HÀM MỚI CHO LỊCH SỬ BOOKING (ĐÃ CẬP NHẬT PHÂN TRANG & LỌC) ===
    
    /**
     * [CẬP NHẬT] Lấy danh sách booking (đã join) cho một user, CÓ PHÂN TRANG VÀ LỌC
     */
    public List<Map<String, Object>> getDetailedBookingsByUserId(int userId, String keyword, String status, int pageNumber, int pageSize) {
        try {
            // Truyền keyword và status xuống DAO
            return bookingDao.getDetailedBookingsByUserId(userId, keyword, status, pageNumber, pageSize);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving detailed bookings for user: " + userId, e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * [CẬP NHẬT] Đếm tổng số booking của user, CÓ LỌC
     */
    public int countDetailedBookingsByUserId(int userId, String keyword, String status) {
        try {
            // Truyền keyword và status xuống DAO
            return bookingDao.countBookingsByUserId(userId, keyword, status);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting detailed bookings for user: " + userId, e);
            e.printStackTrace();
            return 0;
        }
    }
    // === KẾT THÚC HÀM MỚI ===

    public List<BookingDetail> getBookingDetailsList(int bookingId) {
        try {
            if (bookingDetailDao == null) {
                LOGGER.log(Level.SEVERE, "BookingDetailDao is not initialized in BookingService.");
                return new ArrayList<>();
            }
            return bookingDetailDao.getBookingDetailsByBookingId(bookingId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving booking details for booking: " + bookingId, e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ============ AVAILABILITY CHECKING METHODS (ĐÃ SỬA LỖI) ============
    public List<Room> getAvailableRooms(LocalDateTime checkIn, LocalDateTime checkOut, String searchKeyword,
                                        Integer categoryId, Double minPrice, Double maxPrice,
                                        Integer minCapacity, int pageNumber, int pageSize) {
        if (checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            LOGGER.log(Level.WARNING, "Invalid date range for getAvailableRooms: CheckIn={0}, CheckOut={1}", new Object[]{checkIn, checkOut});
            return new ArrayList<>();
        }

        try {
            String checkInDateStr = checkIn.format(DATE_FORMATTER);
            String checkOutDateStr = checkOut.format(DATE_FORMATTER);

            // HÀM NÀY (isRoomAvailable) ĐÃ ĐƯỢC SỬA LỖI LOGIC 1
            // Truyền 'available' vào roomDao.findAllRooms là ĐÚNG
            return roomDao.findAllRooms(searchKeyword, categoryId, minPrice, maxPrice,
                    minCapacity, checkInDateStr, checkOutDateStr, "available",
                    pageNumber, pageSize);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting available rooms.", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Room> getAvailableRooms(LocalDateTime checkIn, LocalDateTime checkOut) {
        return getAvailableRooms(checkIn, checkOut, null, null, null, null, null, 1, Integer.MAX_VALUE);
    }

    public int getAvailableRoomsCount(LocalDateTime checkIn, LocalDateTime checkOut, String searchKeyword,
                                        Integer categoryId, Double minPrice, Double maxPrice,
                                        Integer minCapacity) {
        if (checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            LOGGER.log(Level.WARNING, "Invalid date range for getAvailableRoomsCount: CheckIn={0}, CheckOut={1}", new Object[]{checkIn, checkOut});
            return 0;
        }

        try {
            String checkInDateStr = checkIn.format(DATE_FORMATTER);
            String checkOutDateStr = checkOut.format(DATE_FORMATTER);

            return roomDao.getTotalRoomsCount(searchKeyword, categoryId, minPrice, maxPrice,
                    minCapacity, checkInDateStr, checkOutDateStr, "available");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting available rooms count.", e);
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * SỬA LỖI 1: Bỏ qua kiểm tra 'room.getStatus()', chỉ tin vào
     * 'isRoomBookedDuringDates' (logic chồng chéo ngày).
    */
    public boolean isRoomAvailable(int roomId, LocalDateTime checkIn, LocalDateTime checkOut) {
        if (checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            LOGGER.log(Level.WARNING, "Invalid date range: RoomID={0}, CheckIn={1}, CheckOut={2}",
                    new Object[]{roomId, checkIn, checkOut});
            return false;
        }

        try {
            Room room = roomDao.getById(roomId);
            if (room == null) {
                LOGGER.log(Level.WARNING, "Room {0} not found.", roomId);
                return false;
            }

            // ✅ FIX: CHỈ CHO PHÉP BOOK PHÒNG CÓ STATUS = "available"
            String status = room.getStatus();
            if (!"available".equalsIgnoreCase(status)) {
                LOGGER.log(Level.WARNING,
                        "Room {0} is NOT available (status=''{1}'')",
                        new Object[]{roomId, status});
                return false;
            }

            // ✅ FIX: Kiểm tra overlap (bao gồm cả pending/confirmed/checked-in)
            boolean isOverlapping = bookingDao.isRoomBookedDuringDates(roomId, checkIn, checkOut);

            if (isOverlapping) {
                LOGGER.log(Level.WARNING,
                        "Room {0} has overlapping booking during {1} to {2}",
                        new Object[]{roomId, checkIn, checkOut});
                return false;
            }

            LOGGER.log(Level.INFO,
                    "Room {0} is AVAILABLE (status={1}, no overlap)",
                    new Object[]{roomId, status});

            return true;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking room availability for roomId: " + roomId, e);
            e.printStackTrace();
            return false;
        }
    }

    public List<Booking> getCurrentBookings() {
        try {
            return bookingDao.getCurrentBookings();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving current bookings.", e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Booking> getBookingsByStatus(String status) {
        try {
            return bookingDao.getBookingsByStatus(status);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving bookings by status: " + status, e);
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    public int findCompletedBookingId(int userId, int roomId) {
        if (userId <= 0 || roomId <= 0) {
            return 0;
        }
        try {
            return bookingDao.findCompletedBookingId(userId, roomId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookingService.findCompletedBookingId", e);
            return 0;
        }
    }
}