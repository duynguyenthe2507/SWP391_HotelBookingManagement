<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Booking Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    
    <style>
        .row-full-height {
            display: flex;
            flex-wrap: wrap;
        }
        .col-flex-column {
            display: flex;
            flex-direction: column;
            width: 100%;
        }
        .panel-actions {
            margin-top: auto; 
        }
        .detail-panel {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
        }
        .detail-panel h3 {
            color: #333;
            margin-bottom: 25px;
            font-weight: 700;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        .detail-panel p {
            margin-bottom: 10px;
            font-size: 1rem;
            color: #555;
        }
        .detail-panel p strong {
            color: #333;
            display: inline-block; 
            width: 150px; 
        }
        .room-img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-weight: bold;
            font-size: 11px;
            text-transform: uppercase;
            text-shadow: 1px 1px 1px rgba(0,0,0,0.1);
        }
        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }
        .status-confirmed {
            background-color: #007bff;
            color: white;
        }
        .status-checked-in {
            background-color: #28a745;
            color: white;
        }
        .status-checked-out {
            background-color: #6c757d;
            color: white;
        }
        .status-cancelled {
            background-color: #dc3545;
            color: white;
        }
        .action-buttons button {
            margin-right: 10px;
            min-width: 120px;
        }
        .action-buttons a.btn {
            min-width: 120px;
        }
        .detail-section { padding: 40px 0; }
        .detail-card { background: #f9f9f9; padding: 30px; border-radius: 5px; margin-bottom: 30px; }
        .detail-card h4 { margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .detail-card p { margin-bottom: 10px; }
        .detail-card strong { min-width: 150px; display: inline-block; }
        .status-badge { padding: 5px 10px; border-radius: 3px; color: white; font-weight: bold; }
        .action-buttons form { display: inline-block; margin-right: 10px; }
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            align-items: center; 
            gap: 10px; 
            min-height: 80px; 
        }
        .action-buttons form {
            margin: 0; 
        }
        .action-buttons a.btn {
            margin: 0; 
        }
        .button-row {
            display: flex;
            flex-wrap: wrap;
            align-items: center; 
            gap: 10px; 
        }
        
        .review-box {
            background: #fffaf0;
            border-left: 4px solid #dfa974;
            padding: 20px;
            border-radius: 5px;
        }
        .review-box .rating {
            color: #dfa974;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .review-box p {
            font-style: italic;
            color: #555;
            margin: 0;
            line-height: 1.6;
        }
        /* === KẾT THÚC CSS MỚI === */
        
    </style>
</head>
<body>
<c:set var="dtFormatter" value="<%= DateTimeFormatter.ofPattern(\"dd/MM/yy HH:mm\") %>" />
<div id="preloder"><div class="loader"></div></div>

<jsp:include page="/common/sidebar.jsp"/>

<jsp:include page="/common/breadcrumb.jsp"/>

<section class="detail-section">
    <div class="container">
        <c:if test="${not empty sessionScope.bookingMessage}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                    ${sessionScope.bookingMessage}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <c:remove var="bookingMessage" scope="session" />
            </div>
        </c:if>

        <c:if test="${not empty details}">
            <div class="row row-full-height">
                <div class="col-lg-8">
                    <div class="detail-card">
                        <h4>Booking Information</h4>
                        <p><strong>Booking ID:</strong> ${details.booking.bookingId}</p>
                        <p><strong>Customer Name:</strong> ${details.customerName}</p>
                        <p><strong>Guest Count:</strong> ${details.booking.guestCount}</p>
                        <p>
                            <strong>Status:</strong>
                            <span class="status-badge status-${fn:toLowerCase(details.booking.status)}">${details.booking.status}</span>
                        </p>
                        <p><strong>Check-in Time:</strong> ${details.booking.checkinTime.format(dtFormatter)} </p>
                        <p><strong>Check-out Time:</strong> ${details.booking.checkoutTime.format(dtFormatter)} </p>
                        <p><strong>Total Price:</strong> <fmt:formatNumber value="${details.booking.totalPrice}" type="currency" currencyCode="VND"/></p>
                        <p><strong>Special Request:</strong> ${details.booking.specialRequest}</p>
                        <p><strong>Created At:</strong> ${details.booking.createdAt.format(dtFormatter)} </p>
                        <c:if test="${not empty details.receptionistName}">
                            <p><strong>Created By (Receptionist):</strong> ${details.receptionistName}</p>
                        </c:if>
                    </div>

                    <div class="detail-card">
                        <h4>Services Used</h4>
                        <c:if test="${empty details.services}">
                            <p>No additional services selected.</p>
                        </c:if>
                        <c:if test="${not empty details.services}">
                            <ul>
                                <c:forEach var="service" items="${details.services}">
                                    <li>
                                            ${service.name} (x${service.quantity}) -
                                        <fmt:formatNumber value="${service.priceAtBooking}" type="currency" currencyCode="VND"/>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </div>
                    
                    <!-- === THÊM MỚI: Panel Feedback === -->
                    <div class="detail-card">
                        <h4>Customer Feedback</h4>
                        <c:choose>
                            <c:when test="${not empty details.feedback}">
                                <div class="review-box">
                                    <div class="rating">
                                        <strong>Rating: </strong>
                                        <c:forEach begin="1" end="${details.feedback.rating}">
                                            <i class="fa fa-star"></i>
                                        </c:forEach>
                                        <c:forEach begin="${details.feedback.rating + 1}" end="5">
                                            <i class="fa fa-star-o"></i>
                                        </c:forEach>
                                        (${details.feedback.rating}/5)
                                    </div>
                                    <p>"${details.feedback.content}"</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p>No feedback submitted for this booking.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                </div>

                <%-- Cột Phòng và Actions --%>
                <div class="col-lg-4">
                    <div class="detail-card">
                        <h4>Room Details</h4>
                        <p><strong>Room Name:</strong> ${details.room.name}</p>
                        <p><strong>Category:</strong> ${details.room.category.name}</p>
                        <p><strong>Capacity:</strong> ${details.room.capacity}</p>
                        <p><strong>Price per night:</strong> <fmt:formatNumber value="${details.room.price}" type="currency" currencyCode="VND"/></p>
                        <p><strong>Current Room Status:</strong> ${details.room.status}</p>
                        <img src="${pageContext.request.contextPath}/${details.room.imgUrl}" alt="${details.room.name}" class="img-fluid mt-3">
                    </div>

                    <div class="detail-panel action-buttons panel-actions">
                        <h4>Actions</h4>
                        <div class="button-row">
                                <%-- Nút 1: Check-in --%>
                            <c:if test="${fn:toLowerCase(details.booking.status) == 'pending' || fn:toLowerCase(details.booking.status) == 'confirmed'}">
                                <form action="${pageContext.request.contextPath}/receptionist/booking-details" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="checkin">
                                    <input type="hidden" name="bookingId" value="${details.booking.bookingId}">
                                    <input type="hidden" name="roomId" value="${details.room.roomId}">
                                    <button type="submit" class="btn btn-success">Check-in</button>
                                </form>
                            </c:if>

                                <%-- Nút 2: Check-out --%>
                            <c:if test="${fn:toLowerCase(details.booking.status) == 'checked-in'}">
                                <form action="${pageContext.request.contextPath}/receptionist/booking-details" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="checkout">
                                    <input type="hidden" name="bookingId" value="${details.booking.bookingId}">
                                    <input type="hidden" name="roomId" value="${details.room.roomId}">
                                    <button type="submit" class="btn btn-warning">Check-out</button>
                                </form>
                            </c:if>

                                <%-- Nút 3: View Bill (Hiện khi ĐÃ checkout) --%>
                            <c:if test="${fn:toLowerCase(details.booking.status) == 'checked-out'}">
                                <c:choose>
                                    <c:when test="${not empty details.invoiceId}">
                                       <a href="${pageContext.request.contextPath}/receptionist/bills?action=detailBill&id=${details.invoiceId}" class="btn btn-info">
                                            <i class="fa fa-eye"></i> View Bill Details
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                       <a href="${pageContext.request.contextPath}/receptionist/bills?action=createBill&bookingId=${details.booking.bookingId}" class="btn btn-primary">
                                            <i class="fa fa-plus"></i> Create Bill
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>

                            <%-- Nút 4: Back to List --%>
                            <a href="${pageContext.request.contextPath}/receptionist/booking-list" class="btn btn-secondary">Back to List</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty details}">
            <p>Booking details could not be loaded.</p>
            <a href="${pageContext.request.contextPath}/receptionist/booking-list" class="btn btn-secondary mt-3">Back to List</a>
        </c:if>
    </div>
</section>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>