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
import Services.CloudinaryService; // Import CloudinaryService
import jakarta.servlet.annotation.MultipartConfig; // Import cho multipart
import jakarta.servlet.http.Part;

@WebServlet(name = "ProfileController", urlPatterns = { "/profile" })
// hỗ trợ upload file
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)

public class ProfileController extends HttpServlet {

    private CloudinaryService cloudinaryService;

    public void init() {
        cloudinaryService = new CloudinaryService();

    }

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

            // Handle uploading avatar
            Part avatarPart = request.getPart("avatar");
            String avatarUrl = loggedInUser.getAvatarUrl();
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String contentType = avatarPart.getContentType();
                if (!contentType.startsWith("image/")) {
                    request.setAttribute("error", "Just support image file!");
                    return;
                }
                avatarUrl = cloudinaryService.uploadFile(avatarPart);
                if (avatarUrl == null) {
                    request.setAttribute("error", "Failed to upload avatar!");
                    return;
                }
            }

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
            loggedInUser.setAvatarUrl(avatarUrl);

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
