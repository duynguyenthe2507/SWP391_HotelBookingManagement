<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Details - 36 Hotel</title>

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
        .detail-panel {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
        }
        .detail-panel h3 {
            color: #dfa974;
            margin-bottom: 25px;
            font-weight: 700;
            border-bottom: 2px solid #dfa974;
            padding-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .detail-panel h3 i {
            margin-right: 10px;
        }
        .detail-panel h4 {
            color: #333;
            margin-bottom: 20px;
            font-weight: 600;
            font-size: 18px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .detail-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #555;
            width: 180px;
            flex-shrink: 0;
        }
        .detail-value {
            color: #333;
            flex: 1;
        }
        .room-image-container {
            text-align: center;
            margin: 20px 0;
        }
        .room-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            display: inline-block;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .status-available {
            background-color: #218838;
            color: white;
            font-weight: 800;
        }
        .status-booked {
            background-color: #c82333;
            color: white;
            font-weight: 800;
        }
        .status-maintenance {
            background-color: #e0a800;
            color: #000;
            font-weight: 800;
        }
        .status-pending {
            background-color: #e0a800;
            color: #000;
            font-weight: 800;
        }
        .status-confirmed {
            background-color: #28a745 !important;
            color: white !important;
            font-weight: 800;
        }
        .status-checked-in {
            background-color: #138496;
            color: white;
            font-weight: 800;
        }
        .status-checked-out {
            background-color: #545b62;
            color: white;
            font-weight: 800;
        }
        .status-cancelled {
            background-color: #c82333;
            color: white;
            font-weight: 800;
        }
        .action-buttons {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn-back {
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            background-color: #5a6268;
            color: white;
            text-decoration: none;
        }
        .btn-back i {
            margin-right: 8px;
        }
        .booking-history-table {
            width: 100%;
            margin-top: 15px;
        }
        .booking-history-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .booking-history-table th,
        .booking-history-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .booking-history-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #555;
        }
        .booking-history-table tr:hover {
            background-color: #f9f9f9;
        }
        .booking-history-table .status-badge {
            position: relative;
            z-index: 1;
            opacity: 1 !important;
        }
        .booking-history-table td .status-badge {
            display: inline-block;
        }
        /* Override mạnh cho status badges trong table */
        .booking-history-table td .status-badge {
            opacity: 1 !important;
            filter: none !important;
        }
        .booking-history-table .status-confirmed,
        .booking-history-table td .status-confirmed {
            background: #28a745 !important;
            background-color: #28a745 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .booking-history-table .status-pending,
        .booking-history-table td .status-pending {
            background: #e0a800 !important;
            background-color: #e0a800 !important;
            color: #000000 !important;
            opacity: 1 !important;
        }
        .booking-history-table .status-checked-in,
        .booking-history-table td .status-checked-in {
            background: #138496 !important;
            background-color: #138496 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .booking-history-table .status-checked-out,
        .booking-history-table td .status-checked-out {
            background: #545b62 !important;
            background-color: #545b62 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .booking-history-table .status-cancelled,
        .booking-history-table td .status-cancelled {
            background: #c82333 !important;
            background-color: #c82333 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .no-data i {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
        }
        .current-booking-alert {
            background-color: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .current-booking-alert strong {
            color: #856404;
        }
        /* Override cho status badges trong Current Booking */
        .detail-panel .status-badge {
            opacity: 1 !important;
            filter: none !important;
        }
        .detail-panel .status-confirmed {
            background: #28a745 !important;
            background-color: #28a745 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .detail-panel .status-pending {
            background: #e0a800 !important;
            background-color: #e0a800 !important;
            color: #000000 !important;
            opacity: 1 !important;
        }
        .detail-panel .status-checked-in {
            background: #138496 !important;
            background-color: #138496 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .detail-panel .status-checked-out {
            background: #545b62 !important;
            background-color: #545b62 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
        .detail-panel .status-cancelled {
            background: #c82333 !important;
            background-color: #c82333 !important;
            color: #ffffff !important;
            opacity: 1 !important;
        }
    </style>
</head>

<body>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    
    <div class="dashboard-content">
        <section class="main-content">
            <div class="container-fluid">
                
                <!-- Page Header -->
                <div style="margin-bottom: 30px;">
                    <h2 style="color: #333; font-weight: 700;">
                        <i class="fa fa-bed"></i> Room Details
                    </h2>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fa fa-exclamation-circle"></i> ${error}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>

                <c:if test="${not empty room}">
                    <!-- Room Information Panel -->
                    <div class="detail-panel">
                        <h3><i class="fa fa-info-circle"></i> Room Information</h3>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="detail-row">
                                    <div class="detail-label">Room ID:</div>
                                    <div class="detail-value">#${room.roomId}</div>
                                </div>
                                <div class="detail-row">
                                    <div class="detail-label">Room Name:</div>
                                    <div class="detail-value">${room.name}</div>
                                </div>
                                <div class="detail-row">
                                    <div class="detail-label">Room Type:</div>
                                    <div class="detail-value">${room.category.name}</div>
                                </div>
                                <div class="detail-row">
                                    <div class="detail-label">Price:</div>
                                    <div class="detail-value">
                                        <strong style="color: #dfa974; font-size: 18px;">
                                            <fmt:formatNumber value="${room.price}" pattern="#,##0"/>đ / night
                                        </strong>
                                    </div>
                                </div>
                                <div class="detail-row">
                                    <div class="detail-label">Capacity:</div>
                                    <div class="detail-value">
                                        <i class="fa fa-users"></i> ${room.capacity} guests
                                    </div>
                                </div>
                                <div class="detail-row">
                                    <div class="detail-label">Status:</div>
                                    <div class="detail-value">
                                        <span class="status-badge status-${fn:toLowerCase(room.status)}">
                                            ${room.status}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <c:if test="${not empty room.imgUrl}">
                                    <div class="room-image-container">
                                        <img src="${room.imgUrl}" alt="${room.name}" class="room-image">
                                    </div>
                                </c:if>
                                <c:if test="${empty room.imgUrl}">
                                    <div class="room-image-container">
                                        <div style="padding: 80px; background-color: #f5f5f5; border-radius: 8px; text-align: center;">
                                            <i class="fa fa-image" style="font-size: 64px; color: #ccc;"></i>
                                            <p style="margin-top: 15px; color: #999;">No image available</p>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <c:if test="${not empty room.description}">
                            <div style="margin-top: 25px; padding-top: 25px; border-top: 1px solid #eee;">
                                <h4><i class="fa fa-file-text-o"></i> Description</h4>
                                <p style="color: #666; line-height: 1.6;">${room.description}</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Current Booking Panel (if room is booked) -->
                    <c:if test="${not empty currentBooking}">
                        <div class="detail-panel">
                            <h3><i class="fa fa-calendar-check-o"></i> Current Booking</h3>
                            
                            <div class="current-booking-alert">
                                <strong>This room is currently booked</strong>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Booking ID:</div>
                                <div class="detail-value">#${currentBooking.bookingId}</div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Guest Name:</div>
                                <div class="detail-value">${currentBooking.guestName}</div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Check-in:</div>
                                <div class="detail-value">
                                    <fmt:formatDate value="${currentBooking.checkinTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Check-out:</div>
                                <div class="detail-value">
                                    <fmt:formatDate value="${currentBooking.checkoutTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                            <div class="detail-row">
                                <div class="detail-label">Status:</div>
                                <div class="detail-value">
                                    <span class="status-badge status-${fn:toLowerCase(currentBooking.status)}">
                                        ${currentBooking.status}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/receptionist/booking-details?bookingId=${currentBooking.bookingId}" 
                                   class="btn btn-primary">
                                    <i class="fa fa-eye"></i> View Booking Details
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <!-- Booking History Panel -->
                    <div class="detail-panel">
                        <h3><i class="fa fa-history"></i> Booking History</h3>
                        
                        <c:choose>
                            <c:when test="${not empty bookingHistory}">
                                <div class="booking-history-table">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Guest Name</th>
                                                <th>Check-in</th>
                                                <th>Check-out</th>
                                                <th>Status</th>
                                                <th>Total Price</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookingHistory}">
                                                <tr>
                                                    <td><strong>#${booking.bookingId}</strong></td>
                                                    <td>${booking.guestName}</td>
                                                    <td>
                                                        <fmt:formatDate value="${booking.checkinTime}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${booking.checkoutTime}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(booking.status)}">
                                                            ${booking.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <strong style="color: #333;">
                                                            <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0"/>đ
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/receptionist/booking-details?bookingId=${booking.bookingId}" 
                                                           class="btn btn-sm btn-primary" style="text-decoration: none;">
                                                            <i class="fa fa-eye"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-data">
                                    <i class="fa fa-calendar-times-o"></i>
                                    <p>No booking history available for this room.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/receptionist/rooms" class="btn-back">
                            <i class="fa fa-arrow-left"></i> Back to Room List
                        </a>
                    </div>
                </c:if>

            </div>
        </section>
    </div>
</div>

<!-- JS Plugins -->
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

