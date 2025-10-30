<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Booking Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    <style>
        .detail-section { padding: 40px 0; }
        .detail-card { background: #f9f9f9; padding: 30px; border-radius: 5px; margin-bottom: 30px; }
        .detail-card h4 { margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .detail-card p { margin-bottom: 10px; }
        .detail-card strong { min-width: 150px; display: inline-block; }
        .status-badge { padding: 5px 10px; border-radius: 3px; color: white; font-weight: bold; }
        .status-pending { background-color: orange; }
        .status-confirmed { background-color: blue; }
        .status-checked-in { background-color: green; }
        .status-checked-out { background-color: grey; }
        .status-cancelled { background-color: red; }
        .action-buttons form { display: inline-block; margin-right: 10px; }
    </style>
</head>
<body>
<c:set var="dtFormatter" value="<%= DateTimeFormatter.ofPattern(\"dd/MM/yy HH:mm\") %>" />
<div id="preloder"><div class="loader"></div></div>
<jsp:include page="/common/header.jsp"/>
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
            <div class="row">
                    <%-- Cột Thông tin chính --%>
                <div class="col-lg-8">
                    <div class="detail-card">
                        <h4>Booking Information</h4>
                        <p><strong>Booking ID:</strong> ${details.booking.bookingId}</p>
                        <p><strong>Customer Name:</strong> ${details.customerName}</p>
                        <p><strong>Guest Count:</strong> ${details.booking.guestCount}</p>
                        <p>
                            <strong>Status:</strong>
                            <span class="status-badge status-${details.booking.status}">${details.booking.status}</span>
                        </p>
                        <p><strong>Check-in Time:</strong> ${details.booking.checkinTime.format(dtFormatter)} </p>
                        <p><strong>Check-out Time:</strong> ${details.booking.checkoutTime.format(dtFormatter)} </p>
                        <p><strong>Total Price:</strong> <fmt:formatNumber value="${details.booking.totalPrice}" type="currency" currencyCode="VND"/></p>
                        <p><strong>Special Request:</strong> ${details.booking.specialRequest}</p>
                        <p><strong>Created At:</strong> <fmt:formatDate value="${details.booking.createdAt}" pattern="dd/MM/yyyy HH:mm"/> </p>
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

                    <div class="detail-card action-buttons">
                        <h4>Actions</h4>

                            <%-- Chỉ hiển thị Check-in khi status là Pending hoặc Confirmed --%>
                        <c:if test="${details.booking.status == 'pending' || details.booking.status == 'confirmed'}">
                            <form action="${pageContext.request.contextPath}/receptionist/booking-details" method="post">
                                <input type="hidden" name="action" value="checkin">
                                <input type="hidden" name="bookingId" value="${details.booking.bookingId}">
                                <input type="hidden" name="roomId" value="${details.room.roomId}">
                                <button type="submit" class="btn btn-success">Check-in Guest</button>
                            </form>
                        </c:if>

                            <%-- Chỉ hiển thị Check-out khi status là Checked-in --%>
                        <c:if test="${details.booking.status == 'checked-in'}">
                            <form action="${pageContext.request.contextPath}/receptionist/booking-details" method="post">
                                <input type="hidden" name="action" value="checkout">
                                <input type="hidden" name="bookingId" value="${details.booking.bookingId}">
                                <input type="hidden" name="roomId" value="${details.room.roomId}">
                                <button type="submit" class="btn btn-warning">Check-out & Create Bill</button>
                            </form>
                        </c:if>

                            <%-- Nút Create Bill (có thể hiển thị khi đã check-out hoặc bất cứ lúc nào) --%>
                        <c:if test="${details.booking.status == 'checked-out'}">
                            <form action="${pageContext.request.contextPath}/receptionist/booking-details" method="post">
                                <input type="hidden" name="action" value="createBill">
                                <input type="hidden" name="bookingId" value="${details.booking.bookingId}">
                                <input type="hidden" name="roomId" value="${details.room.roomId}"> <%-- Vẫn cần roomId nếu trang bill cần --%>
                                <button type="submit" class="btn btn-info">View/Create Bill</button>
                            </form>
                        </c:if>

                            <%-- Nút quay lại danh sách --%>
                        <a href="${pageContext.request.contextPath}/receptionist/booking-list" class="btn btn-secondary mt-3">Back to List</a>
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

<jsp:include page="/pages/general/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>