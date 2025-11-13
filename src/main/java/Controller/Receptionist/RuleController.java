package Controller.Receptionist;

import Dao.RuleDao;
import Models.Rule;
import Models.Users;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
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
                String statusParam = request.getParameter("status");

                // Chuyển đổi trạng thái lọc
                Boolean statusValue = null;
                if ("Active".equalsIgnoreCase(statusParam)) {
                    statusValue = true;
                } else if ("Inactive".equalsIgnoreCase(statusParam)) {
                    statusValue = false;
                }

                // Gọi DAO tìm kiếm
                List<Rule> rules = ruleDao.findRules(search, statusValue);

                // Gửi dữ liệu về JSP
                request.setAttribute("rules", rules);
                request.setAttribute("search", search);
                request.setAttribute("status", statusParam);
                if (user != null && "receptionist".equalsIgnoreCase(user.getRole())) {
                    // View cho lễ tân
                    request.getRequestDispatcher("/pages/receptionist/rules-list.jsp").forward(request, response);
                } else {
                    // View cho khách hàng
                    request.getRequestDispatcher("/pages/user/rules.jsp").forward(request, response);
                }
                break;

            case "/rules/edit":
                // Xử lý chỉnh sửa (dự phòng)
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Rule rule = ruleDao.getRuleById(id);
                    request.setAttribute("rule", rule);
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
        String statusStr = request.getParameter("status");
        String createdAtStr = request.getParameter("createdAt");
        String updatedAtStr = request.getParameter("updatedAt");

        boolean status = "Active".equalsIgnoreCase(statusStr);

        try {
            LocalDateTime vnTime = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
            Rule rule;
            Timestamp createdAt = null;
            try {
                if (createdAtStr != null && !createdAtStr.trim().isEmpty()) {
                    createdAt = Timestamp.valueOf(createdAtStr.replace("T", " ") + ":00");
                }
            } catch (DateTimeParseException | IllegalArgumentException ex) {
                System.out.println("⚠️ Error parsing CreatedAt."); //
            }
            Timestamp updatedAt = null;
            try {
                if (updatedAtStr != null && !updatedAtStr.trim().isEmpty()) {
                    updatedAt = Timestamp.valueOf(updatedAtStr.replace("T", " ") + ":00");
                }
            } catch (DateTimeParseException | IllegalArgumentException ex) {
                System.out.println("⚠️ Error parsing UpdatedAt."); //
            }


            if (idStr == null || idStr.trim().isEmpty()) {
                // Tạo mới Rule
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
                // Cập nhật Rule
                int id = Integer.parseInt(idStr);
                rule = ruleDao.getRuleById(id);
                if (rule == null) {
                    throw new Exception("Rule not found with ID: " + id); //
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
            request.setAttribute("error", "Save failed: " + e.getMessage()); //
            request.setAttribute("rules", ruleDao.getAllRules());
            request.getRequestDispatcher("/pages/receptionist/rules-list.jsp").forward(request, response);
        }
    }
}