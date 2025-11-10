<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guideline Management - 36 Hotel</title>

    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flaticon.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nice-select.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/magnific-popup.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/slicknav.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist-bills.css" type="text/css">

    <style>
        .action-link.delete-btn { background: none; border: none; padding: 0; color: #dc3545; cursor: pointer; font-weight: 500; font-family: "Cabin", sans-serif; font-size: 14px; }
        .action-link.delete-btn:hover { color: #a71d2a; }
        .side-panel { position: fixed; top: 0; right: -600px; width: 500px; height: 100%; background-color: #fff; box-shadow: -4px 0 10px rgba(0,0,0,0.15); z-index: 9999; transition: right 0.4s ease; overflow-y: auto; display: flex; flex-direction: column; }
        .side-panel.active { right: 0; }
        .panel-header { background-color: #dfa974; color: white; padding: 20px 25px; font-size: 18px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; flex-shrink: 0; }
        .panel-close { cursor: pointer; font-size: 24px; font-weight: 700; }
        .panel-body { padding: 25px; flex-grow: 1; overflow-y: auto; }
        .panel-body .form-control { border-radius: 8px; border: 1px solid #ccc; }
        .panel-footer { display: flex; justify-content: space-between; padding: 20px 25px; border-top: 1px solid #eee; background-color: #f8f8f8; flex-shrink: 0; }
        .btn-cancel, .btn-save { border: none; border-radius: 6px; padding: 10px 20px; font-weight: 600; transition: all 0.3s ease; }
        .btn-cancel { background: #6c757d; color: white; }
        .btn-save { background: #28a745; color: white; }
        .status-badge.status-active { color: #ffffff; background: #28a745; }
        .status-badge.status-inactive { color: #ffffff; background: #6c757d; }
        .col-description { white-space: pre-line; text-align: left; font-size: 13px; max-width: 350px; overflow-wrap: break-word; line-height: 1.4; }

        /* Thêm style cho ảnh trong bảng và preview */
        .table-img { height: 48px; width: 72px; object-fit: cover; border-radius: 6px; }
        .thumb-preview { max-height: 160px; width: auto; border: 1px solid #eee; border-radius: 8px; margin-top: 8px; display: none; }
    </style>
</head>

<body>
<c:set var="pageActive" value="guidelines"/>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    <div class="dashboard-content">
        <div id="preloder">
            <div class="loader"></div>
        </div>
        <section class="main-content">
            <div class="container-fluid">

                <c:if test="${not empty param.success}">
                    <div class="alert alert-success"><i class="fa fa-check-circle"></i> Lưu thành công!</div>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger"><i class="fa fa-times-circle"></i> ${sessionScope.error}</div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <div class="action-buttons">
                    <button class="action-btn" onclick="openPanel('add')">
                        <i class="fa fa-plus"></i> Add New Guideline
                    </button>
                </div>

                <div class="bills-table">
                    <div class="table-header">
                        <h4><i class="fa fa-info-circle"></i> Guidelines List</h4>
                    </div>
                    <c:choose>
                        <c:when test="${not empty guidelines}">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Ảnh</th>
                                    <th>Tiêu đề</th>
                                    <th class="col-description">Nội dung (tóm tắt)</th>
                                    <th>Service ID</th>
                                    <th>Trạng thái</th>
                                    <th>Cập nhật</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="g" items="${guidelines}" varStatus="loop">
                                    <%-- Thêm data-* để JS có thể đọc --%>
                                    <tr data-guideline-id="${g.guidelineId}"
                                        data-title="${fn:escapeXml(g.title)}"
                                        data-content="${fn:escapeXml(g.content)}"
                                        data-service-id="${g.serviceId}"
                                        data-status="${g.status ? 'Active' : 'Inactive'}"
                                        data-image-url="${g.imageUrl}">

                                        <td><div class="bill-id">${loop.count}</div></td>
                                        <td>
                                            <c:if test="${not empty g.imageUrl}">
                                                <img src="${g.imageUrl}" class="table-img" alt="thumb"/>
                                            </c:if>
                                        </td>
                                        <td><div class="customer-name">${g.title}</div></td>
                                        <td class="col-description">${fn:escapeXml(g.content)}
                                        </td>
                                        <td>${g.serviceId != null ? g.serviceId : 'Chung'}</td>
                                        <td><span class="status-badge ${g.status ? 'status-active' : 'status-inactive'}">${g.status ? 'Active' : 'Inactive'}</span></td>
                                        <td><div class="bill-date"><fmt:formatDate value="${g.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></div></td>
                                        <td>
                                            <div class="action-links">
                                                    <%-- Nút Edit gọi JS --%>
                                                <span class="action-link edit" onclick="openPanel('edit', this)">
                                                    <i class="fa fa-edit"></i> Edit
                                                </span>

                                                    <%-- Form Delete (Giống hệt guidelines-edit.jsp) --%>
                                                <form action="${pageContext.request.contextPath}/guidelines/delete" method="get" style="display:inline;" onsubmit="return confirm('Xóa guideline này?');">
                                                    <input type="hidden" name="id" value="${g.guidelineId}">
                                                    <button type="submit" class="action-link delete-btn">
                                                        <i class="fa fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fa fa-info-circle"></i>
                                <h4>No Guidelines Found</h4>
                                <p>No guidelines have been created yet.</p>
                                <button class="action-btn" onclick="openPanel('add')">
                                    <i class="fa fa-plus"></i> Create First Guideline
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <div class="side-panel" id="sidePanel">
            <%-- QUAN TRỌNG: Thêm enctype để upload file --%>
            <form method="post" id="guidelineForm" action="${pageContext.request.contextPath}/guidelines/save" enctype="multipart/form-data">
                <div class="panel-header">
                    <span id="panelTitle">Add New Guideline</span>
                    <span class="panel-close" onclick="closePanel()">&times;</span>
                </div>
                <div class="panel-body">
                    <input type="hidden" id="guidelineId" name="guidelineId">

                    <div class="mb-3">
                        <label for="serviceId">Dịch vụ (tùy chọn)</label>
                        <input type="number" id="serviceId" name="serviceId" class="form-control" placeholder="Để trống nếu là guideline chung">
                    </div>

                    <div class="mb-3">
                        <label for="title">Tiêu đề</label>
                        <input type="text" id="title" name="title" class="form-control" required maxlength="255">
                    </div>

                    <div class="mb-3">
                        <label for="content">Nội dung</label>
                        <textarea id="content" name="content" rows="8" class="form-control" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="status">Trạng thái</label>
                        <%-- Dùng Select giống rules-list.jsp cho dễ dùng với JS --%>
                        <select id="status" name="status" class="form-control" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="image">Ảnh minh họa (tùy chọn)</label>
                        <input type="file" id="image" name="image" class="form-control" accept="image/*">

                        <%-- Input ẩn để giữ link ảnh cũ khi không upload ảnh mới --%>
                        <input type="hidden" id="existingImageUrl" name="existingImageUrl">

                        <%-- Hiển thị ảnh đang có (nếu sửa) --%>
                        <img id="imagePreview" src="" class="thumb-preview" alt="Preview"/>
                    </div>
                </div>
                <div class="panel-footer">
                    <button type="button" class="btn-cancel" onclick="closePanel()">Cancel</button>
                    <button type="submit" class="btn-save">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
<script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    const panel = document.getElementById("sidePanel");
    const form = document.getElementById("guidelineForm");
    const panelTitle = document.getElementById("panelTitle");

    // Lấy các trường của form
    const f_guidelineId = document.getElementById('guidelineId');
    const f_title = document.getElementById('title');
    const f_content = document.getElementById('content');
    const f_status = document.getElementById('status');
    const f_serviceId = document.getElementById('serviceId');

    // Các trường cho ảnh
    const f_image = document.getElementById('image');
    const f_existingImageUrl = document.getElementById('existingImageUrl');
    const f_imagePreview = document.getElementById('imagePreview');

    function openPanel(mode, button) {
        form.reset(); // Xóa sạch form

        if (mode === 'add') {
            panelTitle.innerText = "Add New Guideline";
            f_guidelineId.value = "";
            f_status.value = "Active"; // Mặc định là Active
            f_existingImageUrl.value = "";
            f_imagePreview.style.display = 'none'; // Ẩn preview

        } else if (mode === 'edit') {
            panelTitle.innerText = "Edit Guideline";

            const row = button.closest('tr');
            const data = row.dataset;

            // Điền dữ liệu text
            f_guidelineId.value = data.guidelineId;
            f_title.value = data.title;
            f_content.value = data.content;
            f_status.value = data.status; // 'Active' hoặc 'Inactive'
            f_serviceId.value = data.serviceId;

            // Xử lý hiển thị ảnh cũ
            f_existingImageUrl.value = data.imageUrl; // Giữ link ảnh cũ
            if (data.imageUrl) {
                f_imagePreview.src = data.imageUrl;
                f_imagePreview.style.display = 'block'; // Hiển thị ảnh
            } else {
                f_imagePreview.style.display = 'none'; // Ẩn nếu không có ảnh
            }
        }

        f_image.value = null; // Luôn reset ô input file
        panel.classList.add("active");
    }

    function closePanel() {
        panel.classList.remove("active");
    }
</script>
</body>
</html>