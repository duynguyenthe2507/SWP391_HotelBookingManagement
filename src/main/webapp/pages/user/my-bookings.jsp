<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en"> <%-- Changed lang to "en" --%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>36 Hotel - My Bookings</title> <%-- Translated Title --%>
    
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    
    <style>
        .bookings-container { max-width: 960px; margin: 40px auto; padding: 20px; }
        .booking-card {
            display: flex;
            background: #ffffff;
            border: 1px solid #eee;
            border-radius: 8px;
            margin-bottom: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .booking-card:hover {
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
            transform: translateY(-3px);
        }
        .booking-img {
            flex: 0 0 200px; /* Chiều rộng cố định 200px */
        }
        .booking-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .booking-details {
            flex: 1;
            padding: 20px 25px;
            display: flex;
            flex-direction: column;
        }
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .booking-header h4 {
            font-size: 20px;
            font-weight: 700;
            color: #333;
            margin: 0;
        }
        .booking-status {
            font-size: 14px;
            font-weight: 600;
            padding: 5px 12px;
            border-radius: 20px;
            color: white;
            white-space: nowrap;
            text-transform: capitalize; /* Tự động viết hoa chữ cái đầu */
        }
        /* Các màu trạng thái */
        .status-confirmed { background-color: #28a745; } /* Xanh lá */
        .status-pending { background-color: #ffc107; color: #333; } /* Vàng */
        .status-cancelled { background-color: #dc3545; } /* Đỏ */
        .status-checked-in { background-color: #007bff; } /* Xanh dương */
        .status-checked-out { background-color: #6c757d; } /* Xám */

        .booking-info {
            font-size: 15px;
            color: #555;
            line-height: 1.7;
        }
        .booking-info p { margin-bottom: 8px; }
        .booking-info strong {
            color: #333;
            min-width: 110px;
            display: inline-block;
        }
        .booking-footer {
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
            
            /* === SỬA ĐỔI: Dùng flexbox để căn chỉnh nút === */
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .booking-footer h5 {
            font-size: 18px;
            font-weight: 700;
            color: #dfa974;
            margin: 0; /* Thêm vào */
        }
        
        /* === THÊM MỚI: CSS cho nút xem chi tiết === */
        .btn-view-details {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            color: #333;
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-view-details:hover {
            background-color: #dfa974;
            color: white;
            border-color: #dfa974;
            text-decoration: none;
        }
        /* === KẾT THÚC THÊM MỚI === */
        
        .no-bookings {
            text-align: center;
            padding: 50px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .no-bookings h3 { font-size: 22px; color: #333; margin-bottom: 20px; }
        .no-bookings .btn-primary { 
            background-color: #dfa974; 
            color: white; 
            text-decoration: none; 
            padding: 12px 25px; 
            border-radius: 4px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .no-bookings .btn-primary:hover { background-color: #c7956d; }
        
        @media (max-width: 767px) {
            .booking-card { flex-direction: column; }
            .booking-img { width: 100%; height: 200px; flex: auto; }
            .booking-header { flex-direction: column; }
            .booking-status { margin-top: 10px; }
            .booking-footer { text-align: left; margin-top: 15px; }
            /* Sửa cho di động */
            .btn-view-details { margin-top: 10px; text-align: center; display: block;}
            .booking-footer { flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp"/>

    <div class="breadcrumb-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb-text">
                        <h2>My Bookings</h2> <%-- Translated --%>
                        <div class="bt-option">
                            <a href="${pageContext.request.contextPath}/home">Home</a>
                            <span>Booking History</span> <%-- Translated --%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container bookings-container">

        <c:choose>
            <%-- Case 1: User has bookings --%>
            <c:when test="${not empty requestScope.bookingList}">
                <c:forEach var="item" items="${requestScope.bookingList}">
                    <c:set var="booking" value="${item.booking}" />
                    <div class="booking-card">
                        
                        <!-- Room Image -->
                        <div class="booking-img">
                            <c:set var="imgSrc" value="${not empty item.roomImgUrl ? pageContext.request.contextPath.concat('/').concat(item.roomImgUrl) : pageContext.request.contextPath.concat('/img/placeholder.jpg')}"/>
                            <img src="${imgSrc}" 
                                 alt="${item.roomName}"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';">
                        </div>
                        
                        <!-- Booking Details -->
                        <div class="booking-details">
                            <div class="booking-header">
                                <h4>${item.roomName}</h4>
                                <span class="booking-status status-${booking.status}">
                                    <c:choose>
                                        <c:when test="${booking.status == 'confirmed'}">Confirmed</c:when>
                                        <c:when test="${booking.status == 'pending'}">Pending</c:when>
                                        <c:when test="${booking.status == 'cancelled'}">Cancelled</c:when>
                                        <c:when test="${booking.status == 'checked-in'}">Checked-In</c:when>
                                        <c:when test="${booking.status == 'checked-out'}">Checked-Out</c:when>
                                        <c:otherwise>${booking.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="booking-info">
                                <p><strong>Order ID:</strong> #${booking.bookingId}</p>
                                <p><strong>Check-in:</strong> 
                                    ${booking.checkinTime.format(myDateFormatter)}
                                </p>
                                <p><strong>Check-out:</strong> 
                                    ${booking.checkoutTime.format(myDateFormatter)}
                                </p>
                            </div>

                            <div class="booking-footer">
                                <h5>Total Price: <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0"/> VND</h5>
                                
                                <a href="${pageContext.request.contextPath}/room-details?roomId=${booking.roomId}" class="btn-view-details">
                                    View Room Details
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>

            <%-- Case 2: No bookings --%>
            <c:otherwise>
                <div class="no-bookings">
                    <h3>You have no bookings yet.</h3>
                    <p style="margin-bottom: 30px; color: #666;">Feel free to explore our amazing rooms!</p>
                    <a href="${pageContext.request.contextPath}/rooms" class="btn-primary">Find a Room</a>
                </div>
            </c:otherwise>
        </c:choose>
        
        <%-- Handle errors from Controller --%>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger" style="margin-top: 20px;">
                <strong>Error:</strong> ${requestScope.errorMessage}
            </div>
        </c:if>

    </div>

    <jsp:include page="/common/footer.jsp"/>

    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>