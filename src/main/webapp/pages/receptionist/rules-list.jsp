<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Hotel Rules | 36 Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body { background-color: #f9f9f9; }
        .btn-add {
            background-color: #dfa974;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-add:hover { background-color: #b67b4b; }

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
        }
        .side-panel.active { right: 0; }

        .panel-header {
            background-color: #dfa974;
            color: white;
            padding: 20px;
            font-size: 18px;
            font-weight: 700;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .panel-body { padding: 25px; }
        .panel-body input, .panel-body textarea, .panel-body select {
            border-radius: 8px;
            border: 1px solid #ccc;
        }
        .panel-footer {
            display: flex;
            justify-content: space-between;
            padding: 20px 25px;
            border-top: 1px solid #eee;
            background-color: #f8f8f8;
        }
        .btn-cancel {
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
        }
        .btn-save {
            background: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
        }
        .table thead th {
            background-color: #dfa974;
            color: white;
            text-align: center;
        }
        .table td { vertical-align: middle; }
        .badge-active { background-color: #28a745; color: white; padding: 5px 10px; border-radius: 6px; }
        .badge-inactive { background-color: #dc3545; color: white; padding: 5px 10px; border-radius: 6px; }
        .action-link { color: #dfa974; cursor: pointer; font-weight: 600; }
    </style>
</head>

<body>

<div class="container mt-5 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Rules Management</h2>
        <button class="btn-add" onclick="openPanel('add')"><i class="fa fa-plus"></i> Add New Rule</button>
    </div>

    <table class="table table-bordered text-center">
        <thead>
        <tr>
            <th>#</th>
            <th>Title</th>
            <th>Description</th>
            <th>Status</th>
            <th>Created At</th>
            <th>Updated At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${rules}" varStatus="i">
            <tr>
                <td>${i.index + 1}</td>
                <td>${r.title}</td>
                <td>${r.description}</td>
                <td><span class="${r.status ? 'badge-active' : 'badge-inactive'}">${r.status ? 'Active' : 'Inactive'}</span></td>
                <td>${r.createdAt}</td>
                <td>${r.updatedAt}</td>
                <td>
                    <span class="action-link"
                          onclick="openPanel('edit', ${r.ruleId}, '${r.title}', '${r.description}', '${r.status}', '${r.createdAt}', '${r.updatedAt}')">
                        <i class="fa fa-pencil"></i> Edit
                    </span>
                    <a href="javascript:void(0);"
                       class="text-danger"
                       onclick="confirmDelete('${pageContext.request.contextPath}/rules/delete?id=${r.ruleId}')">
                        <i class="fa fa-trash"></i> Delete
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- ✅ Slide Panel -->
<div class="side-panel" id="sidePanel">
    <form action="${pageContext.request.contextPath}/rules/save" method="post" id="ruleForm">
        <div class="panel-header">
            <span id="panelTitle">Add New Rule</span>
            <span style="cursor:pointer" onclick="closePanel()">&times;</span>
        </div>

        <div class="panel-body">
            <input type="hidden" id="ruleId" name="ruleId">

            <div class="mb-3">
                <label>Rule Title</label>
                <input type="text" id="title" name="title" class="form-control" required>
            </div>

            <div class="mb-3">
                <label>Description</label>
                <textarea id="description" name="description" rows="3" class="form-control" required></textarea>
            </div>

            <div class="mb-3">
                <label>Status</label>
                <select id="status" name="status" class="form-select">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <!-- ✅ Cho phép tự nhập -->
            <div class="mb-3">
                <label>Created At (Manual Input)</label>
                <input type="datetime-local" id="createdAt" name="createdAt" class="form-control">
            </div>

            <div class="mb-3">
                <label>Updated At (Manual Input)</label>
                <input type="datetime-local" id="updatedAt" name="updatedAt" class="form-control">
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
    const ruleIdField = document.getElementById("ruleId");
    const titleField = document.getElementById("title");
    const descField = document.getElementById("description");
    const statusField = document.getElementById("status");
    const createdAtField = document.getElementById("createdAt");
    const updatedAtField = document.getElementById("updatedAt");
    const panelTitle = document.getElementById("panelTitle");

    function openPanel(mode, id = "", title = "", desc = "", status = "Active", created = "", updated = "") {
        panel.classList.add("active");

        if (mode === 'add') {
            panelTitle.innerText = "Add New Rule";
            ruleIdField.value = "";
            titleField.value = "";
            descField.value = "";
            statusField.value = "Active";
            createdAtField.value = "";
            updatedAtField.value = "";
        } else {
            panelTitle.innerText = "Edit Rule";
            ruleIdField.value = id;
            titleField.value = title;
            descField.value = desc;
            statusField.value = status;
            createdAtField.value = convertDate(created);
            updatedAtField.value = convertDate(updated);
        }
    }

    function closePanel() {
        panel.classList.remove("active");
    }

    // Chuyển đổi ngày từ định dạng SQL hoặc text sang định dạng datetime-local
    function convertDate(dateStr) {
        if (!dateStr) return "";
        try {
            const date = new Date(dateStr);
            return date.toISOString().slice(0, 16);
        } catch (e) {
            return "";
        }
    }
</script>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

<script>
    // Khi submit form thêm/sửa rule -> reload lại sau khi lưu thành công
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.querySelector("form[action*='save']");
        if (form) {
            form.addEventListener("submit", function (e) {
                e.preventDefault(); // Ngăn gửi form mặc định
                const formData = new FormData(form);

                fetch(form.action, {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    if (response.ok) {
                        alert("Lưu thành công!");
                        window.location.reload(); // Tự reload lại trang
                    } else {
                        alert("Có lỗi xảy ra khi lưu!");
                    }
                }).catch(err => alert("Lỗi: " + err));
            });
        }
    });
</script>
    <script>
        // Xác nhận khi xóa
        function confirmDelete(url) {
        const confirmed = confirm("Bạn có chắc chắn muốn xóa không?");
        if (confirmed) {
        window.location.href = url;
    }
    }
</script>



</body>
</html>
