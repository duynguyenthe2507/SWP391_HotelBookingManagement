<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
    <title>Rule Management - 36 Hotel</title>
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
        .status-badge.status-active {
            color: #ffffff;
            background: #28a745;
        }
        .status-badge.status-inactive {
            color: #ffffff;
            background: #6c757d;
        }
        .col-description {
            white-space: pre-line;
            text-align: left;
            font-size: 13px;
            max-width: 350px;
            overflow-wrap: break-word;
            line-height: 1.4;
        }
        /* CSS để làm cho bộ lọc giống như hình ảnh */
        .filter-section {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap; /* Cho phép xuống dòng trên di động */
            gap: 15px;
            align-items: center;
        }

        .filter-form .form-group {
            flex: 1; /* Các trường co giãn */
            min-width: 150px; /* Độ rộng tối thiểu */
        }

        /* Trường tìm kiếm tên */
        .filter-form .search-group {
            flex-grow: 3; /* Ưu tiên độ rộng cho trường tìm kiếm */
            min-width: 250px;
        }

        .filter-form .form-control {
            width: 100%;
            height: 46px;
            padding: 10px 15px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .filter-form .form-control:focus {
            border-color: #dfa974;
            box-shadow: 0 0 0 2px rgba(223, 169, 116, 0.2);
            outline: none;
        }

        .filter-form .btn-filter {
            height: 46px;
            border: none;
            background: #dfa974; /* Màu cam từ hình ảnh */
            color: white;
            padding: 0 25px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-form .btn-filter:hover {
            background: #c8965a;
        }/* CSS để làm cho bộ lọc giống như hình ảnh */
        .filter-section {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap; /* Cho phép xuống dòng trên di động */
            gap: 15px;
            align-items: center;
        }

        .filter-form .form-group {
            flex: 1; /* Các trường co giãn */
            min-width: 150px; /* Độ rộng tối thiểu */
        }

        /* Trường tìm kiếm tên */
        .filter-form .search-group {
            flex-grow: 3; /* Ưu tiên độ rộng cho trường tìm kiếm */
            min-width: 250px;
        }

        .filter-form .form-control {
            width: 100%;
            height: 46px;
            padding: 10px 15px;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .filter-form .form-control:focus {
            border-color: #dfa974;
            box-shadow: 0 0 0 2px rgba(223, 169, 116, 0.2);
            outline: none;
        }

        .filter-form .btn-filter {
            height: 46px;
            border: none;
            background: #dfa974; /* Màu cam từ hình ảnh */
            color: white;
            padding: 0 25px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-form .btn-filter:hover {
            background: #c8965a;
        }
    </style>
</head>

<body>
<c:set var="pageActive" value="rules"/>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    <div class="dashboard-content">
        <div id="preloder">
            <div class="loader"></div>
        </div>
        <section class="main-content">
            <div class="container-fluid">
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i> Operation saved successfully!
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fa fa-times-circle"></i> ${error}
                    </div>
                </c:if>

                <div class="filter-section">
                    <form action="${pageContext.request.contextPath}/rules" method="get" class="filter-form">

                        <div class="form-group search-group">
                            <input type="text" name="search" class="form-control"
                                   placeholder="Search by rule title..." value="${search}">
                        </div>

                        <div class="form-group">
                            <select name="status" class="form-control">
                                <option value="">All Statuses</option>
                                <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <button type="submit" class="btn-filter">
                            <i class="fa fa-search"></i> Filter
                        </button>

                        <c:if test="${not empty search || not empty status}">
                            <a href="${pageContext.request.contextPath}/rules"
                               class="btn-filter"
                               style="text-decoration: none; display:inline-flex; align-items: center; background: #6c757d;">
                                <i class="fa fa-times"></i> Clear
                            </a>
                        </c:if>
                    </form>
                </div>
                <div class="action-buttons">
                    <button class="action-btn" onclick="openPanel('add')">
                        <i class="fa fa-plus"></i> Add New Rule
                    </button>
                </div>
                <div class="bills-table">
                    <div class="table-header">
                        <h4><i class="fa fa-book"></i> Rules List</h4>
                    </div>
                    <c:choose>
                        <c:when test="${not empty rules}">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="r" items="${rules}" varStatus="loop">
                                    <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="fmtCreatedAt" />
                                    <fmt:formatDate value="${r.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="fmtUpdatedAt" />
                                    <tr data-rule-id="${r.ruleId}" data-title="${fn:escapeXml(r.title)}" data-description="${fn:escapeXml(r.description)}" data-status="${r.status ? 'Active' : 'Inactive'}" data-created-at="${fmtCreatedAt}" data-updated-at="${fmtUpdatedAt}">
                                        <td><div class="bill-id">${loop.count}</div></td>
                                        <td><div class="customer-name">${r.title}</div></td>
                                        <td class="col-description">${r.description}</td>
                                        <td><span class="status-badge ${r.status ? 'status-active' : 'status-inactive'}">${r.status ? 'Active' : 'Inactive'}</span></td>
                                        <td><div class="bill-date"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div></td>
                                        <td><div class="bill-date"><fmt:formatDate value="${r.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></div></td>
                                        <td>
                                            <div class="action-links">
                                                <span class="action-link edit" onclick="openPanel('edit', this)">
                                                    <i class="fa fa-edit"></i> Edit
                                                </span>
                                                <form action="${pageContext.request.contextPath}/rules/delete" method="get" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this rule?');">
                                                    <input type="hidden" name="id" value="${r.ruleId}">
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
                                <i class="fa fa-book"></i>
                                <h4>No Rules Found</h4>
                                <p>
                                    <c:if test="${not empty search}">No rules found matching your filter.</c:if>
                                    <c:if test="${empty search}">No rules have been created yet.</c:if>
                                </p>
                                <button class="action-btn" onclick="openPanel('add')">
                                    <i class="fa fa-plus"></i> Create First Rule
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
        <div class="side-panel" id="sidePanel">
            <form method="post" id="ruleForm" action="${pageContext.request.contextPath}/rules/save">
                <div class="panel-header">
                    <span id="panelTitle">Add New Rule</span>
                    <span class="panel-close" onclick="closePanel()">&times;</span>
                </div>
                <div class="panel-body">
                    <input type="hidden" id="ruleId" name="ruleId">
                    <div class="mb-3">
                        <label for="title">Rule Title</label>
                        <input type="text" id="title" name="title" class="form-control" required maxlength="255">
                    </div>
                    <div class="mb-3">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="5" class="form-control" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="status">Status</label>
                        <select id="status" name="status" class="form-control" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="createdAt">Created At</label>
                        <input type="datetime-local" id="createdAt" name="createdAt" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="updatedAt">Updated At</label>
                        <input type="datetime-local" id="updatedAt" name="updatedAt" class="form-control">
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
    const form = document.getElementById("ruleForm");
    const panelTitle = document.getElementById("panelTitle");
    const f_ruleId = document.getElementById('ruleId');
    const f_title = document.getElementById('title');
    const f_description = document.getElementById('description');
    const f_status = document.getElementById('status');
    const f_createdAt = document.getElementById('createdAt');
    const f_updatedAt = document.getElementById('updatedAt');
    function openPanel(mode, button) {
        form.reset();
        if (mode === 'add') {
            panelTitle.innerText = "Add New Rule";
            f_ruleId.value = "";
            f_status.value = "Active";
            f_createdAt.value = "";
            f_updatedAt.value = "";
        } else if (mode === 'edit') {
            panelTitle.innerText = "Edit Rule Information";
            const row = button.closest('tr');
            const data = row.dataset;
            f_ruleId.value = data.ruleId;
            f_title.value = data.title;
            f_description.value = data.description;
            f_status.value = data.status;
            f_createdAt.value = data.createdAt;
            f_updatedAt.value = data.updatedAt;
        }
        panel.classList.add("active");
    }
    function closePanel() {
        panel.classList.remove("active");
    }
</script>
</body>
</html>
