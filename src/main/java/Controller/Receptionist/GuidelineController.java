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
        // Đóng kết nối DB
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

                // Phân quyền
                if (user != null && "receptionist".equalsIgnoreCase(user.getRole())) {
                    // Lễ tân: Quản lý & Lọc

                    // 1. Lấy tham số lọc
                    String search = request.getParameter("search");
                    String statusParam = request.getParameter("status");

                    // 2. Chuyển đổi status sang boolean
                    Boolean statusValue = null;
                    if ("Active".equalsIgnoreCase(statusParam)) {
                        statusValue = true;
                    } else if ("Inactive".equalsIgnoreCase(statusParam)) {
                        statusValue = false;
                    }

                    // 3. Gọi DAO tìm kiếm
                    List<Guideline> guidelines = guidelineDao.findGuidelines(search, statusValue);

                    // 4. Gửi dữ liệu về JSP
                    request.setAttribute("guidelines", guidelines);
                    request.setAttribute("search", search);
                    request.setAttribute("status", statusParam);
                    request.getRequestDispatcher("/pages/receptionist/guidelines-edit.jsp").forward(request, response);

                } else {
                    // Khách: Xem công khai (Chỉ Active)
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
        // Chỉ xử lý save
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
            // 1. Lấy tham số form
            String idStr = request.getParameter("guidelineId");
            String serviceIdStr = request.getParameter("serviceId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String statusStr = request.getParameter("status");
            String existingImageUrl = request.getParameter("existingImageUrl");

            // 2. Xử lý upload ảnh
            Part filePart = request.getPart("image");
            String newImageUrl = cloudinaryService.uploadFile(filePart);

            // 3. Chọn URL ảnh
            String finalImageUrl = existingImageUrl; // Mặc định ảnh cũ
            if (newImageUrl != null) {
                // Dùng ảnh mới nếu có upload
                finalImageUrl = newImageUrl;
            }

            // 4. Tạo Object
            Guideline g = new Guideline();
            g.setTitle(title);
            g.setContent(content);
            g.setStatus("Active".equals(statusStr));
            g.setImageUrl(finalImageUrl);

            // Xử lý serviceId
            if (serviceIdStr != null && !serviceIdStr.trim().isEmpty()) {
                g.setServiceId(Integer.parseInt(serviceIdStr));
            } else {
                g.setServiceId(null);
            }

            // 5. Insert hoặc Update
            if (idStr == null || idStr.trim().isEmpty()) {
                // Tạo mới
                guidelineDao.insert(g);
            } else {
                // Cập nhật
                g.setGuidelineId(Integer.parseInt(idStr));
                guidelineDao.update(g);
            }
            response.sendRedirect(request.getContextPath() + "/guidelines?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Save failed: " + e.getMessage());
            // Reload list và về trang edit
            request.setAttribute("guidelines", guidelineDao.getAll());
            request.getRequestDispatcher("/guidelines-edit.jsp").forward(request, response);
        }
    }
}