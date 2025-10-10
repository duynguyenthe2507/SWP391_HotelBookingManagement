package Controller;

import DAL.UsersDao;
import Models.Users;
import Utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetEmail = (String) session.getAttribute("resetEmail");

        if (resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("general/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetEmail = (String) session.getAttribute("resetEmail");
        Integer resetUserId = (Integer) session.getAttribute("resetUserId");

        if (resetEmail == null || resetUserId == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both password fields!");
            request.getRequestDispatcher("general/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("general/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long!");
            request.getRequestDispatcher("general/reset-password.jsp").forward(request, response);
            return;
        }

        // Update password in database
        UsersDao udao = new UsersDao();
        Users user = udao.getById(resetUserId);

        if (user == null) {
            request.setAttribute("error", "User does not exist!");
            request.getRequestDispatcher("general/reset-password.jsp").forward(request, response);
            return;
        }

        // Hash the new password before saving
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        user.setPassword(hashedPassword);

        if (udao.update(user)) {
            // Clear session data
            session.removeAttribute("resetOTP");
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetUserId");

            request.setAttribute("success",
                    "Password reset successfully! You can now login with your new password.");
            request.getRequestDispatcher("general/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "An error occurred while resetting password. Please try again!");
            request.getRequestDispatcher("general/reset-password.jsp").forward(request, response);
        }
    }
}
