package Controller.Auth;

import Dao.UsersDao;
import Models.Users;
import Utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

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

        // Kiểm tra dữ liệu đầu vào
        if (phone == null || phone.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill both of your phone number and password!");
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
            return;
        }

        UsersDao usersDao = new UsersDao();
        Users u = usersDao.getByMobilePhone(phone);

        if (u == null) {
            // Số điện thoại không tồn tại
            request.setAttribute("error", "Phone number does not exist!");
            request.setAttribute("phone", phone); // Giữ lại số điện thoại đã nhập
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
            return;
        } else if (u.getPassword() == null) {
            request.setAttribute("error", "Wrong password!");
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
            return;
        } else {
            // Check if password is hashed (starts with $2a$) or plain text
            boolean passwordMatch;
            if (u.getPassword().startsWith("$2a$")) {
                // Password is hashed, use BCrypt verification
                passwordMatch = PasswordUtil.verifyPassword(password, u.getPassword());
            } else {
                // Password is plain text, use direct comparison
                passwordMatch = password.equals(u.getPassword());
            }

            if (!passwordMatch) {
                request.setAttribute("error", "Wrong password!");
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            // Password is correct, proceed to login
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", u);
            session.setAttribute("role", u.getRole());
        }
        // Kiểm tra role và điều hướng
        String role = (u.getRole() != null) ? u.getRole().trim() : "";

        if ("receptionist".equalsIgnoreCase(role) || "receptionist123".equalsIgnoreCase(role)) {
            // Nếu là lễ tân → vào trang dashboard riêng
            response.sendRedirect(request.getContextPath() + "/pages/receptionist/receptionist-dashboard.jsp");
            return;
        } else {
            // User thường → vào home
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
    }
    @Override
    public String getServletInfo() {
        return "Login Servlet - Handles user authentication";
    }
}
