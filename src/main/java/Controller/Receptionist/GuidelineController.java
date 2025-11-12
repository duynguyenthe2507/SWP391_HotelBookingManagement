package Controller.Receptionist;
import Dao.GuidelineDao;
import Models.Guideline;
import Models.Users;
import Services.CloudinaryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.List;

@MultipartConfig
@WebServlet(name = "GuidelineController", urlPatterns = {
        "/guidelines",
        "/guidelines/save",
        "/guidelines/delete"
})
public class GuidelineController extends HttpServlet {
    private GuidelineDao guidelineDao;
    private CloudinaryService cloudinaryService;
    @Override
    public void init() {
        guidelineDao = new GuidelineDao();
        cloudinaryService = new CloudinaryService();
    }
    @Override
    public void destroy() {
        // Đóng kết nối CSDL khi servlet bị hủy
        if (guidelineDao != null) {
            guidelineDao.closeConnection();
        }
        super.destroy();
    }
    private boolean isReceptionist(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }

        try {
            Users user = (Users) session.getAttribute("loggedInUser");
            return "receptionist".equalsIgnoreCase(user.getRole());
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        String contextPath = request.getContextPath();

        switch (action) {
            case "/guidelines":
                HttpSession session = request.getSession();
                Users user = (Users) session.getAttribute("loggedInUser");

                // Logic phân chia vai trò
                if (user != null && "receptionist".equalsIgnoreCase(user.getRole())) {
                    // === BẮT ĐẦU PHẦN SỬA ĐỔI ===
                    // Receptionist: Tải trang quản lý VÀ xử lý filter

                    // 1. Lấy tham số filter từ JSP
                    String search = request.getParameter("search");
                    String statusParam = request.getParameter("status"); // Sẽ là "Active", "Inactive", hoặc ""
                    // 2. Chuyển đổi status string ("Active") thành boolean (true) cho DAO
                    Boolean statusValue = null;
                    if ("Active".equalsIgnoreCase(statusParam)) {
                        statusValue = true;
                    } else if ("Inactive".equalsIgnoreCase(statusParam)) {
                        statusValue = false;
                    }
                    // 3. Gọi DAO với các tham số lọc
                    List<Guideline> guidelines = guidelineDao.findGuidelines(search, statusValue);
                    // 4. Gửi danh sách và các giá trị filter về lại JSP
                    request.setAttribute("guidelines", guidelines);
                    request.setAttribute("search", search);       // Để giữ giá trị trong ô search
                    request.setAttribute("status", statusParam);  // Để giữ giá trị trong dropdown
                    request.getRequestDispatcher("/pages/receptionist/guidelines-edit.jsp").forward(request, response);
                    // === KẾT THÚC PHẦN SỬA ĐỔI ===

                } else {
                    // User/Guest: Tải trang xem công khai (chỉ lấy ACTIVE)
                    List<Guideline> activeGuidelines = guidelineDao.getAllActive();
                    request.setAttribute("guidelines", activeGuidelines);
                    request.getRequestDispatcher("/pages/user/guidelines.jsp").forward(request, response);
                }
                break;
            case "/guidelines/delete":
                if (!isReceptionist(request)) {
                    response.sendRedirect(contextPath + "/login");
                    return;
                }
                try {
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    guidelineDao.delete(deleteId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.sendRedirect(contextPath + "/guidelines?success=true");
                break;

            default:
                response.sendRedirect(contextPath + "/guidelines");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        // Chỉ xử lý /guidelines/save
        if (!"/guidelines/save".equals(action)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        if (!isReceptionist(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        HttpSession session = request.getSession();
        try {
            // 1. Lấy các tham số từ form
            String idStr = request.getParameter("guidelineId");
            String serviceIdStr = request.getParameter("serviceId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String statusStr = request.getParameter("status");
            String existingImageUrl = request.getParameter("existingImageUrl");
            // 2. Xử lý file upload
            Part filePart = request.getPart("image");
            String newImageUrl = cloudinaryService.uploadFile(filePart);
            // 3. Quyết định URL ảnh cuối cùng
            String finalImageUrl = existingImageUrl; // Mặc định là ảnh cũ
            if (newImageUrl != null) {
                // Nếu có ảnh mới được upload, dùng ảnh mới
                finalImageUrl = newImageUrl;
            }
            // 4. Tạo đối tượng Guideline
            Guideline g = new Guideline();
            g.setTitle(title);
            g.setContent(content);
            g.setStatus("Active".equals(statusStr));
            g.setImageUrl(finalImageUrl);
            // Xử lý serviceId (có thể là null)
            if (serviceIdStr != null && !serviceIdStr.trim().isEmpty()) {
                g.setServiceId(Integer.parseInt(serviceIdStr));
            } else {
                g.setServiceId(null);
            }
            // 5. Quyết định Thêm mới (Insert) hay Cập nhật (Update)
            if (idStr == null || idStr.trim().isEmpty()) {
                // === TẠO MỚI ===
                guidelineDao.insert(g);
            } else {
                // === CẬP NHẬT ===
                g.setGuidelineId(Integer.parseInt(idStr));
                guidelineDao.update(g);
            }
            response.sendRedirect(request.getContextPath() + "/guidelines?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lưu thất bại: " + e.getMessage());
            // Tải lại danh sách và chuyển về trang edit
            request.setAttribute("guidelines", guidelineDao.getAll());
            request.getRequestDispatcher("/guidelines-edit.jsp").forward(request, response);
        }
    }
}