package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OTPController", urlPatterns = {"/otp-confirm"})
public class OTPController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetOTP = (String) session.getAttribute("resetOTP");

        if (resetOTP == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("general/otp-confirm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetOTP = (String) session.getAttribute("resetOTP");
        String resetEmail = (String) session.getAttribute("resetEmail");

        if (resetOTP == null || resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String enteredOTP = request.getParameter("otp");

        if (enteredOTP == null || enteredOTP.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the OTP code!");
            request.getRequestDispatcher("general/otp-confirm.jsp").forward(request, response);
            return;
        }

        if (!enteredOTP.equals(resetOTP)) {
            request.setAttribute("error", "Invalid OTP code!");
            request.getRequestDispatcher("general/otp-confirm.jsp").forward(request, response);
            return;
        }

        // OTP is correct, redirect to reset password
        response.sendRedirect(request.getContextPath() + "/reset-password");
    }
}
