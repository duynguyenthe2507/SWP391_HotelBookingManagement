package Controller;

import Dao.UsersDao;
import Dao.RankDao;
import Models.Users;
import Models.Rank;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get rank name
        RankDao rankDao = new RankDao();
        Rank userRank = null;
        if (loggedInUser.getRankId() != null) {
            userRank = rankDao.getById(loggedInUser.getRankId());
        }

        request.setAttribute("user", loggedInUser);
        request.setAttribute("rankName", userRank != null ? userRank.getName() : "Unranked");
        request.getRequestDispatcher("/pages/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if ("update".equals(action)) {
            String firstName = request.getParameter("firstName");
            String middleName = request.getParameter("middleName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String dobString = request.getParameter("dob");

            // Basic validation
            if (firstName == null || firstName.trim().isEmpty()
                    || lastName == null || lastName.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || dobString == null || dobString.trim().isEmpty()) {
                request.setAttribute("error", "Please fill all the information fields!");
                request.setAttribute("user", loggedInUser);
                request.getRequestDispatcher("/pages/user/profile.jsp").forward(request, response);
                return;
            }

            LocalDate birthday = null;
            try {
                birthday = LocalDate.parse(dobString);
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Invalid birthdate!");
                request.setAttribute("user", loggedInUser);
                request.getRequestDispatcher("/pages/user/profile.jsp").forward(request, response);
                return;
            }

            UsersDao udao = new UsersDao();

            // Check if phone or email already exists (excluding current user)
            Users existingUserByPhone = udao.getByMobilePhone(phone);
            if (existingUserByPhone != null && existingUserByPhone.getUserId() != loggedInUser.getUserId()) {
                request.setAttribute("error", "Phone number existed!");
                request.setAttribute("user", loggedInUser);
                request.getRequestDispatcher("/pages/user/profile.jsp").forward(request, response);
                return;
            }

            // Update user information
            loggedInUser.setFirstName(firstName);
            loggedInUser.setMiddleName(middleName != null ? middleName : "");
            loggedInUser.setLastName(lastName);
            loggedInUser.setMobilePhone(phone);
            loggedInUser.setEmail(email);
            loggedInUser.setPassword(password);
            loggedInUser.setBirthday(birthday);

            if (udao.update(loggedInUser)) {
                session.setAttribute("loggedInUser", loggedInUser);
                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Updated failed! Please try again.");
            }
        }

        // Get rank name for display
        RankDao rankDao = new RankDao();
        Rank userRank = null;
        if (loggedInUser.getRankId() != null) {
            userRank = rankDao.getById(loggedInUser.getRankId());
        }

        request.setAttribute("user", loggedInUser);
        request.setAttribute("rankName", userRank != null ? userRank.getName() : "Unranked");
        request.getRequestDispatcher("/pages/user/profile.jsp").forward(request, response);
    }
}
