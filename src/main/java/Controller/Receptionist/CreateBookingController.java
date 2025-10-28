package Controller.Receptionist;

import Dao.RoomDao;
import Dao.ServicesDao;
import Models.Booking;
import Models.Room;
import Models.Services;
import Models.Users;
import Services.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/receptionist/create-booking")
public class CreateBookingController extends HttpServlet {

    private RoomDao roomDao = new RoomDao();
    private ServicesDao servicesDao = new ServicesDao();
    private BookingService bookingService = new BookingService();

    // Hiển thị form tạo booking
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách phòng trống
        List<Room> availableRooms = roomDao.getAvailableRooms();

        // Lấy tất cả dịch vụ
        List<Services> allServices = servicesDao.getAll();

        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("allServices", allServices);

        // Set data cho breadcrumb
        request.setAttribute("pageTitle", "Create Booking");
        request.setAttribute("currentPage", "Create Booking");

        request.getRequestDispatcher("/pages/receptionist/createBooking.jsp").forward(request, response);
    }

    // Xử lý khi nhấn nút Submit
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users receptionist = (Users) session.getAttribute("loggedInUser");

        try {
            // 1. Lấy tất cả dữ liệu từ form
            String guestName = request.getParameter("guestName");
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            LocalDateTime checkInDate = LocalDateTime.parse(request.getParameter("checkInDate"));
            LocalDateTime checkOutDate = LocalDateTime.parse(request.getParameter("checkOutDate"));
            int guestCount = Integer.parseInt(request.getParameter("guestCount"));
            String specialRequest = request.getParameter("specialRequest");
            double priceAtBooking = Double.parseDouble(request.getParameter("priceAtBooking"));

            // Lấy danh sách các checkbox dịch vụ đã được chọn
            String[] serviceIds = request.getParameterValues("serviceIds");

            // 2. Tạo đối tượng Booking
            Booking booking = new Booking();
            booking.setGuestName(guestName);
            booking.setRoomId(roomId);
            booking.setCheckinTime(checkInDate);
            booking.setCheckoutTime(checkOutDate);
            booking.setGuestCount(guestCount);
            booking.setSpecialRequest(specialRequest);
            booking.setTotalPrice(priceAtBooking);
            booking.setReceptionistId(receptionist.getUserId()); // Gán ID lễ tân

            // 3. Gọi Service để xử lý nghiệp vụ
            boolean success = bookingService.createOfflineBooking(booking, serviceIds);

            // 4. Gửi thông báo về view
            if (success) {
                session.setAttribute("bookingMessage", "Booking created successfully!");
            } else {
                session.setAttribute("bookingMessage", "Failed to create booking.");
            }

            // Chuyển hướng về trang danh sách booking
            response.sendRedirect(request.getContextPath() + "/receptionist/booking-list");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("bookingMessage", "Error processing request: " + e.getMessage());
            // Nếu lỗi, trả về form
            response.sendRedirect(request.getContextPath() + "/receptionist/create-booking");
        }
    }
}