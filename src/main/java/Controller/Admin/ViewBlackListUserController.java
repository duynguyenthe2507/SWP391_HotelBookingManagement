package Controller.Admin;

import Dao.UsersDao;
import Models.Users;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "ViewBlackListUserController", urlPatterns = {"/admin/black-list"})
public class ViewBlackListUserController extends HttpServlet {

    private UsersDao usersDao = new UsersDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tự động blacklist user nếu có >= 3 lần no-show
        usersDao.autoBlacklistUsers();
        
        String sortParam = request.getParameter("sort");
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        if (sortParam != null && !sortParam.isEmpty()) {
            if ("id_asc".equalsIgnoreCase(sortParam)) {
                sortBy = "id";
                order = "asc";
            } else if ("id_desc".equalsIgnoreCase(sortParam)) {
                sortBy = "id";
                order = "desc";
            }
        }
        String roleFilter = request.getParameter("role");
        // Map "user" to "customer" if needed (for backward compatibility)
        if (roleFilter != null && roleFilter.equals("user")) {
            roleFilter = "customer";
        }
        String statusFilter = request.getParameter("status");
        String firstNameFilter = request.getParameter("firstName");
        String lastNameFilter = request.getParameter("lastName");
        String searchKeyword = request.getParameter("search");
        //code phân trang
        int page = 1;
        int pageSize = 10;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalUsers = usersDao.countBlacklistedUsers(roleFilter, statusFilter, firstNameFilter, lastNameFilter, searchKeyword);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        List<Users> users = usersDao.getBlacklistedFilteredAndSorted(sortBy, order, roleFilter, statusFilter, firstNameFilter, lastNameFilter, searchKeyword, page, pageSize);
        List<String> distinctRoles = usersDao.getDistinctRoles();
        List<String> distinctStatuses = usersDao.getDistinctStatuses();
        List<String> distinctFirstNames = usersDao.getDistinctLastNames();
        List<String> distinctLastNames = usersDao.getDistinctLastNames();
        request.setAttribute("users", users);
        request.setAttribute("distinctRoles", distinctRoles);
        request.setAttribute("distinctStatuses", distinctStatuses);
        request.setAttribute("distinctFirstNames", distinctFirstNames);
        request.setAttribute("distinctLastNames", distinctLastNames);
        request.setAttribute("currentSortBy", sortBy);
        request.setAttribute("currentOrder", order);
        request.setAttribute("currentSortParam", sortParam);
        request.setAttribute("currentRole", roleFilter);
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("currentFirstName", firstNameFilter);
        request.setAttribute("currentLastName", lastNameFilter);
        request.setAttribute("currentSearch", searchKeyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("pageSize", pageSize);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/black-list.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("ban".equals(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    boolean success = usersDao.delete(userId);
                    if (success) {
                        request.setAttribute("success", "User banned and deleted successfully");
                    } else {
                        request.setAttribute("error", "Failed to ban user");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid User ID");
                }
            } else {
                request.setAttribute("error", "User ID is required");
            }
        }
        doGet(request, response);  // Reload list after action
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
