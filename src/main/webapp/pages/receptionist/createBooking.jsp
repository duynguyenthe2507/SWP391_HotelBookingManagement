<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create New Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #f9f9f9; font-family: 'Cabin', sans-serif; }
        .dashboard-wrapper { display: flex; min-height: calc(100vh - 70px);
        .sidebar { width: 250px; background: #222; color: #fff; padding: 30px 20px; position: fixed; top: 70px; bottom: 0; overflow-y: auto; z-index: 999;}
        .sidebar h3 { color: #dfa974; text-align: center; margin-bottom: 30px; font-weight: 700; }
        .sidebar a { display: block; color: #fff; padding: 12px 15px; border-radius: 6px; margin-bottom: 8px; text-decoration: none; transition: all 0.3s ease; }
        .sidebar a:hover, .sidebar a.active { background: #dfa974; color: #fff; }
        .dashboard-content { flex: 1; margin-left: 250px; /* Đẩy nội dung sang phải */ padding: 40px; }
        .logout-link { color: #dfa974 !important; font-weight: bold; text-decoration: none !important; }
        .logout-link:hover { text-decoration: underline !important; }
        .booking-form .form-group label { font-weight: 600; color: #19191a; margin-bottom: 8px;}
        .booking-form .form-control, .booking-form select { border-radius: 8px; border: 1px solid #ced4da; padding: 10px 15px; }
        .booking-form .form-control:focus { border-color: #dfa974; box-shadow: 0 0 0 0.2rem rgba(223, 169, 116, 0.25); }
        .booking-form button[type="submit"] { background-color: #dfa974; border-color: #dfa974; padding: 12px 30px; border-radius: 20px; font-weight: 600; }
        .booking-form button[type="submit"]:hover { background-color: #c8965a; border-color: #c8965a; }
    </style>
</head>
<body>
<div id="preloder"><div class="loader"></div></div>

<jsp:include page="/common/employee-header.jsp"/>

<div class="dashboard-wrapper">
    <jsp:include page="/common/SideBar.jsp"/>

    <div class="dashboard-content">
        <section class="booking-section">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12">
                        <h2 class="mb-4"><i class="fa fa-calendar-plus-o"></i> Create Offline Booking</h2>

                        <c:if test="${not empty sessionScope.bookingMessage}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                    ${sessionScope.bookingMessage}
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                                <c:remove var="bookingMessage" scope="session" />
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/receptionist/create-booking" method="post" class="booking-form bg-white p-4 rounded shadow-sm">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>Guest Name</label>
                                        <input type="text" class="form-control" name="guestName" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Select Room</label>
                                        <select class="form-control" name="roomId" id="roomSelector" required>
                                            <option value="" data-price="0">-- Select an available room --</option>
                                            <c:forEach var="room" items="${availableRooms}">
                                                <option value="${room.roomId}" data-price="${room.price}">${room.name} (<fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND"/>)</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Guest Count</label>
                                        <input type="number" class="form-control" name="guestCount" value="1" min="1" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Price at Booking (VND)</label>
                                        <input type="number" class="form-control" name="priceAtBooking" id="priceAtBooking" step="1000" required readonly>
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
                                <div class="col-lg-12 mt-3">
                                    <hr>
                                    <h5>Additional Services</h5>
                                    <div class="row">
                                        <c:forEach var="service" items="${allServices}">
                                        <div class="col-lg-4 col-md-6">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input service-checkbox" type="checkbox" name="serviceIds"
                                                       value="${service.serviceId}" id="service${service.serviceId}" data-price="${service.price}">

                                                <label class="form-check-label" for="service${service.serviceId}">
                                                    ${service.name} (<fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND"/>)
                                                </label>
                                            </div>
                                        </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="col-lg-12 text-center mt-4">
                                    <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> Submit Booking</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div> <%-- End dashboard-wrapper --%>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const roomSelector = document.getElementById('roomSelector');
        const serviceCheckboxes = document.querySelectorAll('.service-checkbox');
        const priceInput = document.getElementById('priceAtBooking');

        function updateTotalPrice() {
            let total = 0;

            // Lấy giá phòng
            const selectedRoomOption = roomSelector.options[roomSelector.selectedIndex];
            const roomPrice = parseFloat(selectedRoomOption.getAttribute('data-price')) || 0;
            total += roomPrice;

            // Cộng giá các dịch vụ được chọn
            serviceCheckboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    const servicePrice = parseFloat(checkbox.getAttribute('data-price')) || 0;
                    total += servicePrice;
                }
            });

            // Cập nhật vào ô input
            priceInput.value = total.toFixed(0); // Làm tròn đến 0 số thập phân cho VND
        }

        // Gán sự kiện
        roomSelector.addEventListener('change', updateTotalPrice);
        serviceCheckboxes.forEach(function(checkbox) {
            checkbox.addEventListener('change', updateTotalPrice);
        });

        // Tính tổng tiền lần đầu khi tải trang
        updateTotalPrice();

        const checkInInput = document.querySelector('input[name="checkInDate"]');
        const checkOutInput = document.querySelector('input[name="checkOutDate"]');

        checkInInput.addEventListener('change', function() {
            // Đặt ngày check-out tối thiểu là ngày check-in
            checkOutInput.min = checkInInput.value;

            // Nếu ngày check-out hiện tại sớm hơn thì xoá nó
            if (checkOutInput.value && checkOutInput.value < checkInInput.value) {
                checkOutInput.value = '';
            }
        });
    });
</script>
</body>
</html>