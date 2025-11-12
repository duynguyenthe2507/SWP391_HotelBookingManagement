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

@WebServlet(name = "ViewUserController", urlPatterns = "/viewuser")
public class ViewUserController extends HttpServlet {

    private UsersDao usersDao = new UsersDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sortParam = request.getParameter("sort"); // expected values: id_asc, id_desc
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
        String statusFilter = request.getParameter("status");
        String firstNameFilter = request.getParameter("firstName");
        String lastNameFilter = request.getParameter("lastName");
        String searchKeyword = request.getParameter("search");
        // code phân trang
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

        int totalUsers = usersDao.countAllUsers(roleFilter, statusFilter, firstNameFilter, lastNameFilter,
                searchKeyword);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        // Fetch users đã filter và sort từ DAO với pagination
        List<Users> users = usersDao.getFilteredAndSorted(sortBy, order, roleFilter, statusFilter, firstNameFilter,
                lastNameFilter, searchKeyword, page, pageSize);

        // Fetch distinct values cho drop-down
        List<String> distinctRoles = usersDao.getDistinctRoles();
        List<String> distinctStatuses = usersDao.getDistinctStatuses();
        List<String> distinctFirstNames = usersDao.getDistinctFirstNames();
        List<String> distinctLastNames = usersDao.getDistinctLastNames();

        // Set attributes cho JSP (dữ liệu và current values để giữ selected trong
        // drop-down)
        request.setAttribute("users", users);
        request.setAttribute("distinctRoles", distinctRoles);
        request.setAttribute("distinctStatuses", distinctStatuses);
        request.setAttribute("distinctFirstNames", distinctFirstNames);
        request.setAttribute("distinctLastNames", distinctLastNames);
        request.setAttribute("currentSortBy", sortBy);
        request.setAttribute("currentOrder", order);
        request.setAttribute("currentRole", roleFilter);
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("currentFirstName", firstNameFilter);
        request.setAttribute("currentLastName", lastNameFilter);
        request.setAttribute("currentSearch", searchKeyword);
        // Set pagination attributes cho JSP
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("pageSize", pageSize);
        // Set currentSortParam để JSP có thể dùng
        String currentSortParam = null;
        if (sortBy != null && sortBy.equals("id")) {
            if (order != null && order.equalsIgnoreCase("desc")) {
                currentSortParam = "id_desc";
            } else {
                currentSortParam = "id_asc";
            }
        }
        request.setAttribute("currentSortParam", currentSortParam);
        // Forward đến JSP để render
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/user-list.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu có request POST (ví dụ từ form khác), gọi doGet để xử lý giống (an toàn
        // cho list view)
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
