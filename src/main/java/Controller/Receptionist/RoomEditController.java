package Controller.Receptionist;

import Controller.General.RoomsController;
import Dao.RoomDao;
import Models.Room;
import Models.Category;
import Services.CloudinaryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

// SỬA LỖI 1: Xung đột URL. Xóa "/rooms" khỏi đây vì nó đã được dùng bởi RoomsController.java
@WebServlet(urlPatterns = {
        "/receptionist/rooms",
        "/receptionist/room/new",
        "/receptionist/room/edit",
        "/receptionist/room/delete"
})
@MultipartConfig(maxFileSize = 15 * 1024 * 1024) // allow image upload
public class RoomEditController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RoomsController.class.getName());

    private RoomDao roomDao;
    private CloudinaryService cloudinary;

    @Override
    public void init() {
        roomDao = new RoomDao();
        cloudinary = new CloudinaryService();
    }

    private boolean isReceptionist(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object role = s.getAttribute("role");
        if (role == null) role = s.getAttribute("userRole");
        return role != null && "receptionist".equalsIgnoreCase(role.toString());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        final String uri = req.getRequestURI();

        // 1) List view cho /receptionist/rooms
        if (uri.endsWith("/receptionist/rooms")) { // CHỈ CÒN LẠI /receptionist/rooms
            // filters (shared)
            String search = req.getParameter("search");
            String categoryIdParam = req.getParameter("categoryId");
            String status = req.getParameter("status");
            Integer categoryId = null;
            try { if (categoryIdParam != null && !categoryIdParam.isBlank()) categoryId = Integer.parseInt(categoryIdParam); } catch (NumberFormatException ignored) {}

            // SỬA LỖI 2: Đây là dòng bạn chỉ ra.
            // Phương thức 'searchRooms' không tồn tại.
            // Chúng ta dùng 'findAllRooms' và điền null/mặc định cho các bộ lọc không dùng.
            List<Room> rooms = roomDao.findAllRooms(
                    search,       // searchKeyword
                    categoryId,   // categoryId
                    null,         // minPrice
                    null,         // maxPrice
                    null,         // minCapacity
                    null,         // checkInDate
                    null,         // checkOutDate
                    status,       // statusFilter
                    1,            // pageNumber (trang 1)
                    999           // pageSize (lấy 999 phòng, vì đây là trang admin)
            );

            // data
            List<Category> categories = roomDao.getAllCategories();

            // view flags
            boolean receptionist = isReceptionist(req);
            req.setAttribute("isReceptionist", receptionist);
            req.setAttribute("categories", categories);
            req.setAttribute("rooms", rooms);
            req.setAttribute("search", search);
            req.setAttribute("categoryId", categoryId);
            req.setAttribute("status", status);

            // Use ONE JSP for both roles (Receptionist/General)
            req.getRequestDispatcher("/pages/receptionist/rooms.jsp").forward(req, resp);
            return;
        }

        // 2) Edit/New forms (GET fill data)
        if (uri.endsWith("/receptionist/room/new") || uri.endsWith("/receptionist/room/edit")) {
            if (!isReceptionist(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
            List<Category> categories = roomDao.getAllCategories();
            req.setAttribute("categories", categories);
            if (uri.endsWith("/edit")) {
                String id = req.getParameter("roomId"); // JSP gửi 'roomId'
                if (id == null) { resp.sendRedirect(req.getContextPath()+"/receptionist/rooms"); return; }

                // SỬA LỖI 3: Đổi tên hàm từ getRoomById -> getById
                Room r = roomDao.getById(Integer.parseInt(id));

                req.setAttribute("room", r);
            }
            req.setAttribute("isReceptionist", true);
            req.getRequestDispatcher("/pages/receptionist/rooms.jsp").forward(req, resp); // slide-in form inside same JSP
            return;
        }

        // 3) Delete
        if (uri.endsWith("/receptionist/room/delete")) {
            if (!isReceptionist(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

            String id = req.getParameter("id");

            if (id != null) {
                try {
                    // SỬA LỖI 5: Đổi tên hàm từ deleteRoom -> delete
                    roomDao.delete(Integer.parseInt(id));
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Delete room error", e);
                }
            }
            resp.sendRedirect(req.getContextPath()+"/common/SideBar.jsp");
            return;
        }

        // Nếu không phải các URL trên, chuyển hướng về trang /rooms (public)
        resp.sendRedirect(req.getContextPath() + "/rooms");
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        final String uri = req.getRequestURI();
        if (!(uri.endsWith("/receptionist/room/new") || uri.endsWith("/receptionist/room/edit"))) {
            doGet(req, resp); return;
        }
        if (!isReceptionist(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        // collect fields
        String roomId = req.getParameter("roomId");
        String name = req.getParameter("name");
        int categoryId = Integer.parseInt(req.getParameter("categoryId"));
        double price = Double.parseDouble(req.getParameter("price"));
        int capacity = Integer.parseInt(req.getParameter("capacity"));
        String status = req.getParameter("status");
        String description = req.getParameter("description");

        Room r = new Room();
        if (roomId != null && !roomId.isBlank()) r.setRoomId(Integer.parseInt(roomId));
        r.setName(name);
        r.setCategoryId(categoryId);
        r.setPrice(price);
        r.setCapacity(capacity);
        r.setStatus(status);
        r.setDescription(description);

        // image upload (optional)
        Part imagePart = null;
        try { imagePart = req.getPart("image"); } catch (Exception ignored) {}

        // SỬA LỖI 6: CloudinaryService.java nhận vào 'Part', không phải 'InputStream'
        if (imagePart != null && imagePart.getSize() > 0) {
            String url = cloudinary.uploadFile(imagePart);
            r.setImgUrl(url);
        } else {
            String currentImg = req.getParameter("currentImgUrl");
            if (currentImg != null && !currentImg.isBlank()) r.setImgUrl(currentImg);
        }

        boolean ok;
        String actionType = "unknown";
        if (uri.endsWith("/new")) {
            ok = roomDao.createRoom(r) > 0;
            actionType = "created";
        } else {
            ok = roomDao.updateWithImage(r);
            actionType = "updated";
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(String.format("{\"success\": %b, \"action\": \"%s\"}", ok, actionType));
    }
}