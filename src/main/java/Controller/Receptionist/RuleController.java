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

@WebServlet(name = "RuleController", urlPatterns = {"/rules", "/rules/save", "/rules/edit", "/rules/delete"})
public class RuleController extends HttpServlet {

    private final RuleDao ruleDao = new RuleDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/rules":
                Users user = (Users) request.getSession().getAttribute("loggedInUser");
                request.setAttribute("rules", ruleDao.getAllRules());

                if (user != null && "receptionist".equalsIgnoreCase(user.getRole())) {
                    // Receptionist có thể quản lý
                    request.getRequestDispatcher("/pages/receptionist/rules-list.jsp").forward(request, response);
                } else {
                    // User chỉ xem
                    request.getRequestDispatcher("/pages/user/rules.jsp").forward(request, response);
                }
                break;

            case "/rules/edit":
                // Lấy rule theo ID để hiển thị lên form edit
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Rule rule = ruleDao.getRuleById(id);
                    request.setAttribute("rule", rule);
                    request.getRequestDispatcher("/pages/receptionist/rules-edit.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/common/SideBar.jsp");
                }
                break;

            case "/rules/delete":
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    ruleDao.deleteRule(deleteId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/common/SideBar.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/common/SideBar.jsp");
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
        String updatedAtStr = request.getParameter("updatedAt");

        boolean status = "1".equals(statusStr) || "Active".equalsIgnoreCase(statusStr);

        try {
            // Lấy giờ Việt Nam hiện tại cho CreatedAt
            LocalDateTime vnTime = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
            Timestamp createdAt = Timestamp.valueOf(vnTime);

            if (idStr == null || idStr.trim().isEmpty()) {

                Rule newRule = new Rule();
                newRule.setTitle(title);
                newRule.setDescription(description);
                newRule.setStatus(status);
                newRule.setCreatedAt(createdAt);
                newRule.setUpdatedAt(null);

                ruleDao.insertRule(newRule);
            } else {

                int id = Integer.parseInt(idStr);
                Timestamp updatedAt = null;
                try {
                    if (updatedAtStr != null && !updatedAtStr.trim().isEmpty()) {
                        updatedAt = Timestamp.valueOf(updatedAtStr.replace("T", " ") + ":00");
                    }
                } catch (Exception ex) {
                    System.out.println("⚠️ Lỗi khi parse UpdatedAt, sẽ bỏ qua giá trị thủ công.");
                }

                Rule rule = new Rule();
                rule.setRuleId(id);
                rule.setTitle(title);
                rule.setDescription(description);
                rule.setStatus(status);
                rule.setUpdatedAt(updatedAt);

                ruleDao.updateRule(rule);
            }
            // Sau khi lưu thành công, chuyển sang trang SideBar.jsp
            response.sendRedirect(request.getContextPath() + "/common/SideBar.jsp");


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lưu thất bại: " + e.getMessage());
            request.setAttribute("rules", ruleDao.getAllRules());
            request.getRequestDispatcher("/pages/receptionist/rules-list.jsp").forward(request, response);
        }
    }

}
