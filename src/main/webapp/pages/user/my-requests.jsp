<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>My Requests | 36 Hotel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Lora', serif;
            min-height: 100vh;
        }

        /* Hero Header */
        .page-header {
            background: linear-gradient(135deg, rgba(223, 169, 116, 0.95), rgba(200, 150, 90, 0.95)),
            url('${pageContext.request.contextPath}/img/hero/hero-3.jpg') center/cover no-repeat;
            padding: 100px 0 80px;
            color: white;
            text-align: center;
            position: relative;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .page-header h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .page-header p {
            font-size: 18px;
            opacity: 0.95;
        }

        /* Main Container */
        .requests-section {
            padding: 60px 0;
        }

        /* Header Card */
        .requests-header {
            background: white;
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .requests-header h3 {
            margin: 0;
            color: #19191a;
            font-weight: 700;
            font-size: 24px;
        }
        .requests-header h3 i {
            color: #dfa974;
            margin-right: 10px;
        }

        /* Empty State */
        .empty-state {
            background: white;
            border-radius: 15px;
            padding: 80px 40px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .empty-state i {
            font-size: 64px;
            color: #dfa974;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        .empty-state h4 {
            color: #19191a;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .empty-state p {
            color: #888;
            margin-bottom: 30px;
        }

        /* Request Cards */
        .request-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            border-left: 4px solid #dfa974;
        }
        .request-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .request-id {
            font-size: 18px;
            font-weight: 700;
            color: #19191a;
        }
        .request-id i {
            color: #dfa974;
            margin-right: 8px;
        }

        .request-meta {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #666;
            font-size: 14px;
        }
        .meta-item i {
            color: #dfa974;
            width: 18px;
            text-align: center;
        }

        .request-type {
            display: inline-block;
            padding: 6px 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .request-content {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            color: #333;
            line-height: 1.6;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .reply-section {
            border-top: 2px solid #f0f0f0;
            padding-top: 15px;
            margin-top: 15px;
        }
        .reply-label {
            font-weight: 600;
            color: #19191a;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .reply-label i {
            color: #dfa974;
        }
        .reply-text {
            background: #e8f5e9;
            padding: 12px 15px;
            border-radius: 10px;
            color: #2e7d32;
            font-style: italic;
            line-height: 1.6;
        }
        .no-reply {
            color: #999;
            font-style: italic;
        }

        /* Status Badges - Modern */
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .status-badge i {
            font-size: 10px;
        }
        .status-pending {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            color: #856404;
            box-shadow: 0 2px 8px rgba(253, 203, 110, 0.4);
        }
        .status-replied {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            box-shadow: 0 2px 8px rgba(9, 132, 227, 0.4);
        }
        .status-resolved {
            background: linear-gradient(135deg, #55efc4, #00b894);
            color: white;
            box-shadow: 0 2px 8px rgba(0, 184, 148, 0.4);
        }
        .status-cancelled {
            background: linear-gradient(135deg, #dfe6e9, #b2bec3);
            color: #2d3436;
            box-shadow: 0 2px 8px rgba(178, 190, 195, 0.4);
        }

        /* Action Button */
        .btn-cancel {
            padding: 8px 20px;
            background: linear-gradient(135deg, #ff7675, #d63031);
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(214, 48, 49, 0.4);
            background: linear-gradient(135deg, #d63031, #c0392b);
        }

        /* Primary Button (New Request) */
        .primary-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none;
            box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3);
        }
        .primary-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(223, 169, 116, 0.4);
        }

        /* Alert Messages */
        .alert {
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 25px;
            border: none;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        .alert-success {
            background: linear-gradient(135deg, #d1f2eb, #a8e6cf);
            color: #0f5132;
        }
        .alert-success i {
            color: #0f5132;
            margin-right: 10px;
        }

        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 32px;
            }
            .requests-header {
                text-align: center;
            }
            .request-card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp"/>

<section class="page-header">
    <h1><i class="fa fa-list-alt"></i> My Requests</h1>
    <p>Quản lý các yêu cầu của bạn tại khách sạn</p>
</section>

<section class="requests-section">
    <div class="container">

        <%-- Thông báo thành công --%>
        <c:if test="${not empty sessionScope.flash}">
            <div class="alert alert-success">
                <i class="fa fa-check-circle"></i>
                    ${sessionScope.flash}
            </div>
            <c:remove var="flash" scope="session"/>
        </c:if>

        <%-- Header với nút New Request --%>
        <div class="requests-header">
            <h3>
                <i class="fa fa-history"></i>
                Lịch sử yêu cầu
            </h3>
            <a class="primary-btn" href="${pageContext.request.contextPath}/user/requests/create?bookingId=${param.bookingId}">
                <i class="fa fa-plus-circle"></i> New Request
            </a>
        </div>

        <%-- Empty State --%>
        <c:if test="${empty items}">
            <div class="empty-state">
                <i class="fa fa-inbox"></i>
                <h4>Chưa có yêu cầu nào</h4>
                <p>Bạn chưa gửi yêu cầu nào đến khách sạn.<br/>Hãy tạo yêu cầu đầu tiên của bạn!</p>
                <a class="primary-btn" href="${pageContext.request.contextPath}/user/requests/create">
                    <i class="fa fa-plus-circle"></i> Tạo yêu cầu mới
                </a>
            </div>
        </c:if>

        <%-- Request Cards --%>
        <c:forEach var="r" items="${items}">
            <div class="request-card">
                    <%-- Header: ID + Status --%>
                <div class="request-header">
                    <div class="request-id">
                        <i class="fa fa-ticket"></i>
                        Request #${r.requestId}
                    </div>
                    <span class="status-badge <c:out value='${r.status=="pending"?"status-pending":(r.status=="replied"?"status-replied":(r.status=="resolved"?"status-resolved":"status-cancelled"))}'/>">
                        <c:choose>
                            <c:when test="${r.status == 'pending'}"><i class="fa fa-clock-o"></i></c:when>
                            <c:when test="${r.status == 'replied'}"><i class="fa fa-commenting"></i></c:when>
                            <c:when test="${r.status == 'resolved'}"><i class="fa fa-check"></i></c:when>
                            <c:otherwise><i class="fa fa-times"></i></c:otherwise>
                        </c:choose>
                        ${r.status}
                    </span>
                </div>

                    <%-- Meta Info --%>
                <div class="request-meta">
                    <div class="meta-item">
                        <i class="fa fa-bed"></i>
                        <span>Booking #${r.bookingId}</span>
                    </div>
                    <div class="meta-item">
                        <i class="fa fa-tag"></i>
                        <span class="request-type">${r.requestType}</span>
                    </div>
                </div>

                    <%-- Content --%>
                <div class="request-content">
                        ${r.content}
                </div>

                    <%-- Reply Section --%>
                <c:if test="${r.status == 'replied' or r.status == 'resolved'}">
                    <div class="reply-section">
                        <div class="reply-label">
                            <i class="fa fa-reply"></i>
                            Phản hồi từ lễ tân:
                        </div>
                        <div class="reply-text">
                            <c:choose>
                                <c:when test="${not empty r.replyText}">${r.replyText}</c:when>
                                <c:otherwise><span class="no-reply">Chưa có phản hồi chi tiết</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>

                    <%-- Action: Cancel Button --%>
                <c:if test="${r.status == 'pending'}">
                    <div style="margin-top: 15px; text-align: right;">
                        <form method="post" action="${pageContext.request.contextPath}/user/requests/cancel" style="display: inline;">
                            <input type="hidden" name="id" value="${r.requestId}"/>
                            <button type="submit" class="btn-cancel" onclick="return confirm('Bạn có chắc muốn hủy yêu cầu này?')">
                                <i class="fa fa-ban"></i> Cancel Request
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </c:forEach>

    </div>
</section>

<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>