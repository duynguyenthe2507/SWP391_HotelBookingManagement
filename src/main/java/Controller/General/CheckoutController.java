package Controller.General;

import Dao.ServicesDao;
import Models.Services;

import Models.BookingDetail;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList; 
import java.util.List;
import java.util.Map; 
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CheckoutController.class.getName());
    private static final DateTimeFormatter DISPLAY_FORMATTER = DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy");
    
   
    private ServicesDao servicesDao;

    @Override
    public void init() throws ServletException {
        this.servicesDao = new ServicesDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); 

        Users loggedInUser = null;
        if (session != null) {
            loggedInUser = (Users) session.getAttribute("user");
        }

        if (loggedInUser == null) {
            LOGGER.log(Level.INFO, "User not logged in. Redirecting to login page.");
            if (session == null) {
                 session = request.getSession(); 
            }
            session.setAttribute("redirectUrl", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<BookingDetail> cart = (session != null) ? (List<BookingDetail>) session.getAttribute("cart") : null;
        LocalDateTime cartCheckIn = (session != null) ? (LocalDateTime) session.getAttribute("cartCheckIn") : null;
        LocalDateTime cartCheckOut = (session != null) ? (LocalDateTime) session.getAttribute("cartCheckOut") : null;
        List<String> cartServiceIds = (session != null) ? (List<String>) session.getAttribute("cartServiceIds") : null;

        if (cart == null || cart.isEmpty() || cartCheckIn == null || cartCheckOut == null) {
            LOGGER.log(Level.WARNING, "Cart is empty or date information is missing for user {0}. Redirecting to rooms page.", loggedInUser.getUserId());
            session.setAttribute("cartMessage", "Your booking session is empty or expired. Please select a room again.");
            session.setAttribute("cartMessageType", "WARNING");
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }
        double totalRoomPrice = 0;
        double totalServicesPrice = 0;
        long numberOfNights = 0;
        
        try {
            numberOfNights = Duration.between(cartCheckIn.toLocalDate().atStartOfDay(), cartCheckOut.toLocalDate().atStartOfDay()).toDays();
            if (numberOfNights <= 0) {
                 numberOfNights = 1;
                 LOGGER.log(Level.INFO, "Calculated duration is less than or equal to 0 days, defaulting to 1 night.");
            }
            for (BookingDetail item : cart) {
                totalRoomPrice += item.getPriceAtBooking() * numberOfNights;
            }
            Map<Integer, Services> servicesMap = servicesDao.getAllServicesAsMap();
            List<Services> selectedServicesList = new ArrayList<>(); // Dùng để hiển thị
            
            if (cartServiceIds != null && !cartServiceIds.isEmpty() && servicesMap != null) {
                LOGGER.log(Level.INFO, "[Checkout] Calculating total price for {0} services.", cartServiceIds.size());
                for (String serviceIdStr : cartServiceIds) {
                    try {
                        int serviceId = Integer.parseInt(serviceIdStr);
                        if (servicesMap.containsKey(serviceId)) {
                            Services service = servicesMap.get(serviceId);
                            totalServicesPrice += service.getPrice();
                            selectedServicesList.add(service); // Thêm vào list để hiển thị
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid service ID format in session: {0}", serviceIdStr);
                    }
                }
            }
            double finalTotalPrice = totalRoomPrice + totalServicesPrice;
            
            LOGGER.log(Level.INFO, "[Checkout] Calculated total: Room ({0}) + Services ({1}) = {2} for {3} night(s).",
                         new Object[]{totalRoomPrice, totalServicesPrice, finalTotalPrice, numberOfNights});
            request.setAttribute("cart", cart);
            request.setAttribute("cartCheckInFormatted", cartCheckIn.format(DISPLAY_FORMATTER));
            request.setAttribute("cartCheckOutFormatted", cartCheckOut.format(DISPLAY_FORMATTER));
            request.setAttribute("numberOfNights", numberOfNights);
            request.setAttribute("totalPrice", finalTotalPrice); 
            request.setAttribute("user", loggedInUser); 
            request.setAttribute("selectedServices", selectedServicesList); 

        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error calculating total price or duration for checkout.", e);
             session.setAttribute("cartMessage", "Error calculating booking details. Please try selecting the room again.");
             session.setAttribute("cartMessageType", "ERROR");
             response.sendRedirect(request.getContextPath() + "/rooms");
             return;
        }

        LOGGER.log(Level.INFO, "Forwarding user {0} to checkout page.", loggedInUser.getUserId());
        request.getRequestDispatcher("/pages/user/checkout.jsp").forward(request, response); // Đảm bảo đường dẫn JSP đúng
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.WARNING, "Received POST request on CheckoutController, redirecting to GET.");
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}