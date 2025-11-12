package Controller.User;

import Dao.FeedbackDao;
import Models.Feedback;
import Models.Users;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.stream.Collectors;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(name = "AddReviewController", urlPatterns = {"/user/add-review"})
public class AddReviewController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AddReviewController.class.getName());
    private FeedbackDao feedbackDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        this.feedbackDao = new FeedbackDao();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(java.time.LocalDateTime.class, 
                     new Utils.LocalDateTimeAdapter()) 
                .create();
    }
    
    private static class ReviewRequest {
        int bookingId;
        int rating;
        String content;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            out.print("{\"error\": \"Bạn phải đăng nhập để đánh giá.\"}");
            out.flush();
            return;
        }

        try {
            String jsonBody = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
            ReviewRequest reviewRequest = gson.fromJson(jsonBody, ReviewRequest.class);

            if (reviewRequest == null || reviewRequest.content == null || reviewRequest.content.trim().isEmpty() || reviewRequest.bookingId <= 0 || reviewRequest.rating < 1 || reviewRequest.rating > 5) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
                out.print("{\"error\": \"Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.\"}");
                out.flush();
                return;
            }

            Feedback newFeedback = new Feedback(
                user.getUserId(),
                reviewRequest.bookingId,
                reviewRequest.content,
                reviewRequest.rating
            );

            Feedback savedFeedback = feedbackDao.addReview(newFeedback);

            if (savedFeedback != null) {
                response.setStatus(HttpServletResponse.SC_OK); // 200
                out.print(gson.toJson(savedFeedback));
            } else {
                throw new Exception("Failed to save review to database.");
            }

        } catch (JsonSyntaxException e) {
            LOGGER.log(Level.WARNING, "Invalid JSON format received", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400
            out.print("{\"error\": \"Invalid request format.\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding review", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
            out.print("{\"error\": \"Lỗi máy chủ: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
    
}