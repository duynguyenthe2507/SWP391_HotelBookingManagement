<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, Models.GuestRequest, Models.Users, Dao.UsersDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<GuestRequest> items = (List<GuestRequest>) request.getAttribute("items");
    UsersDao usersDao = new UsersDao();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Guest Requests - 36 Hotel">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Requests - 36 Hotel</title>

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

    <style>
        /* Giữ nguyên CSS cũ */
        body { background: #f8f9fa; font-family: "Cabin", sans-serif; }
        .dashboard-wrapper { display: flex; min-height: 100vh; }
        .dashboard-content { flex: 1; margin-left: 250px; width: calc(100% - 250px); padding: 40px; min-height: 100vh; }
        .alert {
            border-radius: 12px; padding: 15px 20px; margin-bottom: 25px; border: none;
            font-weight: 500; box-shadow: 0 4px 15px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 12px;
        }
        .alert i { font-size: 20px; }
        .alert-success { background: linear-gradient(135deg, #d1f2eb, #a8e6cf); color: #0f5132; }
        .alert-success i { color: #00b894; }
        .alert-danger { background: linear-gradient(135deg, #f8d7da, #f5c6cb); color: #721c24; }
        .alert-danger i { color: #d63031; }
        .requests-table { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); }
        .table-header { background: linear-gradient(135deg, #dfa974 0%, #c8965a 100%); padding: 20px 30px; color: white; }
        .table-header h4 { margin: 0; color: white; font-weight: 600; display: flex; align-items: center; }
        .table-header h4 i { margin-right: 10px; }
        .requests-table table { margin: 0; width: 100%; }
        .requests-table thead th {
            background: #f8f9fa; color: #19191a; border: none; padding: 15px 20px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px; font-size: 12px; border-bottom: 2px solid #e5e5e5;
        }
        .requests-table tbody td { padding: 20px; border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
        .requests-table tbody tr:last-child td { border-bottom: none; }
        .requests-table tbody tr:hover { background: linear-gradient(90deg, rgba(223, 169, 116, 0.05), rgba(223, 169, 116, 0.02)); }
        .guest-info { font-size: 14px; color: #19191a; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .guest-info i { color: #dfa974; }
        .guest-booking { font-size: 13px; color: #6b6b6b; margin-top: 6px; display: flex; align-items: center; gap: 6px; }
        .guest-booking i { color: #dfa974; }
        .request-content { font-size: 14px; max-width: 350px; word-wrap: break-word; line-height: 1.5; color: #333; }
        .request-type-badge {
            display: inline-block; padding: 4px 10px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border-radius: 12px; font-size: 11px; font-weight: 600; margin-bottom: 8px;
        }
        .status-badge {
            padding: 6px 12px; border-radius: 15px; font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.3px; border: 1px solid; display: inline-block; text-align: center; min-width: 90px;
        }
        .status-pending { background: linear-gradient(135deg, #fff3cd, #ffeaa7); color: #856404; border-color: #ffeaa7; }
        .status-replied { background: linear-gradient(135deg, #d1ecf1, #bee5eb); color: #0c5460; border-color: #bee5eb; }
        .status-resolved { background: linear-gradient(135deg, #d4edda, #c3e6cb); color: #155724; border-color: #c3e6cb; }
        .status-cancelled { background: linear-gradient(135deg, #e2e3e5, #d6d8db); color: #383d41; border-color: #d6d8db; }
        .action-buttons { display: flex; flex-direction: column; gap: 8px; min-width: 120px; }
        .action-button {
            background: linear-gradient(135deg, #dfa974, #c8965a); color: white; border: none; padding: 8px 15px;
            border-radius: 15px; font-size: 12px; font-weight: 600; text-decoration: none; transition: all 0.3s ease;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px; white-space: nowrap; cursor: pointer;
        }
        .action-button:hover { color: white; text-decoration: none; transform: translateY(-2px); box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3); }
        .action-button i { font-size: 11px; }
        .action-button.delete { background: linear-gradient(135deg, #dc3545, #c82333); }
        .action-button.delete:hover { box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3); }
        .empty-state { text-align: center; padding: 60px 20px; color: #6b6b6b; }
        .empty-state i { font-size: 3rem; margin-bottom: 15px; color: #dfa974; opacity: 0.5; }
        .empty-state h5 { margin-bottom: 10px; color: #19191a; }
        @media (max-width: 768px) {
            .dashboard-content { margin-left: 0; padding: 20px; }
            .action-buttons { min-width: 100px; }
        }
    </style>
</head>
<body>
<c:set var="pageActive" value="requests"/>

<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="dashboard-content">

        <%-- Flash Messages --%>
        <c:if test="${not empty sessionScope.flash_success}">
            <div class="alert alert-success">
                <i class="fa fa-check-circle"></i>
                <span>${sessionScope.flash_success}</span>
            </div>
            <c:remove var="flash_success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.flash_error}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-triangle"></i>
                <span>${sessionScope.flash_error}</span>
            </div>
            <c:remove var="flash_error" scope="session"/>
        </c:if>

        <div class="requests-table">
            <div class="table-header">
                <h4><i class="fa fa-envelope"></i> Guest Requests Management</h4>
            </div>
            <table class="table mb-0">
                <thead>
                <tr>
                    <th><i class="fa fa-hashtag"></i> ID</th>
                    <th><i class="fa fa-user"></i> Guest Information</th>
                    <th><i class="fa fa-commenting"></i> Request Details</th>
                    <th><i class="fa fa-info-circle"></i> Status</th>
                    <th><i class="fa fa-cogs"></i> Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (items != null && !items.isEmpty()) {
                        for (GuestRequest g : items) {
                            String badgeClass = "status-cancelled";
                            if ("pending".equalsIgnoreCase(g.getStatus())) badgeClass = "status-pending";
                            else if ("replied".equalsIgnoreCase(g.getStatus())) badgeClass = "status-replied";
                            else if ("resolved".equalsIgnoreCase(g.getStatus())) badgeClass = "status-resolved";
                            // Lấy user info
                            Users user = null;
                            String guestName = "Unknown Guest";
                            try {
                                user = usersDao.getById(g.getUserId());
                                if (user != null) {
                                    guestName = (user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName()).trim().replaceAll("\\s+", " ");
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                %>
                <tr>
                    <td><strong>#<%= g.getRequestId() %></strong></td>
                    <td>
                        <div class="guest-info">
                            <i class="fa fa-user-circle"></i>
                            <span><%= guestName %></span>
                        </div>
                        <div class="guest-booking">
                            <i class="fa fa-bed"></i>
                            <span>Booking #<%= g.getBookingId() %></span>
                        </div>
                    </td>
                    <td>
                        <div class="request-type-badge"><%= g.getRequestType() %></div>
                        <div class="request-content">
                            <%= (g.getContent() != null && g.getContent().length() > 100)
                                    ? g.getContent().substring(0, 100) + "…" : g.getContent() %>
                        </div>
                    </td>
                    <td>
                        <span class="status-badge <%= badgeClass %>"><%= g.getStatus() %></span>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a class="action-button"
                               href="<%= request.getContextPath() %>/receptionist/requests/detail?id=<%= g.getRequestId() %>">
                                <i class="fa fa-eye"></i> View / Reply
                            </a>
                            <form method="post"
                                  action="<%= request.getContextPath() %>/receptionist/requests/delete"
                                  style="margin: 0; width: 100%;"
                                  onsubmit="return confirm('Are you sure you want to delete request #<%= g.getRequestId() %>?');">
                                <input type="hidden" name="id" value="<%= g.getRequestId() %>"/>
                                <button type="submit" class="action-button delete" style="width: 100%;">
                                    <i class="fa fa-trash"></i> Delete
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="5">
                        <div class="empty-state">
                            <i class="fa fa-inbox"></i>
                            <h5>No Guest Requests Found</h5>
                            <p>There are currently no guest requests in the system.</p>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
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
</body>
</html>