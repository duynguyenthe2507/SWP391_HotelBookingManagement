package Controller;

import Dao.CategoryDao;
import Dao.ServicesDao;
import Models.Category;
import Models.Services;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Khởi tạo CategoryDao
        CategoryDao categoryDao = new CategoryDao();
        // Gọi hàm để lấy danh sách loại phòng
        List<Category> categories = categoryDao.getAll();
        // Đặt list vào request attribute để JSP có thể truy cập
        request.setAttribute("categories", categories);

        // Lấy data services
        ServicesDao servicesDao = new ServicesDao();
        List<Services> services = servicesDao.getAll();
        request.setAttribute("services", services);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}