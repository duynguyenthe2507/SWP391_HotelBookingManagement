<%--
    request-reply.jsp
    Đã được cập nhật để tích hợp layout dashboard, sidebar,
    và sử dụng CSS/JS từ các trang khác của bạn.
    Sử dụng style 'room-detail-card', 'back-button', 'action-btn'
    từ file room-fee-detail.jsp để đồng bộ.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.GuestRequest" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    GuestRequest gr = (GuestRequest) request.getAttribute("item");
    if (gr == null) {
        // Xử lý trường hợp không tìm thấy request
        response.sendRedirect(request.getContextPath() + "/receptionist/requests?error=Request+not+found");
        return;
    }
    boolean closed = "resolved".equalsIgnoreCase(gr.getStatus()) || "cancelled".equalsIgnoreCase(gr.getStatus());

    // Logic xác định class cho badge
    String badgeClass = "status-cancelled"; // Default
    if ("pending".equalsIgnoreCase(gr.getStatus())) badgeClass = "status-pending";
    else if ("replied".equalsIgnoreCase(gr.getStatus())) badgeClass = "status-replied";
    else if ("resolved".equalsIgnoreCase(gr.getStatus())) badgeClass = "status-resolved";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Reply Request - 36 Hotel">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reply to Request #<%= gr.getRequestId() %> - 36 Hotel</title>

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
        /* Layout Styles (Copied from room-fee-detail.jsp) */
        body {
            background: #f8f9fa;
            font-family: "Cabin", sans-serif;
        }
        .dashboard-wrapper {
            display: flex;
            min-height: 100vh;
        }
        .dashboard-content {
            flex: 1;
            margin-left: 250px; /* Width of sidebar */
            width: calc(100% - 250px);
            padding: 40px;
            min-height: 100vh;
        }

        /* Card Styles (Copied from room-fee-detail.jsp) */
        .room-detail-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
        }
        .room-detail-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dfa974, #c8965a);
        }
        .card-title-h1 {
            color: #19191a;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 30px;
            font-family: "Lora", serif;
        }
        .form-label {
            font-weight: 600;
            color: #19191a;
            margin-bottom: 8px;
            font-size: 1rem;
        }
        .form-label i {
            margin-right: 8px;
            color: #dfa974;
            width: 20px;
            text-align: center;
        }
        .form-control-plaintext {
            padding-left: 0;
            padding-right: 0;
            font-size: 1rem;
            color: #333;
            background: #f8f9fa;
            padding: 10px 15px;
            border-radius: 8px;
            min-height: 40px;
            border: 1px solid #e5e5e5;
        }

        /* Back Button Style (Copied from room-fee-detail.jsp) */
        .back-button {
            display: inline-block;
            padding: 12px 25px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }
        .back-button:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3);
        }

        /* Action Button Styles (Copied from room-fee-detail.jsp) */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .action-btn {
            padding: 12px 25px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        .action-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3);
        }
        .action-btn.success { /* For 'Mark as Resolved' */
            background: linear-gradient(135deg, #28a745, #218838);
        }
        .action-btn.success:hover {
            background: linear-gradient(135deg, #218838, #1e7e34);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        .action-btn:disabled {
            background: #6c757d;
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Status Badge Styles (Copied from requests-list.jsp) */
        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border: 1px solid;
            display: inline-block;
            text-align: center;
            min-width: 90px;
        }
        .status-pending { /* Yellow */
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border-color: #ffeaa7;
        }
        .status-replied { /* Blue */
            background: linear-gradient(135deg, #d1ecf1, #bee5eb);
            color: #0c5460;
            border-color: #bee5eb;
        }
        .status-resolved { /* Green */
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-color: #c3e6cb;
        }
        .status-cancelled { /* Gray */
            background: linear-gradient(135deg, #e2e3e5, #d6d8db);
            color: #383d41;
            border-color: #d6d8db;
        }

        @media (max-width: 768px) {
            .dashboard-content {
                margin-left: 0;
                padding: 20px;
            }
            .room-detail-card {
                padding: 20px;
            }
            .card-title-h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
<%-- Đặt biến này để sidebar có thể highlight đúng mục --%>
<c:set var="pageActive" value="requests"/>

<div class="dashboard-wrapper">
    <%-- Include Sidebar --%>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="dashboard-content">

        <a href="<%= request.getContextPath() %>/receptionist/requests" class="back-button">
            <i class="fa fa-arrow-left"></i> Back to Requests List
        </a>

        <div class="room-detail-card">
            <h1 class="card-title-h1">Reply to Request #<%= gr.getRequestId() %></h1>

            <h5 style="font-weight: 600; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                <i class="fa fa-info-circle" style="color: #dfa974;"></i> Guest Request Details
            </h5>
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <label class="form-label"><i class="fa fa-ticket"></i> Booking ID</label>
                    <div class="form-control-plaintext"><%= gr.getBookingId() %></div>
                </div>
                <div class="col-md-3">
                    <label class="form-label"><i class="fa fa-user"></i> User ID</label>
                    <div class="form-control-plaintext"><%= gr.getUserId() %></div>
                </div>
                <div class="col-md-3">
                    <label class="form-label"><i class="fa fa-commenting"></i> Type</label>
                    <div class="form-control-plaintext"><%= gr.getRequestType() %></div>
                </div>
                <div class="col-md-3">
                    <label class="form-label"><i class="fa fa-flag"></i> Status</label>
                    <div>
                        <span class="status-badge <%= badgeClass %>"><%= gr.getStatus() %></span>
                    </div>
                </div>
                <div class="col-12">
                    <label class="form-label"><i class="fa fa-file-text-o"></i> Content</label>
                    <div class="form-control-plaintext" style="min-height: 80px; white-space: pre-wrap;"><%= gr.getContent() %></div>
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fa fa-user-secret"></i> Replied By</label>
                    <div class="form-control-plaintext"><%= gr.getRepliedBy() == null ? "-" : gr.getRepliedBy() %></div>
                </div>
                <div class="col-md-6">
                    <label class="form-label"><i class="fa fa-calendar"></i> Replied At</label>
                    <div class="form-control-plaintext"><%= gr.getRepliedAt() == null ? "-" : gr.getRepliedAt() %></div>
                </div>
            </div>

            <hr style="margin: 30px 0;">

            <h5 style="font-weight: 600; margin-bottom: 20px;">
                <i class="fa fa-reply" style="color: #dfa974;"></i> Receptionist Reply
            </h5>
            <form method="post" action="<%= request.getContextPath() %>/receptionist/requests/send-reply">
                <input type="hidden" name="id" value="<%= gr.getRequestId() %>"/>
                <div class="mb-3">
                        <textarea name="replyText" class="form-control" rows="5"
                                  style="border-radius: 8px; font-size: 1rem;"
                                  placeholder="Enter your reply here..."
                                <%= closed ? "disabled" : "" %>><%= gr.getReplyText() == null ? "" : gr.getReplyText() %></textarea>
                </div>

                <div class="action-buttons">
                    <button type="submit" class="action-btn" <%= closed ? "disabled" : "" %>>
                        <i class="fa fa-send"></i> Send Reply
                    </button>

                    <form method="post" action="<%= request.getContextPath() %>/receptionist/requests/resolve" style="margin: 0;">
                        <input type="hidden" name="id" value="<%= gr.getRequestId() %>"/>
                        <button type="submit" class="action-btn success" <%= closed ? "disabled" : "" %>>
                            <i class="fa fa-check"></i> Mark as Resolved
                        </button>
                    </form>
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
</body>
</html>