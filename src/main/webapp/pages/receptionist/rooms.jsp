<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Sona Template">
    <meta name="keywords" content="Sona, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Room Management - 36 Hotel</title>

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
        .room-thumbnail {
            width: 100px;
            height: 65px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #eee;
        }
        .action-link.delete-btn {
            background: none;
            border: none;
            padding: 0;
            color: #dc3545;
            cursor: pointer;
            font-weight: 500;
            font-family: "Cabin", sans-serif;
            font-size: 14px;
        }
        .action-link.delete-btn:hover {
            color: #a71d2a;
        }
        .side-panel {
            position: fixed;
            top: 0;
            right: -600px;
            width: 500px;
            height: 100%;
            background-color: #fff;
            box-shadow: -4px 0 10px rgba(0,0,0,0.15);
            z-index: 9999;
            transition: right 0.4s ease;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }
        .side-panel.active {
            right: 0;
        }
        .panel-header {
            background-color: #dfa974;
            color: white;
            padding: 20px 25px;
            font-size: 18px;
            font-weight: 700;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }
        .panel-close {
            cursor: pointer;
            font-size: 24px;
            font-weight: 700;
        }
        .panel-body {
            padding: 25px;
            flex-grow: 1;
            overflow-y: auto;
        }
        .panel-body .form-control {
            border-radius: 8px;
            border: 1px solid #ccc;
        }
        .img-preview-tag {
            max-width: 240px;
            border-radius: 8px;
            border: 1px solid #eee;
        }
        .panel-footer {
            display: flex;
            justify-content: space-between;
            padding: 20px 25px;
            border-top: 1px solid #eee;
            background-color: #f8f8f8;
            flex-shrink: 0;
        }
        .btn-cancel, .btn-save {
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-cancel {
            background: #6c757d;
            color: white;
        }
        .btn-cancel:hover {
            background: #5a6268;
        }
        .btn-save {
            background: #28a745;
            color: white;
        }
        .btn-save:hover {
            background: #218838;
        }
    </style>
</head>

<body>
<c:set var="pageActive" value="rooms"/>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    <div class="dashboard-content">
        <div id="preloder">
            <div class="loader"></div>
        </div>

        <section class="main-content">
            <div class="container-fluid">

                <c:if test="${not empty param.created}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i> New room created successfully!
                    </div>
                </c:if>
                <c:if test="${not empty param.updated}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i> Room updated successfully!
                    </div>
                </c:if>
                <c:if test="${not empty param.deleted}">
                    <div class="alert alert-danger">
                        <i class="fa fa-check-circle"></i> Room deleted successfully!
                    </div>
                </c:if>

                <div class="search-section">
                    <form action="${pageContext.request.contextPath}/receptionist/rooms" method="get" class="search-form">
                        <input type="text" name="search" class="search-input"
                               placeholder="Search by room name..."
                               value="${search}">
                        <select name="categoryId" class="search-select">
                            <option value="">All Categories</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${c.categoryId == categoryId ? 'selected' : ''}>
                                        ${c.name}
                                </option>
                            </c:forEach>
                        </select>
                        <select name="status" class="search-select">
                            <option value="">All Statuses</option>
                            <option value="available" ${status == 'available' ? 'selected' : ''}>Available</option>
                            <option value="booked" ${status == 'booked' ? 'selected' : ''}>Booked</option>
                            <option value="maintenance" ${status == 'maintenance' ? 'selected' : ''}>Maintenance</option>
                        </select>

                        <button type="submit" class="search-btn">
                            <i class="fa fa-search"></i> Filter
                        </button>
                        <c:if test="${not empty search or not empty categoryId or not empty status}">
                            <a href="${pageContext.request.contextPath}/receptionist/rooms" class="action-btn secondary">
                                <i class="fa fa-times"></i> Clear
                            </a>
                        </c:if>
                    </form>
                </div>
                <div class="action-buttons">
                    <button class="action-btn" onclick="openPanel('add')">
                        <i class="fa fa-plus"></i> Add New Room
                    </button>
                </div>
                <div class="bills-table">
                    <div class="table-header">
                        <h4><i class="fa fa-list"></i>Rooms List</h4>
                    </div>

                    <c:choose>
                        <c:when test="${not empty rooms}">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Room Name</th>
                                    <th>Room Type</th>
                                    <th>Price</th>
                                    <th>Capacity</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="r" items="${rooms}" varStatus="loop">
                                    <tr data-room-id="${r.roomId}"
                                        data-name="${fn:escapeXml(r.name)}"
                                        data-category-id="${r.categoryId}"
                                        data-price="${r.price}"
                                        data-capacity="${r.capacity}"
                                        data-status="${r.status}"
                                        data-img-url="${r.imgUrl}"
                                        data-description="${fn:escapeXml(r.description)}">

                                        <td><div class="bill-id">${loop.count}</div></td>
                                        <td>
                                            <c:if test="${not empty r.imgUrl}">
                                                <img src="${r.imgUrl}" alt="${r.name}" class="room-thumbnail">
                                            </c:if>
                                            <c:if test="${empty r.imgUrl}">
                                                (No image)
                                            </c:if>
                                        </td>
                                        <td><div class="customer-name">${r.name}</div></td>
                                        <td><div class="bill-date">${r.category.name}</div></td>
                                        <td>
                                            <div class="bill-amount">
                                                <fmt:formatNumber value="${r.price}" pattern="#,##0"/>đ
                                            </div>
                                        </td>
                                        <td><div class="bill-date">${r.capacity} people</div></td>
                                        <td>
                                            <span class="status-badge ${r.status == 'available' ? 'status-confirmed' : (r.status == 'booked' ? 'status-cancelled' : 'status-pending')}">
                                                    ${r.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-links">
                                                <span class="action-link edit" onclick="openPanel('edit', this)">
                                                    <i class="fa fa-edit"></i> Edit
                                                </span>
                                                <form action="${pageContext.request.contextPath}/receptionist/room/delete" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this room?');">
                                                    <input type="hidden" name="id" value="${r.roomId}">
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
                                <i class="fa fa-bed"></i>
                                <h4>No Rooms Found</h4>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty search or not empty categoryId or not empty status}">
                                            No rooms found matching your filter. Try clearing the filter.
                                        </c:when>
                                        <c:otherwise>
                                            No rooms have been created yet.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <button class="action-btn" onclick="openPanel('add')">
                                    <i class="fa fa-plus"></i> Create First Room
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Rooms pagination" style="padding: 10px 20px 20px 20px;">
                        <ul class="pagination" style="margin:0; display:flex; justify-content:center; flex-wrap: wrap;">
                            <li class="page-item ${page == 1 ? 'disabled' : ''}" style="margin: 2px;">
                                <a class="page-link" href="${pageContext.request.contextPath}/receptionist/rooms?page=${page - 1}&size=${size}&search=${search}&categoryId=${categoryId}&status=${status}" aria-label="Previous"
                                   style="border-radius: 8px; padding: 8px 12px; border: 1px solid #e5e5e5; color: #19191a; text-decoration: none; display: inline-block;">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == page ? 'active' : ''}" style="margin: 2px;">
                                    <a class="page-link" href="${pageContext.request.contextPath}/receptionist/rooms?page=${i}&size=${size}&search=${search}&categoryId=${categoryId}&status=${status}"
                                       style="border-radius: 8px; padding: 8px 12px; text-decoration: none; display: inline-block;">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page == totalPages ? 'disabled' : ''}" style="margin: 2px;">
                                <a class="page-link" href="${pageContext.request.contextPath}/receptionist/rooms?page=${page + 1}&size=${size}&search=${search}&categoryId=${categoryId}&status=${status}" aria-label="Next"
                                   style="border-radius: 8px; padding: 8px 12px; border: 1px solid #e5e5e5; color: #19191a; text-decoration: none; display: inline-block;">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                        <div style="margin-top:10px; color:#6b6b6b; font-size: 12px; text-align:center;">
                            Page ${page} of ${totalPages} • Total ${totalItems} rooms
                        </div>
                    </nav>
                </c:if>

            </div>
        </section>

        <div class="side-panel" id="sidePanel">
            <form method="post" id="roomForm" enctype="multipart/form-data">
                <div class="panel-header">
                    <span id="panelTitle">Add New Room</span>
                    <span class="panel-close" onclick="window.location.href='${pageContext.request.contextPath}/receptionist/rooms'">&times;</span>
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
                        <input type="file" id="image" name="image" accept="image/*" class="form-control">
                        <div id="imgPreview" class="mt-2" style="display:none;">
                            <p>Current image:</p>
                            <img src="" alt="room" class="img-preview-tag"/>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <a href="${pageContext.request.contextPath}/receptionist/rooms" class="btn-cancel">Cancel</a>
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
    const f_image = document.getElementById('image');

    function openPanel(mode, button) {
        form.reset();
        imgPreview.style.display = 'none';
        imgTag.src = "";

        if (mode === 'add') {
            panelTitle.innerText = "Add New Room";
            form.action = "${pageContext.request.contextPath}/receptionist/room/new";
            f_roomId.value = "";
            f_currentImgUrl.value = "";
            f_categoryId.value = "${categories[0].categoryId}";
            f_capacity.value = "1";
            f_status.value = "available";
        } else if (mode === 'edit') {
            panelTitle.innerText = "Edit Room Information";
            form.action = "${pageContext.request.contextPath}/receptionist/room/edit";
            const row = button.closest('tr');
            const data = row.dataset;
            f_roomId.value = data.roomId;
            f_currentImgUrl.value = data.imgUrl;
            f_name.value = data.name;
            f_categoryId.value = data.categoryId;
            f_price.value = data.price;
            f_capacity.value = data.capacity;
            f_status.value = data.status;
            f_description.value = data.description;
            if (data.imgUrl && data.imgUrl !== "null" && data.imgUrl !== "") {
                imgTag.src = data.imgUrl;
                imgPreview.style.display = 'block';
            }
        }
        panel.classList.add("active");
    }

    <div class="search-model">
        <div class="h-100 d-flex align-items-center justify-content-center">
            <div class="search-close-switch"><i class="icon_close"></i></div>
            <form class="search-model-form">
                <input type="text" id="search-input" placeholder="Search here.....">
            </form>
        </div>
    </div>

    form.addEventListener('submit', function(e) {
        e.preventDefault();
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
                    window.location.href = '${pageContext.request.contextPath}/receptionist/rooms?' + data.action + '=true';
                } else {
                    alert('An error occurred while saving the room. Please try again.');
                    submitButton.disabled = false;
                    submitButton.innerText = "Save Changes";
                }
            });
    });
</script>
</body>
</html>
