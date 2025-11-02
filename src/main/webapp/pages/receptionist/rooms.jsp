<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--
  File "All-in-One" cho Quản lý Phòng
--%>

<style>
    /* THAY ĐỔI: Thêm container nền trắng, bo góc, đổ bóng */
    .room-content-card {
        background: #fff;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    .room-content-card h2 {
        color: #222;
        font-weight: 600;
        margin-top: 0;
    }

    /* THAY ĐỔI: Nút "Add" dùng màu xanh của sidebar */
    .btn-add {
        background-color: #336699; /* ĐỔI TỪ #dfa974 */
        color: #fff; border: none;
        padding: 10px 18px; border-radius: 6px; font-weight: 600;
        transition: all 0.3s ease;
    }
    .btn-add:hover { background-color: #2d5986; } /* ĐỔI TỪ #b67b4b */

    .side-panel {
        position: fixed;
        top: 0; right: -600px; width: 500px; height: 100%;
        background-color: #fff; box-shadow: -4px 0 10px rgba(0,0,0,0.15);
        z-index: 9999;
        transition: right 0.4s ease; overflow-y: auto;
    }
    .side-panel.active { right: 0; }

    /* THAY ĐỔI: Header của Panel dùng màu xanh */
    .panel-header {
        background-color: #336699; /* ĐỔI TỪ #dfa974 */
        color: white; padding: 20px;
        font-size: 18px; font-weight: 700; display: flex;
        justify-content: space-between; align-items: center;
    }
    .panel-body { padding: 25px; }
    .panel-body input, .panel-body textarea, .panel-body select {
        border-radius: 8px;
        border: 1px solid #ccc;
    }
    .panel-footer {
        display: flex;
        justify-content: space-between; padding: 20px 25px;
        border-top: 1px solid #eee; background-color: #f8f8f8;
    }
    .btn-cancel {
        background: #dc3545; color: white; border: none;
        border-radius: 6px; padding: 10px 20px;
    }
    .btn-save {
        background: #28a745;
        color: white; border: none;
        border-radius: 6px; padding: 10px 20px;
    }

    /* THAY ĐỔI: Tiêu đề Bảng dùng màu xanh */
    .table thead th {
        background-color: #336699; /* ĐỔI TỪ #dfa974 */
        color: white; text-align: center;
    }
    .table td { vertical-align: middle; }

    /* Link Edit (Giữ màu vàng làm điểm nhấn) */
    .action-link { color: #dfa974; cursor: pointer; font-weight: 600; }
    .action-link:hover { color: #b67b4b; }

    .room-thumbnail {
        width: 120px;
        height: 80px;
        object-fit: cover;
        border-radius: 6px;
        border: 1px solid #eee;
    }

    /* Giữ nguyên style cho các badge status */
    .badge-success { background-color: #28a745; color: white; }
    .badge-danger { background-color: #dc3545; color: white; }
    .badge-warning { background-color: #ffc107; color: #212529; }
</style>

<%-- THAY ĐỔI: Thêm container mt-5 mb-5 và div.room-content-card --%>
<div class="container-fluid mt-5 mb-5">
    <div class="room-content-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Room Receptionist</h2>
            <button class="btn-add" onclick="openPanel('add')"><i class="fa fa-plus"></i> Add New Room</button>
        </div>

        <%-- Các thông báo success/error --%>
        <c:if test="${not empty param.created}">
            <div class="alert alert-success">New room created successfully!</div>
        </c:if>
        <c:if test="${not empty param.updated}">
            <div class="alert alert-success">Room updated successfully!</div>
        </c:if>
        <c:if test="${not empty param.deleted}">
            <div class="alert alert-danger">Room deleted successfully!</div>
        </c:if>

        <div class="table-responsive">
            <table class="table table-bordered table-striped text-center">
                <thead> <%-- Đã bỏ class thead-dark để dùng màu custom --%>
                <tr>
                    <th>ID</th>
                    <th>Room Name</th>
                    <th>Room Type</th>
                    <th>Price (VND)</th>
                    <th>Capacity</th>
                    <th>Status</th>
                    <th>Image</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${rooms}">
                    <tr data-room-id="${r.roomId}"
                        data-name="${fn:escapeXml(r.name)}"
                        data-category-id="${r.categoryId}"
                        data-price="${r.price}"
                        data-capacity="${r.capacity}"
                        data-status="${r.status}"
                        data-img-url="${r.imgUrl}"
                        data-description="${fn:escapeXml(r.description)}">

                        <td>${r.roomId}</td>
                        <td>${r.name}</td>
                        <td>${r.category.name}</td>
                        <td><fmt:formatNumber value="${r.price}" pattern="#,##0"/></td>
                        <td>${r.capacity}</td>
                        <td>
                            <span class="badge ${r.status == 'available' ? 'badge-success' : (r.status == 'booked' ? 'badge-danger' : 'badge-warning')}">
                                    ${r.status}
                            </span>
                        </td>
                        <td>
                            <c:if test="${not empty r.imgUrl}">
                                <img src="${r.imgUrl}" alt="${r.name}" class="room-thumbnail">
                            </c:if>
                            <c:if test="${empty r.imgUrl}">
                                (No image)
                            </c:if>
                        </td>
                        <td>${r.description}</td>
                        <td>
                                <%-- Nút "Edit" dùng style .action-link --%>
                            <span class="action-link" onclick="openPanel('edit', this)">
                                <i class="fa fa-pencil"></i> Edit
                            </span>

                            <form action="${pageContext.request.contextPath}/receptionist/room/delete" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this room?');">
                                <input type="hidden" name="id" value="${r.roomId}">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- SLIDE PANEL (Đã đổi màu .panel-header) --%>
<div class="side-panel" id="sidePanel">
    <form method="post" id="roomForm" enctype="multipart/form-data">
        <div class="panel-header">
            <span id="panelTitle">Add New Room</span>
            <span style="cursor:pointer" onclick="closePanel()">&times;</span>
        </div>

        <div class="panel-body">
            <input type="hidden" id="roomId" name="roomId">
            <input type="hidden" id="currentImgUrl" name="currentImgUrl">

            <div class="mb-3">
                <label>Room Name</label>
                <input type="text" id="name" name="name" class="form-control" required maxlength="100">
            </div>

            <div class="mb-3">
                <label>Room Type</label>
                <select id="categoryId" name="categoryId" class="form-control" required>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.categoryId}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label>Price (VND)</label>
                <input type="number" id="price" name="price" step="1000" min="0" class="form-control" required>
            </div>

            <div class="mb-3">
                <label>Capacity</label>
                <input type="number" id="capacity" name="capacity" min="1" class="form-control" required>
            </div>

            <div class="mb-3">
                <label>Status</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="available">available</option>
                    <option value="booked">booked</option>
                    <option value="maintenance">maintenance</option>
                </select>
            </div>

            <div class="mb-3">
                <label>Description</label>
                <textarea id="description" name="description" rows="3" class="form-control"></textarea>
            </div>

            <div class="mb-3">
                <label>Room Image (optional)</label>
                <input type="file" name="image" accept="image/*" class="form-control">
                <div id="imgPreview" class="mt-2" style="display:none;">
                    <p>Current image:</p>
                    <img src="" alt="room" style="max-width:240px;border-radius:8px;"/>
                </div>
            </div>
        </div>

        <div class="panel-footer">
            <button type="button" class="btn-cancel" onclick="closePanel()">Cancel</button>
            <button type="submit" class="btn-save">Save Changes</button>
        </div>
    </form>
</div>

<script>
    // === KHỞI TẠO BIẾN ===
    const panel = document.getElementById("sidePanel");
    const form = document.getElementById("roomForm");
    const panelTitle = document.getElementById("panelTitle");
    const imgPreview = document.getElementById("imgPreview");
    const imgTag = imgPreview.querySelector('img');
    const f_roomId = document.getElementById('roomId');
    const f_currentImgUrl = document.getElementById('currentImgUrl');
    const f_name = document.getElementById('name');
    const f_categoryId = document.getElementById('categoryId');
    const f_price = document.getElementById('price');
    const f_capacity = document.getElementById('capacity');
    const f_status = document.getElementById('status');
    const f_description = document.getElementById('description');

    // === HÀM MỞ/ĐÓNG PANEL ===
    function openPanel(mode, button) {
        form.querySelector('input[type=file]').value = ""; // Xóa file input cũ

        if (mode === 'add') {
            panelTitle.innerText = "Add New Room";
            form.action = "${pageContext.request.contextPath}/receptionist/room/new";

            // Xóa giá trị form
            f_roomId.value = "";
            f_currentImgUrl.value = "";
            f_name.value = "";
            f_categoryId.value = "${categories[0].categoryId}"; // Lấy loại đầu tiên
            f_price.value = "";
            f_capacity.value = "1";
            f_status.value = "available";
            f_description.value = "";
            imgPreview.style.display = 'none';

        } else if (mode === 'edit') {
            panelTitle.innerText = "Edit Room Information";
            form.action = "${pageContext.request.contextPath}/receptionist/room/edit";

            // Lấy data từ <tr>
            const row = button.closest('tr');
            const data = row.dataset;

            // Điền data vào form
            f_roomId.value = data.roomId;
            f_currentImgUrl.value = data.imgUrl;
            f_name.value = data.name;
            f_categoryId.value = data.categoryId;
            f_price.value = data.price;
            f_capacity.value = data.capacity;
            f_status.value = data.status;
            f_description.value = data.description;

            // Hiển thị ảnh (nếu có)
            if (data.imgUrl && data.imgUrl !== "null" && data.imgUrl !== "") {
                imgTag.src = data.imgUrl;
                imgPreview.style.display = 'block';
            } else {
                imgPreview.style.display = 'none';
            }
        }
        panel.classList.add("active");
    }

    function closePanel() {
        panel.classList.remove("active");
    }

    // === XỬ LÝ SUBMIT FORM BẰNG AJAX ===
    form.addEventListener('submit', function(e) {
        e.preventDefault(); // Ngăn submit truyền thống

        const formData = new FormData(form);
        const submitButton = form.querySelector('.btn-save');
        submitButton.disabled = true;
        submitButton.innerText = "Saving...";

        fetch(form.action, {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    closePanel();
                    const contentArea = document.querySelector(".content");
                    if (contentArea) {
                        // Tải lại trang rooms.jsp vào vùng .content
                        fetch('${pageContext.request.contextPath}/receptionist/rooms?' + data.action + '=true')
                            .then(res => res.text())
                            .then(html => {
                                contentArea.innerHTML = html;
                                // Chạy lại script (nếu cần)
                                contentArea.querySelectorAll("script").forEach(oldScript => {
                                    const newScript = document.createElement("script");
                                    Array.from(oldScript.attributes).forEach(attr => newScript.setAttribute(attr.name, attr.value));
                                    newScript.innerHTML = oldScript.innerHTML;
                                    document.head.appendChild(newScript);
                                    oldScript.parentNode.removeChild(oldScript);
                                });
                            });
                    } else {
                        // Dự phòng: Tải lại toàn bộ trang
                        window.location.href = '${pageContext.request.contextPath}/rules?' + data.action + '=true';
                    }

                } else {
                    alert('An error occurred while saving the room. Please try again.');
                    submitButton.disabled = false;
                    submitButton.innerText = "Save Changes";
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Connection error. Please check the console.');
                submitButton.disabled = false;
                submitButton.innerText = "Save Changes";
            });
    });
</script>