package Controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class LogoutController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LogoutController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);

            if (session != null) {
                String userName = "Guest";
                if (session.getAttribute("user") != null) {
                }
                
                session.invalidate();
                LOGGER.log(Level.INFO, "User " + userName + " logged out successfully.");
            } else {
                LOGGER.log(Level.INFO, "Logout request received, but no active session found.");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during logout process", e);
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }
}