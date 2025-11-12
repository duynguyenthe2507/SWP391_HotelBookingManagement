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
        .dashboard-wrapper { display: flex; min-height: calc(100vh - 70px); }
        .sidebar h3 { color: #dfa974; text-align: center; margin-bottom: 30px; font-weight: 700; }
        .sidebar a { display: block; color: #fff; padding: 12px 15px; border-radius: 6px; margin-bottom: 8px; text-decoration: none; transition: all 0.3s ease; }
        .sidebar a:hover, .sidebar a.active { background: #dfa974; color: #fff; }
        .dashboard-content { flex: 1; margin-left: 250px; padding: 40px; }
        .logout-link { color: #dfa974 !important; font-weight: bold; text-decoration: none !important; }
        .logout-link:hover { text-decoration: underline !important; }
        .booking-form .form-group label { font-weight: 600; color: #19191a; margin-bottom: 8px;}
        .booking-form .form-control, .booking-form select { border-radius: 8px; border: 1px solid #ced4da; padding: 10px 15px; }
        .booking-form .form-control:focus { border-color: #dfa974; box-shadow: 0 0 0 0.2rem rgba(223, 169, 116, 0.25); }
        .booking-form button[type="submit"] { background-color: #dfa974; border-color: #dfa974; padding: 12px 30px; border-radius: 20px; font-weight: 600; }
        .booking-form button[type="submit"]:hover { background-color: #c8965a; border-color: #c8965a; }

        /* Price Breakdown Styles */
        .price-breakdown {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            border-left: 4px solid #dfa974;
        }
        .price-breakdown h5 {
            color: #19191a;
            font-weight: 700;
            margin-bottom: 15px;
        }
        .price-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px dashed #dee2e6;
        }
        .price-item:last-child {
            border-bottom: none;
            padding-top: 15px;
            margin-top: 10px;
            border-top: 2px solid #dfa974;
        }
        .price-item.total {
            font-size: 18px;
            font-weight: 700;
            color: #dfa974;
        }
        .price-label {
            color: #666;
        }
        .price-value {
            font-weight: 600;
            color: #333;
        }
    </style>
</head>

<body>
<div id="preloder"><div class="loader"></div></div>

<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>

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
                                                <option value="${room.roomId}" data-price="${room.price}">
                                                        ${room.name} (<fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND"/> / night)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Guest Count</label>
                                        <input type="number" class="form-control" name="guestCount" value="1" min="1" required>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>Check-in Date & Time</label>
                                        <input type="datetime-local" class="form-control" name="checkInDate" id="checkInDate" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Check-out Date & Time</label>
                                        <input type="datetime-local" class="form-control" name="checkOutDate" id="checkOutDate" required>
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

                                <!-- Price Breakdown Section -->
                                <div class="col-lg-12">
                                    <div class="price-breakdown">
                                        <h5><i class="fa fa-calculator"></i> Price Breakdown</h5>
                                        <div class="price-item">
                                            <span class="price-label">Room Price / Night:</span>
                                            <span class="price-value" id="roomPriceDisplay">0 VND</span>
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Number of Nights:</span>
                                            <span class="price-value" id="nightsDisplay">0</span>
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Room Subtotal:</span>
                                            <span class="price-value" id="roomSubtotalDisplay">0 VND</span>
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Services:</span>
                                            <span class="price-value" id="servicesDisplay">0 VND</span>
                                        </div>
                                        <div class="price-item total">
                                            <span class="price-label">TOTAL PRICE:</span>
                                            <span class="price-value" id="totalPriceDisplay">0 VND</span>
                                        </div>
                                    </div>

                                    <!-- Hidden input for form submission -->
                                    <input type="hidden" name="priceAtBooking" id="priceAtBooking" value="0">
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
</div>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const roomSelector = document.getElementById('roomSelector');
        const serviceCheckboxes = document.querySelectorAll('.service-checkbox');
        const checkInInput = document.getElementById('checkInDate');
        const checkOutInput = document.getElementById('checkOutDate');
        const priceInput = document.getElementById('priceAtBooking');

        // Display elements
        const roomPriceDisplay = document.getElementById('roomPriceDisplay');
        const nightsDisplay = document.getElementById('nightsDisplay');
        const roomSubtotalDisplay = document.getElementById('roomSubtotalDisplay');
        const servicesDisplay = document.getElementById('servicesDisplay');
        const totalPriceDisplay = document.getElementById('totalPriceDisplay');

        function formatCurrency(value) {
            return new Intl.NumberFormat('vi-VN').format(value) + ' VND';
        }

        function calculateNights() {
            const checkIn = new Date(checkInInput.value);
            const checkOut = new Date(checkOutInput.value);

            if (checkIn && checkOut && checkOut > checkIn) {
                const diffTime = Math.abs(checkOut - checkIn);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                return diffDays;
            }
            return 0;
        }

        function updateTotalPrice() {
            // Get room price
            const selectedRoomOption = roomSelector.options[roomSelector.selectedIndex];
            const roomPrice = parseFloat(selectedRoomOption.getAttribute('data-price')) || 0;

            // Calculate nights
            const nights = calculateNights();

            // Calculate room subtotal
            const roomSubtotal = roomPrice * nights;

            // Calculate services total
            let servicesTotal = 0;
            serviceCheckboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    servicesTotal += parseFloat(checkbox.getAttribute('data-price')) || 0;
                }
            });

            // Calculate grand total
            const grandTotal = roomSubtotal + servicesTotal;

            // Update displays
            roomPriceDisplay.textContent = formatCurrency(roomPrice);
            nightsDisplay.textContent = nights;
            roomSubtotalDisplay.textContent = formatCurrency(roomSubtotal);
            servicesDisplay.textContent = formatCurrency(servicesTotal);
            totalPriceDisplay.textContent = formatCurrency(grandTotal);

            // Update hidden input
            priceInput.value = grandTotal.toFixed(0);
        }

        // Event listeners
        roomSelector.addEventListener('change', updateTotalPrice);
        checkInInput.addEventListener('change', updateTotalPrice);
        checkOutInput.addEventListener('change', updateTotalPrice);
        serviceCheckboxes.forEach(function(checkbox) {
            checkbox.addEventListener('change', updateTotalPrice);
        });

        // Set minimum dates
        checkInInput.addEventListener('change', function() {
            checkOutInput.min = checkInInput.value;

            // Clear check-out if it's before check-in
            if (checkOutInput.value && checkOutInput.value < checkInInput.value) {
                checkOutInput.value = '';
            }
            updateTotalPrice();
        });

        // Initial calculation
        updateTotalPrice();
    });
</script>
</body>
</html>