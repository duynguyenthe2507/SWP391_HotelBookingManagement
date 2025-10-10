package Controller;

import DAL.UsersDao;
import Models.Users;
import Services.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("general/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email!");
            request.getRequestDispatcher("general/forgot-password.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format!");
            request.getRequestDispatcher("general/forgot-password.jsp").forward(request, response);
            return;
        }

        // Check if user exists
        UsersDao udao = new UsersDao();
        Users user = udao.getByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email does not exist in the system!");
            request.getRequestDispatcher("general/forgot-password.jsp").forward(request, response);
            return;
        }

        // Generate OTP
        String otp = generateOTP();

        // Store OTP and user info in session
        HttpSession session = request.getSession();
        session.setAttribute("resetOTP", otp);
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetUserId", user.getUserId());

        // Send OTP via email
        try {
            EmailService emailService = new EmailService();
            boolean emailSent = emailService.sendOTPEmail(email, otp);

            if (emailSent) {
                request.setAttribute("success", "OTP code has been sent to your email!");
                response.sendRedirect(request.getContextPath() + "/otp-confirm");
            } else {
                request.setAttribute("error", "Unable to send email. Please try again later!");
                request.getRequestDispatcher("general/forgot-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again later!");
            request.getRequestDispatcher("general/forgot-password.jsp").forward(request, response);
        }
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // Generate 6-digit OTP
        return String.valueOf(otp);
    }
}
