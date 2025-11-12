package Controller.User;

import Services.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/subscribe")
public class SubscribeController extends HttpServlet {

    // Khởi tạo EmailService
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        this.emailService = new EmailService(); // Khởi tạo service
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        if (email != null && !email.isEmpty()) {

            // Controller chỉ cần gọi Service
            boolean success = emailService.sendSubscriptionEmail(email); //

            if (success) {
                session.setAttribute("subscribeMessage", "Thank you for subscribing!");
            } else {
                session.setAttribute("subscribeMessage", "Subscription failed. Please try again.");
            }
        } else {
            session.setAttribute("subscribeMessage", "Please enter a valid email address.");
        }

        // Redirect người dùng trở lại
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/home");
    }
}