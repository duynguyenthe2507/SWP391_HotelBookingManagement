<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create New Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
</head>
<body>
<div id="preloder"><div class="loader"></div></div>

<jsp:include page="/common/header.jsp"/>

<jsp:include page="/common/breadcrumb.jsp"/>

<section class="booking-section spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <h2 class="mb-4">Create Offline Booking</h2>

                <c:if test="${not empty sessionScope.bookingMessage}">
                    <div class="alert alert-info">
                            ${sessionScope.bookingMessage}
                        <c:remove var="bookingMessage" scope="session" />
                    </div>
                </c:if>

        <form action="${pageContext.request.contextPath}/receptionist/create-booking" method="post" class="booking-form">
            <div class="row">
                <div class="col-lg-6">
                    <div class="form-group">
                        <label>Guest Name</label>
                        <input type="text" class="form-control" name="guestName" required>
                    </div>
                    <div class="form-group">
                        <label>Select Room</label>
                        <select class="form-control" name="roomId" required>
                            <option value="">-- Select an available room --</option>
                            <c:forEach var="room" items="${availableRooms}">
                                <option value="${room.roomId}">${room.name} (<fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND"/>)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Guest Count</label>
                        <input type="number" class="form-control" name="guestCount" value="1" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Price at Booking (VND)</label>
                        <input type="number" class="form-control" name="priceAtBooking" step="1000" required>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="form-group">
                        <label>Check-in Datetime</label>
                        <input type="datetime-local" class="form-control" name="checkInDate" required>
                    </div>
                    <div class="form-group">
                        <label>Check-out Datetime</label>
                        <input type="datetime-local" class="form-control" name="checkOutDate" required>
                    </div>
                    <div class="form-group">
                        <label>Special Request</label>
                        <textarea class="form-control" name="specialRequest" rows="3"></textarea>
                    </div>
                </div>
                <div class="col-lg-12">
                    <hr>
                    <h5>Additional Services</h5>
                    <div class="row">
                        <c:forEach var="service" items="${allServices}">
                            <div class="col-lg-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="serviceIds" value="${service.serviceId}" id="service${service.serviceId}">
                                    <label class="form-check-label" for="service${service.serviceId}">
                                            ${service.name} (<fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND"/>)
                                    </label>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div class="col-lg-12 text-center mt-4">
                    <button type="submit" class="btn" style="background-color: #dfa974; color: white;">Submit Booking</button>
                </div>
            </div>
        </form>
    </div>
    </div>
    </div>
</section>

<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>