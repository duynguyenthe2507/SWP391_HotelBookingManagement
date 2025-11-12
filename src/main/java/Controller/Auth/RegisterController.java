/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Auth;

import Dao.UsersDao;
import Models.Users;
import Utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.regex.Pattern;//import cái này để dùng pattern regex theo yêu cầu
@WebServlet("/register")
public class RegisterController extends HttpServlet {
    
    //tạo pattern regex để validate password
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,}$");
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String lastName = request.getParameter("lastName");
        String mobilePhone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String birthday = request.getParameter("dob");
        
        //validate cơ bản
        if (isBlank(firstName) || isBlank(lastName) || isBlank(mobilePhone) || isBlank(email) || isBlank(password)) {
            request.setAttribute("error", "Please fill all the fields above.");
            request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
            return;
        }
        //validate password ở backend
        if (!PASSWORD_PATTERN.matcher(password).matches()){
            request.setAttribute("error", "Password must contain at least 8 characters, including word and number!");
            request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
        }
        

        UsersDao usersDao = new UsersDao();
        if (usersDao.getByMobilePhone(mobilePhone) != null) {
            request.setAttribute("error", "Phone number existed!");
            request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
            return;
        }

        Users u = new Users();
        u.setFirstName(firstName);
        u.setMiddleName(middleName);
        u.setLastName(lastName);
        u.setMobilePhone(mobilePhone);
        u.setEmail(email);
        u.setPassword(PasswordUtil.hashPassword(password));
        u.setRole("customer");
        Integer defaultRankId = usersDao.getDefaultRankId();
        u.setRankId(defaultRankId);
        if (birthday != null && !birthday.isEmpty()) {
            u.setBirthday(LocalDate.parse(birthday));
        }

        boolean ok = usersDao.insert(u);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Sign up failed! Please try again.");
            request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
