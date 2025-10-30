package Controller.Auth;

import Dao.UsersDao;
import Models.Users;
import Utils.PasswordUtil; // Đảm bảo bạn có file này
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "LoginController", urlPatterns = {"/login"}) // Đổi tên class
public class LoginController extends HttpServlet { // Đổi tên class

    private static final Logger LOGGER = Logger.getLogger(LoginController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        HttpSession session = request.getSession(); // Lấy session ngay từ đầu

        try {
            if (phone == null || phone.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Please fill both of your phone number and password!");
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            UsersDao usersDao = new UsersDao();
            Users u = usersDao.getByMobilePhone(phone.trim()); // Trim phone

            if (u == null) {
                request.setAttribute("error", "Phone number does not exist!");
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            if (u.getPassword() == null) {
                 request.setAttribute("error", "Wrong password!");
                 request.setAttribute("phone", phone);
                 request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                 return;
            }
            
            boolean passwordMatch = false;
            if (u.getPassword().startsWith("$2a$")) {
                passwordMatch = PasswordUtil.verifyPassword(password, u.getPassword());
            } else {
                passwordMatch = password.equals(u.getPassword());
            }

            if (!passwordMatch) {
                request.setAttribute("error", "Wrong password!");
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            LOGGER.log(Level.INFO, "User {0} (ID: {1}) logged in successfully.", new Object[]{u.getMobilePhone(), u.getUserId()});
            
            session.setAttribute("user", u); 
            session.setAttribute("loggedInUser", u); 
            session.setAttribute("role", u.getRole());

            String redirectUrl = (String) session.getAttribute("redirectUrl");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                LOGGER.log(Level.INFO, "Redirecting user to saved URL: {0}", redirectUrl);
                session.removeAttribute("redirectUrl"); 
                response.sendRedirect(redirectUrl); 
                return;
            }

            String role = (u.getRole() != null) ? u.getRole().trim() : "";

            if ("Receptionist".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role)) { 
                LOGGER.log(Level.INFO, "Redirecting Admin/Receptionist to dashboard.");
                response.sendRedirect(request.getContextPath() + "/pages/Receptionist/booking-list.jsp"); 
            } else {
                LOGGER.log(Level.INFO, "Redirecting Customer to home page.");
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during login process for phone: " + phone, e);
            e.printStackTrace(); 
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
        }
    }
}

