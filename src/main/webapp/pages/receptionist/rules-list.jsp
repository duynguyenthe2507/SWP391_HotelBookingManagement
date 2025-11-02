<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Rules | 36 Hotel</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">

    <style>
        /*
         * =============================================
         * RE-STYLED THEME (Dựa trên sidebar.jsp)
         * =============================================
         */
        :root {
            /* Màu chủ đạo (từ sidebar.jsp) */
            --primary-blue: #336699;
            --primary-blue-dark: #2d5986;

            /* Màu nhấn (từ sidebar.jsp user-info) */
            --accent-gold: #dfa974;
            --accent-gold-dark: #b67b4b;

            /* Màu nền (từ sidebar.jsp) */
            --bg-main: #f4f7fc;
            --border-color: #e3e6f0;

            /* Màu trạng thái */
            --success: #28a745;
            --success-bg: rgba(40, 167, 69, 0.1);
            --success-text: #1a682c;
            --danger: #dc3545;
            --danger-bg: rgba(220, 53, 69, 0.1);
            --danger-text: #8c1c27;

            /* Layout */
            --panel-width: 480px;
        }

        body {
            /* Đồng bộ font và nền từ sidebar.jsp */
            background: var(--bg-main);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin: 30px 0;
        }

        h2 {
            margin: 0;
            font-weight: 700;
            color: #2b2b2b;
        }

        .btn-add {
            /* Sử dụng màu xanh chủ đạo */
            background: var(--primary-blue);
            color: #fff;
            border: 0;
            padding: 10px 18px;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(51, 102, 153, 0.2);
            font-weight: 600;
            transition: background 0.3s;
        }

        .btn-add:hover {
            background: var(--primary-blue-dark);
        }

        .controls {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input {
            min-width: 240px;
        }

        .card-table {
            padding: 18px;
            border-radius: 10px;
            /* Đồng bộ shadow và border từ sidebar.jsp */
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            background: #fff;
            border: 1px solid var(--border-color);
        }

        table.table {
            margin-bottom: 0;
        }

        .table thead th {
            /* Sử dụng màu xanh chủ đạo */
            background: var(--primary-blue);
            color: #fff;
            border: none;
            text-align: center;
            vertical-align: middle;
            font-weight: 600;
            padding-top: 12px;
            padding-bottom: 12px;
        }

        .table td {
            vertical-align: middle;
            color: #444;
        }

        /*
         * =============================================
         * NÂNG CẤP BADGE (Chuyên nghiệp hơn)
         * =============================================
         */
        .badge {
            font-size: 0.8rem;
            font-weight: 600;
            padding: .35em .7em;
            border-radius: 50rem; /* Dạng viên thuốc */
        }

        .badge-active {
            background-color: var(--success-bg);
            color: var(--success-text);
        }

        .badge-inactive {
            background-color: var(--danger-bg);
            color: var(--danger-text);
        }

        /*
         * =============================================
         * LINKS (Sử dụng màu vàng làm điểm nhấn)
         * =============================================
         */
        .action-link {
            color: var(--accent-gold);
            cursor: pointer;
            font-weight: 600;
            margin-right: 10px;
            text-decoration: none;
            transition: color 0.3s;
        }
        .action-link:hover {
            color: var(--accent-gold-dark);
        }

        .text-danger {
            transition: color 0.3s;
        }

        .small-muted {
            color: #6b6b6b;
            font-size: 0.9rem;
        }

        /* * =============================================
         * SLIDE PANEL (Đồng bộ màu)
         * =============================================
         */
        .side-panel {
            position: fixed;
            top: 0;
            right: -999px;
            width: var(--panel-width);
            height: 100%;
            background: #fff;
            z-index: 1100;
            box-shadow: -10px 0 30px rgba(30, 30, 30, 0.12);
            transition: right .35s ease;
            display: flex;
            flex-direction: column;
            border-left: 1px solid var(--border-color);
        }

        .side-panel.active {
            right: 0;
        }

        .panel-header {
            padding: 20px 24px;
            /* Sử dụng màu xanh chủ đạo */
            background: var(--primary-blue);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .panel-header strong {
            font-size: 1.2rem;
            font-weight: 600;
        }

        .panel-body {
            padding: 24px;
            overflow: auto;
            flex: 1;
        }

        .panel-footer {
            padding: 14px 24px;
            border-top: 1px solid var(--border-color);
            display: flex;
            gap: 10px;
            justify-content: space-between;
            background: #fafafa;
        }

        .form-control, .form-select, textarea {
            border-radius: 6px;
            border: 1px solid var(--border-color);
            box-shadow: none;
        }
        .form-control:focus, .form-select:focus, textarea:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(51, 102, 153, 0.15);
        }

        .muted-note {
            font-size: .85rem;
            color: #7a7a7a;
            margin-top: 8px;
        }
        /* SỬA LẠI CLASS NÀY */
        .controls-bar {
            display: flex;
            justify-content: space-between; /* Đẩy 2 nhóm ra 2 bên */
            align-items: center;
            flex-wrap: wrap;     /* Cho phép xuống hàng trên màn hình nhỏ */
            gap: 15px;           /* Khoảng cách nếu bị xuống hàng */
            margin-bottom: 20px;
        }

        /* THÊM CLASS MỚI NÀY */
        .search-group {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: nowrap;   /* Giữ nhóm tìm kiếm trên 1 hàng */
            flex-grow: 1;        /* Cho phép nhóm này co giãn */
        }

        /* SỬA LẠI CLASS NÀY (để co giãn tốt hơn) */
        .search-input {
            min-width: 200px; /* Đặt độ rộng tối thiểu */
            flex-grow: 1;
            flex-shrink: 1;
        }

        /* (Các class .filter-select và .controls-bar .btn giữ nguyên) */
        .filter-select {
            width: 150px;
            flex-shrink: 0;
        }

        .controls-bar .btn {
            flex-shrink: 0;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .side-panel {
                width: 100%;
            }
            .search-input {
                min-width: 140px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="topbar">
        <div>
            <h2>Rules Receptionist</h2>
            <div class="small-muted">Quản lý các quy định/hướng dẫn cho receptionist</div>
        </div>

    </div>


    <div class="controls-bar">
        <div class="search-group">
            <input id="searchBox" class="form-control search-input" placeholder="Tìm theo tiêu đề / mô tả..." oninput="filterTable()" />

            <select id="statusFilter" class="form-select filter-select" onchange="filterTable()">
                <option value="all">Tất cả</option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
            </select>

            <button class="btn btn-outline-secondary" onclick="refreshPage()" title="Tải lại trang">
                <i class="fa fa-refresh"></i>
            </button>
        </div>

        <div>
            <button class="btn-add" onclick="openPanel('add')">
                <i class="fa fa-plus"></i> Thêm rule
            </button>
        </div>
    </div>
    <div class="card-table">
        <div class="table-responsive">
            <table class="table table-hover align-middle text-center" id="rulesTable">
                <thead>
                <tr>
                    <th style="width:48px">#</th>
                    <th>Title</th>
                    <th style="width:36%;">Description</th>
                    <th style="width:110px">Status</th>
                    <th style="width:140px">Created At</th>
                    <th style="width:140px">Updated At</th>
                    <th style="width:150px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${rules}" varStatus="i">
                    <tr
                            data-id="${r.ruleId}"
                            data-title="${fn:escapeXml(r.title)}"
                            data-desc="${fn:escapeXml(r.description)}"
                            data-status="${r.status}"
                            data-created="${r.createdAt}"
                            data-updated="${r.updatedAt}">
                        <td>${i.index + 1}</td>
                        <td class="text-start px-3" style="font-weight: 500;">${r.title}</td>
                        <td class="text-start" style="max-width: 36%;white-space: pre-line; word-wrap: break-word;">${r.description}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.status}">
                                    <span class="badge badge-active">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-inactive">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${r.createdAt}</td>
                        <td>${r.updatedAt}</td>
                        <td>
                                <%-- THAY ĐỔI: Sử dụng class .action-link cho Edit --%>
                            <a href="javascript:void(0)" class="action-link" onclick="openEditFromRow(this)"><i class="fa fa-pencil"></i> Edit</a>
                            <a href="javascript:void(0)" class="text-danger" onclick="confirmDelete('${pageContext.request.contextPath}/rules/delete?id=${r.ruleId}')"><i class="fa fa-trash"></i> Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="mt-3 small-muted">Hiển thị ${fn:length(rules)} rule(s).</div>
    </div>
</div>

<div class="side-panel" id="sidePanel">
    <form action="${pageContext.request.contextPath}/rules/save" method="post" id="ruleForm">
        <div class="panel-header">
            <strong id="panelTitle">Add New Rule</strong>
            <div style="display:flex; gap:8px; align-items:center;">
                <button type="button" class="btn btn-sm btn-light" title="Đóng" onclick="closePanel()">&times;</button>
            </div>
        </div>

        <div class="panel-body">
            <input type="hidden" id="ruleId" name="ruleId">

            <div class="mb-3">
                <label class="form-label">Rule Title <span class="text-danger">*</span></label>
                <input type="text" id="title" name="title" class="form-control" required maxlength="150" />
            </div>

            <div class="mb-3">
                <label class="form-label">Description <span class="text-danger">*</span></label>
                <textarea id="description" name="description" rows="4" class="form-control" required maxlength="1000"></textarea>
                <div class="muted-note">Tối đa 1000 ký tự.</div>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <select id="status" name="status" class="form-select">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <div class="row">
                <div class="col-12 mb-3">
                    <label class="form-label">Created At (manual)</label>
                    <input type="datetime-local" id="createdAt" name="createdAt" class="form-control" />
                </div>
                <div class="col-12 mb-3">
                    <label class="form-label">Updated At (manual)</label>
                    <input type="datetime-local" id="updatedAt" name="updatedAt" class="form-control" />
                </div>
            </div>

            <div class="mt-2 small-muted">Lưu ý: nếu không nhập Created/Updated, server sẽ gán thời gian hiện tại.</div>

        </div>

        <div class="panel-footer">
            <div>
                <button type="button" class="btn btn-outline-secondary" onclick="closePanel()">Hủy</button>
            </div>
            <div style="display:flex; gap:8px;">
                <button type="button" class="btn btn-light" onclick="fillNow()">Set Now</button>
                <button type="submit" class="btn btn-success">Lưu</button>
            </div>
        </div>
    </form>
</div>

<script>
    // DOM refs
    const sidePanel = document.getElementById('sidePanel');
    const panelTitle = document.getElementById('panelTitle');
    const ruleForm = document.getElementById('ruleForm');
    const ruleIdField = document.getElementById('ruleId');
    const titleField = document.getElementById('title');
    const descField = document.getElementById('description');
    const statusField = document.getElementById('status');
    const createdAtField = document.getElementById('createdAt');
    const updatedAtField = document.getElementById('updatedAt');

    // Open panel for add
    function openPanel(mode) {
        sidePanel.classList.add('active');
        if (mode === 'add') {
            panelTitle.innerText = 'Thêm rule mới';
            ruleIdField.value = '';
            titleField.value = '';
            descField.value = '';
            statusField.value = 'Active';
            createdAtField.value = '';
            updatedAtField.value = '';
        }
    }

    // Open panel populated from a table row
    function openEditFromRow(el) {
        const tr = el.closest('tr');
        const dataset = tr.dataset;
        sidePanel.classList.add('active');
        panelTitle.innerText = 'Chỉnh sửa rule';
        ruleIdField.value = dataset.id || '';
        titleField.value = dataset.title || '';
        descField.value = dataset.desc || '';
        statusField.value = (dataset.status === 'true' || dataset.status === 'Active') ? 'Active' : 'Inactive';
        createdAtField.value = convertToLocalDatetime(dataset.created || '');
        updatedAtField.value = convertToLocalDatetime(dataset.updated || '');
    }

    function closePanel() {
        sidePanel.classList.remove('active');
    }

    // convert various date strings to datetime-local (YYYY-MM-DDTHH:mm)
    function convertToLocalDatetime(dateStr) {
        if (!dateStr) return '';
        // try parse
        const d = new Date(dateStr);
        if (isNaN(d)) return '';
        // get local ISO without seconds
        const tzOffset = d.getTimezoneOffset() * 60000;
        const local = new Date(d.getTime() - tzOffset).toISOString().slice(0, 16);
        return local;
    }

    // Set created/updated to now
    function fillNow() {
        const now = new Date();
        const tzOffset = now.getTimezoneOffset() * 60000;
        const local = new Date(now.getTime() - tzOffset).toISOString().slice(0, 16);
        if (!createdAtField.value) createdAtField.value = local;
        updatedAtField.value = local;
    }

    // Submit via Fetch (keep existing behavior)
    document.addEventListener('DOMContentLoaded', function () {
        if (ruleForm) {
            ruleForm.addEventListener('submit', function (e) {
                e.preventDefault();
                const formData = new FormData(ruleForm);
                fetch(ruleForm.action, { method: 'POST', body: formData })
                    .then(resp => {
                        if (resp.ok) {
                            alert('Lưu thành công!');
                            window.location.reload();
                        } else {
                            resp.text().then(t => alert('Lỗi khi lưu: ' + t));
                        }
                    }).catch(err => alert('Lỗi: ' + err));
            });
        }
    });

    // Delete confirm
    function confirmDelete(url) {
        if (confirm('Bạn có chắc chắn muốn xóa không?')) {
            window.location.href = url;
        }
    }

    // Simple client-side filter
    function filterTable() {
        const q = document.getElementById('searchBox').value.trim().toLowerCase();
        const status = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('#rulesTable tbody tr');
        rows.forEach(r => {
            const title = (r.dataset.title || '').toLowerCase();
            const desc = (r.dataset.desc || '').toLowerCase();
            const st = (r.dataset.status === 'true' || r.dataset.status === 'Active') ? 'Active' : 'Inactive';

            const matchQ = !q || title.includes(q) || desc.includes(q);
            const matchStatus = (status === 'all') || (status === st);

            r.style.display = (matchQ && matchStatus) ? '' : 'none';
        });
    }

    function refreshPage() {
        window.location.reload();
    }
</script>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>