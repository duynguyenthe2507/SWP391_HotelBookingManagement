package Services;

import Dao.BookingDao;
import Dao.BookingDetailDao;
import Dao.RoomDao;
import Dao.ServicesDao;
import Models.Booking;
import Models.BookingDetail;
import Models.BookingDetailsViewModel;
import Models.Category;
import Models.Room;
import Models.Services;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingService {
    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private BookingDao bookingDao;
    private RoomDao roomDao;
    private ServicesDao servicesDao;
    private BookingDetailDao bookingDetailDao;

    public BookingService() {
        this.bookingDao = new BookingDao();
        this.roomDao = new RoomDao();
        this.servicesDao = new ServicesDao();
        this.bookingDetailDao = new BookingDetailDao();
    }

    // ============ OFFLINE BOOKING METHODS (from haitn/pushOfflineBooking) ============

    /**
     * Tạo booking offline tại quầy lễ tân (không cần durationHours)
     */
    public boolean createOfflineBooking(Booking booking, String[] serviceIds) {
        try {
            int bookingId = bookingDao.insertOfflineBooking(booking);
            if (bookingId == -1) {
                LOGGER.log(Level.WARNING, "Failed to insert booking into database.");
                return false;
            }
            LOGGER.log(Level.INFO, "Inserted new booking with ID: {0}", bookingId);

            // Liên kết các dịch vụ đã chọn nếu có
            if (serviceIds != null && serviceIds.length > 0) {
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

    /**
     * Lấy chi tiết booking cho receptionist view
     */
    public BookingDetailsViewModel getBookingDetails(int bookingId) {
        Map<String, Object> basicDetails = bookingDao.getBookingDetailsById(bookingId);
        if (basicDetails == null) {
            return null;
        }

        List<Map<String, Object>> servicesUsed = servicesDao.getServicesByBookingId(bookingId);

        BookingDetailsViewModel viewModel = new BookingDetailsViewModel();
        viewModel.setBooking((Booking) basicDetails.get("booking"));
        viewModel.setRoom((Room) basicDetails.get("room"));
        viewModel.setCustomerName((String) basicDetails.get("customerName"));
        viewModel.setReceptionistName((String) basicDetails.get("receptionistName"));
        viewModel.setServices(servicesUsed);

        return viewModel;
    }

    /**
     * Check-in booking
     */
    public boolean checkInBooking(int bookingId, int roomId) {
        try {
            boolean bookingUpdated = bookingDao.updateBookingStatus(bookingId, "checked-in");
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

    /**
     * Check-out booking
     */
    public boolean checkOutBooking(int bookingId, int roomId) {
        try {
            boolean bookingUpdated = bookingDao.updateBookingStatus(bookingId, "available");
            if (!bookingUpdated) {
                return false;
            }

            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during checking out for bookingId:" + bookingId, e);
            return false;
        }
    }

    // ============ ONLINE BOOKING METHODS (from dev branch) ============

    /**
     * Tạo booking online của customer
     */
    public int createBooking(int userId, List<Integer> roomIds, LocalDateTime checkIn, LocalDateTime checkOut,
                             List<Integer> quantities, List<String> specialRequests, String initialStatus) {

        System.out.println(">>> [BookingService] createBooking STARTING...");

        // Validate input
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
        double baseTotalPrice = 0;

        for (int i = 0; i < roomIds.size(); i++) {
            Integer roomId = roomIds.get(i);
            Integer quantity = quantities.get(i);

            try {
                if (!isRoomAvailable(roomId, checkIn, checkOut)) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " is NOT available !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: isRoomAvailable() returned false for RoomID {0}", roomId);
                    return -1;
                }

                Room room = roomDao.getById(roomId);
                if (room == null) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " is NULL in DB !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: roomDao.getById() returned null for RoomID {0}", roomId);
                    return -1;
                }

                if (!"available".equalsIgnoreCase(room.getStatus())) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " status is " + room.getStatus() + " !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: Room {0} status is ''{1}'', not ''available''.", new Object[]{roomId, room.getStatus()});
                    return -1;
                }

                if (quantity <= 0 || quantity > room.getCapacity()) {
                    System.out.println("!!! BOOKING SERVICE LỖI: Room " + roomId + " capacity exceeded (Qty: " + quantity + ", Cap: " + room.getCapacity() + ") !!!");
                    LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: Guest count {0} exceeds capacity {1} for RoomID {2}", new Object[]{quantity, room.getCapacity(), roomId});
                    return -1;
                }

                selectedRooms.add(room);
                baseTotalPrice += room.getPrice();

            } catch (Exception e) {
                System.out.println("!!!!!!!!!!!!!! EXCEPTION caught in BookingService loop !!!!!!!!!!!!!!");
                e.printStackTrace();
                LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: Exception during availability check for RoomID " + roomId, e);
                return -1;
            }
        }

        System.out.println(">>> [BookingService] All rooms are available. Proceeding to DAO insert...");

        // Calculate Duration and Final Price
        Duration duration = Duration.between(checkIn, checkOut);
        double durationHours = duration.toMinutes() / 60.0;

        long durationNights = Duration.between(checkIn.toLocalDate().atStartOfDay(), checkOut.toLocalDate().atStartOfDay()).toDays();
        if (durationNights <= 0) {
            durationNights = 1;
            LOGGER.log(Level.INFO, "Booking duration is less than a day, calculating price for 1 night.");
        }

        double finalTotalPrice = baseTotalPrice * durationNights;

        // Create Booking object
        Booking newBooking = new Booking();
        newBooking.setUserId(userId);
        newBooking.setCheckinTime(checkIn);
        newBooking.setCheckoutTime(checkOut);
        // NOTE: durationHours is calculated but not saved to DB (column doesn't exist)
        // If needed in future, add migration: ALTER TABLE booking ADD COLUMN duration_hours DECIMAL(10,2);
        // newBooking.setDurationHours(durationHours);
        newBooking.setStatus(initialStatus);
        newBooking.setTotalPrice(finalTotalPrice);

        // Create list of BookingDetail objects
        List<BookingDetail> bookingDetails = new ArrayList<>();
        for (int i = 0; i < selectedRooms.size(); i++) {
            Room room = selectedRooms.get(i);
            Integer quantity = quantities.get(i);
            String specialRequest = (specialRequests != null && i < specialRequests.size()) ? specialRequests.get(i) : null;

            BookingDetail detail = new BookingDetail(
                    room.getRoomId(),
                    room.getPrice(),
                    quantity,
                    null,
                    null
            );
            detail.setSpecialRequest(specialRequest);
            bookingDetails.add(detail);
        }

        // Call BookingDao
        System.out.println(">>> [BookingService] Calling bookingDao.insertBookingWithDetails...");
        boolean success = bookingDao.insertBookingWithDetails(newBooking, bookingDetails);

        if (success) {
            System.out.println(">>> [BookingService] bookingDao.insertBookingWithDetails SUCCEEDED. Returning Booking ID: " + newBooking.getBookingId());
            LOGGER.log(Level.INFO, "New booking created successfully with ID: {0} for user {1}.",
                    new Object[]{newBooking.getBookingId(), userId});
            return newBooking.getBookingId();
        } else {
            System.out.println("!!! BOOKING SERVICE LỖI: bookingDao.insertBookingWithDetails() returned false !!!");
            LOGGER.log(Level.SEVERE, ">>> CREATE_BOOKING_FAILED: bookingDao.insertBookingWithDetails() returned false for user {0}.", userId);
            return -1;
        }
    }

    /**
     * Overload method (không có quantities/special requests)
     */
    public int createBooking(int userId, List<Integer> roomIds, LocalDateTime checkIn,
                             LocalDateTime checkOut, String initialStatus) {
        List<Integer> defaultQuantities = new ArrayList<>();
        for (int i = 0; i < roomIds.size(); i++) {
            defaultQuantities.add(1);
        }
        return createBooking(userId, roomIds, checkIn, checkOut, defaultQuantities, null, initialStatus);
    }

    // ============ COMMON BOOKING STATUS METHODS ============

    /**
     * Cập nhật trạng thái booking
     */
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        if (newStatus == null || !List.of("pending", "confirmed", "cancelled", "completed").contains(newStatus.toLowerCase())) {
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

    /**
     * Hủy booking
     */
    public boolean cancelBooking(int bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking != null && ("completed".equalsIgnoreCase(booking.getStatus()))) {
            LOGGER.log(Level.WARNING, "Booking {0} cannot be cancelled because it is already {1}.",
                    new Object[]{bookingId, booking.getStatus()});
            return false;
        }
        return updateBookingStatus(bookingId, "cancelled");
    }

    /**
     * Xác nhận booking
     */
    public boolean confirmBooking(int bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking != null && !"pending".equalsIgnoreCase(booking.getStatus())) {
            LOGGER.log(Level.WARNING, "Booking {0} cannot be confirmed because its status is {1}.",
                    new Object[]{bookingId, booking.getStatus()});
        }
        return updateBookingStatus(bookingId, "confirmed");
    }

    /**
     * Hoàn thành booking
     */
    public boolean completeBooking(int bookingId) {
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

    // ============ READ/QUERY METHODS ============

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

    /**
     * Lấy booking details cho customer view (BookingDetail list)
     */
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

    // ============ AVAILABILITY CHECKING METHODS ============

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

    public boolean isRoomAvailable(int roomId, LocalDateTime checkIn, LocalDateTime checkOut) {
        if (checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            LOGGER.log(Level.WARNING, "Invalid date range for isRoomAvailable check: RoomID={0}, CheckIn={1}, CheckOut={2}",
                    new Object[]{roomId, checkIn, checkOut});
            return false;
        }

        try {
            Room room = roomDao.getById(roomId);
            if (room == null) {
                LOGGER.log(Level.WARNING, "isRoomAvailable check failed: Room {0} not found.", roomId);
                return false;
            }
            if (!"available".equalsIgnoreCase(room.getStatus())) {
                LOGGER.log(Level.INFO, "isRoomAvailable check: Room {0} is not available (status: {1}).",
                        new Object[]{roomId, room.getStatus()});
                return false;
            }

            boolean isOverlapping = bookingDao.isRoomBookedDuringDates(roomId, checkIn, checkOut);
            LOGGER.log(Level.INFO, "isRoomAvailable check for Room {0} between {1} and {2}: Overlapping booking found = {3}",
                    new Object[]{roomId, checkIn, checkOut, isOverlapping});

            return !isOverlapping;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking room availability for roomId: " + roomId, e);
            e.printStackTrace();
            return false;
        }
    }

    // ============ OTHER UTILITY METHODS ============

    public List<Booking> getUpcomingBookings() {
        try {
            return bookingDao.getUpcomingBookings();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving upcoming bookings.", e);
            e.printStackTrace();
            return new ArrayList<>();
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
}