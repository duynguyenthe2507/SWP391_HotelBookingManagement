package Controller.Receptionist;

import Models.Users;
import Dao.RuleDao;
import Models.Rule;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeParseException; // Thêm import
import java.util.List;

@WebServlet(name = "RuleController", urlPatterns = {"/rules", "/rules/save", "/rules/edit", "/rules/delete"})
public class RuleController extends HttpServlet {

    private final RuleDao ruleDao = new RuleDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        String contextPath = request.getContextPath();

        switch (action) {
            case "/rules":
                Users user = (Users) request.getSession().getAttribute("loggedInUser");
                request.setAttribute("rules", ruleDao.getAllRules());
                String search = request.getParameter("search");
                String statusParam = request.getParameter("status"); // Sẽ là "Active", "Inactive", hoặc "" (rỗng)

                // 2. Chuyển đổi status string ("Active") thành boolean (true) cho DAO
                // Sử dụng Boolean (object) để có thể chứa giá trị null (nghĩa là "All Statuses")
                Boolean statusValue = null;
                if ("Active".equalsIgnoreCase(statusParam)) {
                    statusValue = true;
                } else if ("Inactive".equalsIgnoreCase(statusParam)) {
                    statusValue = false;
                }

                // 3. Gọi DAO với các tham số lọc
                // *** QUAN TRỌNG: Bạn cần tạo phương thức 'findRules' trong RuleDao.java (xem bước 2) ***
                List<Rule> rules = ruleDao.findRules(search, statusValue);

                // 4. Gửi danh sách rules và các giá trị filter về lại JSP
                request.setAttribute("rules", rules);
                request.setAttribute("search", search);       // Để giữ giá trị trong ô search
                request.setAttribute("status", statusParam);  // Để giữ giá trị trong dropdown (dùng "Active" thay vì true)
                if (user != null && "receptionist".equalsIgnoreCase(user.getRole())) {
                    // Đã sửa ở file JSP, nên chuyển đến file JSP đã sửa
                    request.getRequestDispatcher("/pages/receptionist/rules-list.jsp").forward(request, response);
                } else {
                    // User chỉ xem
                    request.getRequestDispatcher("/pages/user/rules.jsp").forward(request, response);
                }
                break;

            case "/rules/edit":
                // Logic này không được dùng bởi rules-list.jsp mới, nhưng vẫn sửa cho đúng
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Rule rule = ruleDao.getRuleById(id);
                    request.setAttribute("rule", rule);
                    // Giả sử bạn có trang rules-edit.jsp
                    request.getRequestDispatcher("/pages/receptionist/rules-edit.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(contextPath + "/rules");
                }
                break;

            case "/rules/delete":
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    ruleDao.deleteRule(deleteId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.sendRedirect(contextPath + "/rules?success=true");
                break;
            default:
                response.sendRedirect(contextPath + "/rules");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("ruleId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String statusStr = request.getParameter("status"); // [cite: 93]
        String createdAtStr = request.getParameter("createdAt");
        String updatedAtStr = request.getParameter("updatedAt");

        boolean status = "Active".equalsIgnoreCase(statusStr); //

        try {
            LocalDateTime vnTime = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
            Rule rule;
            Timestamp createdAt = null;
            try {
                if (createdAtStr != null && !createdAtStr.trim().isEmpty()) {
                    createdAt = Timestamp.valueOf(createdAtStr.replace("T", " ") + ":00");
                }
            } catch (DateTimeParseException | IllegalArgumentException ex) {
                System.out.println("⚠️ Lỗi parse CreatedAt.");
            }
            Timestamp updatedAt = null;
            try {
                if (updatedAtStr != null && !updatedAtStr.trim().isEmpty()) {
                    updatedAt = Timestamp.valueOf(updatedAtStr.replace("T", " ") + ":00"); //
                }
            } catch (DateTimeParseException | IllegalArgumentException ex) {
                System.out.println("⚠️ Lỗi parse UpdatedAt.");
            }


            if (idStr == null || idStr.trim().isEmpty()) {
                // === TẠO MỚI ===
                rule = new Rule();
                rule.setTitle(title);
                rule.setDescription(description);
                rule.setStatus(status);
                if (createdAt == null) {
                    rule.setCreatedAt(Timestamp.valueOf(vnTime));
                } else {
                    rule.setCreatedAt(createdAt);
                }
                rule.setUpdatedAt(rule.getCreatedAt());

                ruleDao.insertRule(rule);

            } else {
                int id = Integer.parseInt(idStr);
                rule = ruleDao.getRuleById(id);
                if (rule == null) {
                    throw new Exception("Không tìm thấy Rule với ID: " + id);
                }
                rule.setTitle(title);
                rule.setDescription(description);
                rule.setStatus(status);
                if (createdAt != null) {
                    rule.setCreatedAt(createdAt);
                }
                if (updatedAt == null) {
                    rule.setUpdatedAt(Timestamp.valueOf(vnTime));
                } else {
                    rule.setUpdatedAt(updatedAt);
                }
                ruleDao.updateRule(rule);
            }
            response.sendRedirect(request.getContextPath() + "/rules?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lưu thất bại: " + e.getMessage());
            request.setAttribute("rules", ruleDao.getAllRules());
            request.getRequestDispatcher("/pages/receptionist/rules-list.jsp").forward(request, response);
        }
    }
}