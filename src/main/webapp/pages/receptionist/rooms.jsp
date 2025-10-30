<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--
  New "All-in-One" file for Room Management
  Combines (rooms.jsp + room-edit.jsp + rules-list.jsp slide panel)
--%>

<%-- 1. CSS FROM rules-list.jsp --%>
<style>
    .btn-add {
        background-color: #dfa974; color: #fff; border: none;
        padding: 10px 18px; border-radius: 6px; font-weight: 600;
        transition: all 0.3s ease;
    }
    .btn-add:hover { background-color: #b67b4b; }
    .side-panel {
        position: fixed; top: 0; right: -600px; width: 500px; height: 100%;
        background-color: #fff; box-shadow: -4px 0 10px rgba(0,0,0,0.15);
        z-index: 9999; transition: right 0.4s ease; overflow-y: auto;
    }
    .side-panel.active { right: 0; }
    .panel-header {
        background-color: #dfa974; color: white; padding: 20px;
        font-size: 18px; font-weight: 700; display: flex;
        justify-content: space-between; align-items: center;
    }
    .panel-body { padding: 25px; }
    .panel-body input, .panel-body textarea, .panel-body select {
        border-radius: 8px; border: 1px solid #ccc;
    }
    .panel-footer {
        display: flex; justify-content: space-between; padding: 20px 25px;
        border-top: 1px solid #eee; background-color: #f8f8f8;
    }
    .btn-cancel {
        background: #dc3545; color: white; border: none;
        border-radius: 6px; padding: 10px 20px;
    }
    .btn-save {
        background: #28a745; color: white; border: none;
        border-radius: 6px; padding: 10px 20px;
    }
    .table thead th {
        background-color: #dfa974; color: white; text-align: center;
    }
    .table td { vertical-align: middle; }
    .action-link { color: #dfa974; cursor: pointer; font-weight: 600; }
    .room-thumbnail {
        width: 120px;
        height: 80px;
        object-fit: cover;
        border-radius: 6px;
        border: 1px solid #eee;
    }
</style>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Room Management</h2>
        <%-- 2. ADD BUTTON FROM rules-list.jsp --%>
        <button class="btn-add" onclick="openPanel('add')"><i class="fa fa-plus"></i> Add New Room</button>
    </div>

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
            <thead class="thead-dark">
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
                            <%-- 3. UPDATING THE "EDIT" BUTTON --%>
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

<%-- 4. SLIDE PANEL FROM rules-list.jsp, MODIFIED FOR ROOMS --%>
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
                <%-- Categories are passed from the Controller --%>
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

    function openPanel(mode, button) {
        // Clear the old file input
        form.querySelector('input[type=file]').value = "";

        if (mode === 'add') {
            panelTitle.innerText = "Add New Room";
            form.action = "${pageContext.request.contextPath}/receptionist/room/new";

            // Clear form values
            f_roomId.value = "";
            f_currentImgUrl.value = "";
            f_name.value = "";
            f_categoryId.value = "${categories[0].categoryId}"; // Get the first category
            f_price.value = "";
            f_capacity.value = "1";
            f_status.value = "available";
            f_description.value = "";
            imgPreview.style.display = 'none';
        } else if (mode === 'edit') {
            panelTitle.innerText = "Edit Room Information";
            form.action = "${pageContext.request.contextPath}/receptionist/room/edit";

            // Get data from data-* attributes of the <tr>
            const row = button.closest('tr');
            const data = row.dataset;

            // Fill data into the form
            f_roomId.value = data.roomId;
            f_currentImgUrl.value = data.imgUrl;
            f_name.value = data.name;
            f_categoryId.value = data.categoryId;
            f_price.value = data.price;
            f_capacity.value = data.capacity;
            f_status.value = data.status;
            f_description.value = data.description;

            // Display image
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

    // *** ADD/EDIT PART (SUBMIT FIX) ***
    form.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent traditional form submission

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
                    // Reload the content in #content-area
                    // (Just like how SideBar.jsp loads pages)
                    // This will also trigger the success message (param.created/updated)
                    $('#content-area').load(
                        '${pageContext.request.contextPath}/receptionist/rooms?' + data.action + '=true'
                    );
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