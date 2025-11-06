package Controller.Admin;

import Dao.UsersDao;
import Models.Users;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
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
        // Fetch users đã filter và sort từ DAO
        List<Users> users = usersDao.getFilteredAndSorted(sortBy, order, roleFilter, statusFilter, firstNameFilter,
                lastNameFilter, searchKeyword);

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
