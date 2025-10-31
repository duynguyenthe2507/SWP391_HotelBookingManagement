<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zxx">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Sona Template">
    <meta name="keywords" content="Sona, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Create Bill - 36 Hotel</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

    <!-- Css Styles -->
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist-create-bill.css" type="text/css">
</head>

<body>
<div class="d-flex" style="min-height:100vh;">
  <nav class="sidebar d-flex flex-column col-lg-2 col-md-3 col-3 p-0 min-vh-100" style="background-color: #23242a;">
    <div class="sidebar-sticky flex-grow-1 d-flex flex-column">
      <div class="text-center mt-4 mb-4">
        <div style="font-family: 'Lora', serif; font-style:italic; font-weight:bold; font-size:2em; color:#dfa974; letter-spacing:1px;">Sona.</div>
        <h5 class="font-weight-bold" style="color: #dfa974;">Reception Dashboard</h5>
      </div>
      <ul class="nav flex-column flex-grow-1">
        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/receptionist/receptionist-dashboard.jsp" class="nav-link text-white"><i class="fa fa-tachometer mr-2"></i> Dashboard</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/receptionist/bills" class="nav-link text-white active" style="background-color: #dfa974; font-weight: bold;"><i class="fa fa-file-text-o mr-2"></i> Bills</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/receptionist/room-fees" class="nav-link text-white"><i class="fa fa-dollar mr-2"></i> Room Fees</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/receptionist/bookings" class="nav-link text-white"><i class="fa fa-calendar mr-2"></i> Bookings</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/receptionist/penalties" class="nav-link text-white"><i class="fa fa-gavel mr-2"></i> Penalties</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/receptionist/feedback" class="nav-link text-white"><i class="fa fa-comments mr-2"></i> Feedback</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/receptionist/rooms" class="nav-link text-white"><i class="fa fa-home mr-2"></i> Room List</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/profile" class="nav-link text-white"><i class="fa fa-user mr-2"></i> Profile</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/login" class="nav-link text-white"><i class="fa fa-sign-out mr-2"></i> Logout</a></li>
      </ul>
      <div class="mt-auto mb-3"></div>
    </div>
  </nav>
  <div class="flex-grow-1 d-flex flex-column">
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Header Section Begin -->
    <header class="header-section">
        <div class="top-nav">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6">
                        <ul class="tn-left">
                            <li><i class="fa fa-phone"></i> (12) 345 67890</li>
                            <li><i class="fa fa-envelope"></i> info.colorlib@gmail.com</li>
                        </ul>
                    </div>
                    <div class="col-lg-6">
                        <div class="tn-right">
                            <div class="top-social">
                                <a href="#"><i class="fa fa-facebook"></i></a>
                                <a href="#"><i class="fa fa-twitter"></i></a>
                                <a href="#"><i class="fa fa-tripadvisor"></i></a>
                                <a href="#"><i class="fa fa-instagram"></i></a>
                            </div>
                            <a href="#" class="bk-btn">Booking Now</a>
                            <div class="language-option">
                                <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
                                <span>EN <i class="fa fa-angle-down"></i></span>
                                <div class="flag-dropdown">
                                    <ul>
                                        <li><a href="#">Zi</a></li>
                                        <li><a href="#">Fr</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="menu-item">
            <div class="container">
                <div class="row">
                    <div class="col-lg-2">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home">
                                <img src="${pageContext.request.contextPath}/img/logo.png" alt="">
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-10">
                        <div class="nav-menu">
                            <nav class="mainmenu">
                                <ul>
                                    <li <c:if test="${pageActive eq 'dashboard'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/pages/receptionist/receptionist-dashboard.jsp">Dashboard</a>
                                    </li>
                                    <li <c:if test="${pageActive eq 'bills'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/receptionist/bills">Bills</a>
                                    </li>
                                    <li <c:if test="${pageActive eq 'room-fees'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/receptionist/room-fees">Room Fees</a>
                                    </li>
                                    <li <c:if test="${pageActive eq 'bookings'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/receptionist/bookings">Bookings</a>
                                    </li>
                                    <li <c:if test="${pageActive eq 'penalties'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/receptionist/penalties">Penalties</a>
                                    </li>
                                    <li <c:if test="${pageActive eq 'feedback'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/receptionist/feedback">Feedback</a>
                                    </li>
                                    <li <c:if test="${pageActive eq 'room-list'}">class="active"</c:if>>
                                        <a href="${pageContext.request.contextPath}/receptionist/rooms">Room List</a>
                                    </li>
                                </ul>
                            </nav>
                            <div class="nav-right search-switch">
                                <i class="icon_search"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <!-- Header End -->

    <!-- Professional Header Section -->
    <section class="receptionist-header">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2><i class="fa fa-plus-circle"></i>Create New Bill</h2>
                    <p>Generate invoice for confirmed bookings</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Section -->
    <section class="main-content">
        <div class="container">
            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fa fa-check-circle"></i> ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fa fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <!-- Booking Selection Card -->
            <div class="form-card">
                <div class="card-header">
                    <h4><i class="fa fa-calendar"></i>Select Booking</h4>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty availableBookings}">
                            <p style="color: #6b6b6b; margin-bottom: 20px;">
                                Select a confirmed booking to create a bill. Only bookings without existing invoices are shown.
                            </p>

                            <form id="createBillForm" action="${pageContext.request.contextPath}/receptionist/bills" method="post">
                                <input type="hidden" name="action" value="create">

                                <table class="booking-table">
                                    <thead>
                                        <tr>
                                            <th>Select</th>
                                            <th>Booking ID</th>
                                            <th>Customer</th>
                                            <th>Check-in / Check-out</th>
                                            <th>Room Types</th>
                                            <th>Services Used</th>
                                            <th>Room Cost</th>
                                            <th>Service Cost</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="booking" items="${availableBookings}">
                                            <tr class="booking-row" data-booking-id="${booking.bookingId}"
                                                data-total-price="${booking.totalPrice}"
                                                data-room-cost="${booking.roomCost}"
                                                data-service-cost="${booking.serviceCost}">
                                                <td>
                                                    <input type="radio" name="bookingId" value="${booking.bookingId}"
                                                           class="booking-radio" required>
                                                </td>
                                                <td>
                                                    <strong>#${booking.bookingId}</strong>
                                                </td>
                                                <td>
                                                    <div class="customer-name">${booking.customerName}</div>
                                                    <div class="customer-phone">${booking.customerPhone}</div>
                                                </td>
                                                <td>
                                                    <div class="booking-date">
                                                        <fmt:formatDate value="${booking.checkinTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                    <div class="booking-date">
                                                        <fmt:formatDate value="${booking.checkoutTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="room-types">
                                                        <c:forEach var="room" items="${booking.roomDetails}" varStatus="status">
                                                            ${room.categoryName} ${room.roomName}<c:if test="${!status.last}">, </c:if>
                                                        </c:forEach>
                                                    </div>
                                                    <c:if test="${not empty booking.roomDetails}">
                                                        <div class="room-details-summary">
                                                            <small style="color: #6b6b6b;">
                                                                <c:set var="totalGuests" value="0"/>
                                                                <c:forEach var="room" items="${booking.roomDetails}">
                                                                    <c:set var="totalGuests" value="${totalGuests + room.guestCount}"/>
                                                                </c:forEach>
                                                                ${totalGuests} guests total
                                                            </small>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="services-used">
                                                        <c:choose>
                                                            <c:when test="${not empty booking.serviceDetails}">
                                                                <c:forEach var="service" items="${booking.serviceDetails}" varStatus="status">
                                                                    ${service.serviceName}<c:if test="${!status.last}">, </c:if>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #6b6b6b; font-style: italic;">No services</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="cost-amount">
                                                        <fmt:formatNumber value="${booking.roomCost}" type="currency" currencySymbol="đ"/>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="cost-amount">
                                                        <fmt:formatNumber value="${booking.serviceCost}" type="currency" currencySymbol="đ"/>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="status-badge">${booking.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fa fa-calendar-times-o"></i>
                                <h4>No Available Bookings</h4>
                                <p>All confirmed bookings already have invoices or there are no confirmed bookings available.</p>
                                <a href="${pageContext.request.contextPath}/receptionist/bills" class="action-btn primary">
                                    <i class="fa fa-arrow-left"></i> Back to Bills
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Bill Calculation Card -->
            <c:if test="${not empty availableBookings}">
                <div class="form-card" id="calculationCard" style="display: none;">
                    <div class="card-header">
                        <h4><i class="fa fa-calculator"></i>Bill Calculation</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Room Cost</label>
                                    <input type="number" step="0.01" name="totalRoomCost" class="form-control"
                                           placeholder="0.00" required>
                                    <small style="color: #6b6b6b;">Base room charges for the stay</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Service Cost</label>
                                    <input type="number" step="0.01" name="totalServiceCost" class="form-control"
                                           placeholder="0.00" required>
                                    <small style="color: #6b6b6b;">Additional services and amenities</small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Tax Amount</label>
                                    <input type="number" step="0.01" name="taxAmount" class="form-control"
                                           placeholder="0.00" required>
                                    <small style="color: #6b6b6b;">Applicable taxes and fees</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Total Amount</label>
                                    <input type="number" step="0.01" name="totalAmount" class="form-control"
                                           placeholder="0.00" readonly>
                                    <small style="color: #6b6b6b;">Automatically calculated total</small>
                                </div>
                            </div>
                        </div>

                        <!-- Calculation Summary -->
                        <div class="calculation-section">
                            <h5 style="margin-bottom: 20px; color: #19191a;">
                                <i class="fa fa-receipt"></i> Bill Summary
                            </h5>

                            <div class="calculation-row">
                                <span class="calculation-label">Room Cost:</span>
                                <span class="calculation-value" id="displayRoomCost">đ0.00</span>
                            </div>

                            <div class="calculation-row">
                                <span class="calculation-label">Service Cost:</span>
                                <span class="calculation-value" id="displayServiceCost">đ0.00</span>
                            </div>

                            <div class="calculation-row">
                                <span class="calculation-label">Tax Amount:</span>
                                <span class="calculation-value" id="displayTaxAmount">đ0.00</span>
                            </div>

                            <div class="calculation-row">
                                <span class="calculation-label">Total Amount:</span>
                                <span class="calculation-value" id="displayTotalAmount">đ0.00</span>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <button type="submit" class="action-btn primary" id="createBillBtn" disabled>
                                <i class="fa fa-save"></i> Create Bill
                            </button>
                            <a href="${pageContext.request.contextPath}/receptionist/bills" class="action-btn secondary">
                                <i class="fa fa-times"></i> Cancel
                            </a>
                        </div>
                    </div>
                </div>
                </form>
            </c:if>
        </div>
    </section>

    <!-- Footer Section Begin -->
    <footer class="footer-section">
        <div class="container">
            <div class="footer-text">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="ft-about">
                            <div class="logo">
                                <a href="#">
                                    <img src="${pageContext.request.contextPath}/img/footer-logo.png" alt="">
                                </a>
                            </div>
                            <p>We inspire and reach millions of travelers<br /> across 90 local websites</p>
                            <div class="fa-social">
                                <a href="#"><i class="fa fa-facebook"></i></a>
                                <a href="#"><i class="fa fa-twitter"></i></a>
                                <a href="#"><i class="fa fa-tripadvisor"></i></a>
                                <a href="#"><i class="fa fa-instagram"></i></a>
                                <a href="#"><i class="fa fa-youtube-play"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 offset-lg-1">
                        <div class="ft-contact">
                            <h6>Contact Us</h6>
                            <ul>
                                <li>(12) 345 67890</li>
                                <li>info.colorlib@gmail.com</li>
                                <li>856 Cordia Extension Apt. 356, Lake, United State</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 offset-lg-1">
                        <div class="ft-newslatter">
                            <h6>New latest</h6>
                            <p>Get the latest updates and offers.</p>
                            <form action="#" class="fn-form">
                                <input type="text" placeholder="Email">
                                <button type="submit"><i class="fa fa-send"></i></button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="copyright-option">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7">
                        <ul>
                            <li><a href="#">Contact</a></li>
                            <li><a href="#">Terms of use</a></li>
                            <li><a href="#">Privacy</a></li>
                            <li><a href="#">Environmental Policy</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-5">
                        <div class="co-text"><p>Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a></p></div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <!-- Footer Section End -->
  </div>
</div>

    <!-- Js Plugins -->
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
    <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('=== Bill Creation Page Loaded ===');

            // Check if form exists
            const form = document.getElementById('createBillForm');
            if (!form) {
                console.log('No form found - probably no available bookings');
                return;
            }

            console.log('Form found:', form);

            const bookingRadios = document.querySelectorAll('.booking-radio');
            const calculationCard = document.getElementById('calculationCard');
            const createBillBtn = document.getElementById('createBillBtn');

            console.log('Found elements:', {
                bookingRadios: bookingRadios.length,
                calculationCard: !!calculationCard,
                createBillBtn: !!createBillBtn
            });

            // Form inputs - use document.querySelector instead of form.querySelector
            const roomCostInput = document.querySelector('input[name="totalRoomCost"]');
            const serviceCostInput = document.querySelector('input[name="totalServiceCost"]');
            const taxAmountInput = document.querySelector('input[name="taxAmount"]');
            const totalAmountInput = document.querySelector('input[name="totalAmount"]');

            // Debug: Check if all input fields are found
            console.log('Input fields found:', {
                roomCostInput: !!roomCostInput,
                serviceCostInput: !!serviceCostInput,
                taxAmountInput: !!taxAmountInput,
                totalAmountInput: !!totalAmountInput
            });

            // Display elements
            const displayRoomCost = document.getElementById('displayRoomCost');
            const displayServiceCost = document.getElementById('displayServiceCost');
            const displayTaxAmount = document.getElementById('displayTaxAmount');
            const displayTotalAmount = document.getElementById('displayTotalAmount');

            // Show calculation card when booking is selected
            bookingRadios.forEach((radio, index) => {
                console.log(`Setting up listener for radio ${index + 1}`);

                radio.addEventListener('change', function() {
                    console.log('=== Radio button changed ===');
                    console.log('Checked:', this.checked);

                    if (this.checked) {
                        console.log('Showing calculation card...');

                        // Show calculation card
                        if (calculationCard) {
                            calculationCard.style.display = 'block';
                            setTimeout(() => {
                                calculationCard.scrollIntoView({ behavior: 'smooth' });
                            }, 100);
                        }

                        // Highlight selected row
                        document.querySelectorAll('.booking-row').forEach(row => {
                            row.classList.remove('selected');
                        });
                        const bookingRow = this.closest('.booking-row');
                        if (bookingRow) {
                            bookingRow.classList.add('selected');
                        }

                        // Get booking data from the selected row
                        console.log('Getting data from row:', bookingRow);
                        console.log('Dataset:', bookingRow.dataset);

                        const roomCostRaw = bookingRow.dataset.roomCost;
                        const serviceCostRaw = bookingRow.dataset.serviceCost;
                        const bookingId = bookingRow.dataset.bookingId;

                        console.log('Raw data attributes:', {
                            roomCostRaw: roomCostRaw,
                            serviceCostRaw: serviceCostRaw,
                            bookingId: bookingId
                        });

                        const roomCost = parseFloat(roomCostRaw) || 0;
                        const serviceCost = parseFloat(serviceCostRaw) || 0;

                        console.log('Parsed values:', {
                            roomCost: roomCost,
                            serviceCost: serviceCost
                        });

                        // Auto-fill the calculation fields
                        console.log('Checking input fields...');
                        console.log('roomCostInput:', roomCostInput);
                        console.log('serviceCostInput:', serviceCostInput);
                        console.log('taxAmountInput:', taxAmountInput);

                        if (!roomCostInput || !serviceCostInput || !taxAmountInput) {
                            console.error('ERROR: Input fields not found!', {
                                roomCostInput: !!roomCostInput,
                                serviceCostInput: !!serviceCostInput,
                                taxAmountInput: !!taxAmountInput
                            });
                            alert('Error: Input fields not found. Please refresh the page.');
                            return;
                        }

                        // Set values
                        console.log('Setting input values...');
                        roomCostInput.value = roomCost.toFixed(2);
                        serviceCostInput.value = serviceCost.toFixed(2);

                        // Calculate tax as 10% of subtotal (room + service cost)
                        const subtotal = roomCost + serviceCost;
                        const taxValue = (subtotal * 0.1).toFixed(2);
                        taxAmountInput.value = taxValue;

                        console.log('Values set:', {
                            roomCostInput: roomCostInput.value,
                            serviceCostInput: serviceCostInput.value,
                            taxAmountInput: taxAmountInput.value
                        });

                        // Calculate total
                        calculateTotal();

                        console.log('=== Auto-population complete ===');
                    }
                });
            });

            // Calculate total amount
            function calculateTotal() {
                console.log('Calculating total...');

                if (!roomCostInput || !serviceCostInput || !taxAmountInput || !totalAmountInput) {
                    console.error('Cannot calculate total - input fields missing');
                    return;
                }

                const roomCost = parseFloat(roomCostInput.value) || 0;
                const serviceCost = parseFloat(serviceCostInput.value) || 0;
                const taxAmount = parseFloat(taxAmountInput.value) || 0;
                const total = roomCost + serviceCost + taxAmount;

                console.log('Calculation:', {
                    roomCost: roomCost,
                    serviceCost: serviceCost,
                    taxAmount: taxAmount,
                    total: total
                });

                totalAmountInput.value = total.toFixed(2);

                // Update display
                if (displayRoomCost) displayRoomCost.textContent = 'đ' + roomCost.toFixed(2);
                if (displayServiceCost) displayServiceCost.textContent = 'đ' + serviceCost.toFixed(2);
                if (displayTaxAmount) displayTaxAmount.textContent = 'đ' + taxAmount.toFixed(2);
                if (displayTotalAmount) displayTotalAmount.textContent = 'đ' + total.toFixed(2);

                // Enable/disable create button
                if (createBillBtn) {
                    const hasBookingSelected = document.querySelector('.booking-radio:checked');
                    const hasValidAmounts = roomCost >= 0 && serviceCost >= 0 && taxAmount >= 0 && total > 0;
                    createBillBtn.disabled = !(hasBookingSelected && hasValidAmounts);
                }

                console.log('Total calculated:', total.toFixed(2));
            }

            // Add event listeners for calculation
            if (roomCostInput) {
                roomCostInput.addEventListener('input', calculateTotal);
                serviceCostInput.addEventListener('input', calculateTotal);
                taxAmountInput.addEventListener('input', calculateTotal);
                console.log('Input event listeners added');
            }

            // Make entire row clickable
            document.querySelectorAll('.booking-row').forEach(row => {
                row.addEventListener('click', function(e) {
                    // Don't trigger if clicking the radio button itself
                    if (e.target.type !== 'radio') {
                        const radio = this.querySelector('.booking-radio');
                        if (radio) {
                            radio.checked = true;
                            // Manually trigger the change event
                            radio.dispatchEvent(new Event('change'));
                        }
                    }
                });
            });

            // Form validation
            if (form) {
                form.addEventListener('submit', function(e) {
                    const selectedBooking = document.querySelector('.booking-radio:checked');
                    if (!selectedBooking) {
                        e.preventDefault();
                        alert('Please select a booking to create a bill.');
                        return;
                    }

                    const inputs = form.querySelectorAll('input[type="number"]');
                    let isValid = true;

                    inputs.forEach(input => {
                        if (input.name !== 'totalAmount' && parseFloat(input.value) < 0) {
                            isValid = false;
                            input.style.borderColor = '#dc3545';
                        } else {
                            input.style.borderColor = '#e5e5e5';
                        }
                    });

                    if (!isValid) {
                        e.preventDefault();
                        alert('Please enter valid positive amounts for all fields.');
                    }
                });
            }
        });
    </script>

</body>
</html>
