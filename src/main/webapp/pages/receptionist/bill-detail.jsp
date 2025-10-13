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
    <title>Bill Detail - 36 Hotel</title>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print-bill.css" type="text/css" media="print">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist-bill-detail.css" type="text/css">
</head>

<body>
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Header Section Begin -->
    <header class="header-section no-print">
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
                                    <li class="active"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                    <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                                    <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                                    <li><a href="#">Pages</a>
                                        <ul class="dropdown">
                                            <li><a href="${pageContext.request.contextPath}/room-details">Room Details</a></li>
                                            <li><a href="${pageContext.request.contextPath}/blog-details">Blog Details</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/blog">News</a></li>
                                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
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
    <section class="receptionist-header no-print">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2>
                        <i class="fa fa-file-text-o"></i>
                        <c:choose>
                            <c:when test="${editMode}">Edit Bill #${billInfo.invoice.invoiceId}</c:when>
                            <c:otherwise>Bill Detail #${billInfo.invoice.invoiceId}</c:otherwise>
                        </c:choose>
                    </h2>
                    <p>
                        <c:choose>
                            <c:when test="${editMode}">Modify bill information and charges</c:when>
                            <c:otherwise>View detailed bill information and print invoice</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Section -->
    <section class="main-content">
        <div class="container">
            <!-- Print Header (only visible when printing) -->
            <div class="print-header print-only" style="display: none;">
                <h1>36 Hotel</h1>
                <div class="company-info">
                    <p>856 Cordia Extension Apt. 356, Lake, United State</p>
                    <p>Phone: (12) 345 67890 | Email: info.colorlib@gmail.com</p>
                </div>
                <div class="invoice-title">INVOICE</div>
                <div class="company-info">
                    Invoice #${billInfo.invoice.invoiceId} | Date: ${billInfo.invoice.issuedDate}
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success no-print">
                    <i class="fa fa-check-circle"></i> ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error no-print">
                    <i class="fa fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <c:if test="${not empty billInfo}">
                <!-- Bill Summary Card -->
                <div class="bill-card">
                    <div class="card-header">
                        <h4><i class="fa fa-info-circle"></i>Bill Summary</h4>
                    </div>
                    <div class="card-body">
                        <div class="bill-summary" style="display: grid !important; grid-template-columns: repeat(3, 1fr) !important; grid-template-rows: repeat(2, auto) !important; gap: 20px !important; width: 100% !important;">
                            <!-- Row 1: Invoice ID, Booking ID, Issue Date -->
                            <div class="summary-item" style="grid-column: 1; grid-row: 1; width: 100%; box-sizing: border-box;">
                                <div class="summary-label">Invoice ID</div>
                                <div class="summary-value">#${billInfo.invoice.invoiceId}</div>
                            </div>
                            <div class="summary-item" style="grid-column: 2; grid-row: 1; width: 100%; box-sizing: border-box;">
                                <div class="summary-label">Booking ID</div>
                                <div class="summary-value">#${billInfo.invoice.bookingId}</div>
                            </div>
                            <div class="summary-item" style="grid-column: 3; grid-row: 1; width: 100%; box-sizing: border-box;">
                                <div class="summary-label">Issue Date</div>
                                <div class="summary-value">
                                    ${billInfo.invoice.issuedDate}
                                </div>
                            </div>
                            <!-- Row 2: Total Amount, Status, Duration -->
                            <div class="summary-item" style="grid-column: 1; grid-row: 2; width: 100%; box-sizing: border-box;">
                                <div class="summary-label">Total Amount</div>
                                <div class="summary-value amount">
                                    <fmt:formatNumber value="${billInfo.invoice.totalAmount}" type="currency" currencySymbol="đ"/>
                                </div>
                            </div>
                            <div class="summary-item" style="grid-column: 2; grid-row: 2; width: 100%; box-sizing: border-box;">
                                <div class="summary-label">Status</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${billInfo.bookingStatus == 'confirmed'}">
                                            <span class="status-badge status-confirmed">Confirmed</span>
                                        </c:when>
                                        <c:when test="${billInfo.bookingStatus == 'pending'}">
                                            <span class="status-badge status-pending">Pending</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-cancelled">Cancelled</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="summary-item" style="grid-column: 3; grid-row: 2; width: 100%; box-sizing: border-box;">
                                <div class="summary-label">Duration</div>
                                <div class="summary-value">${billInfo.durationHours} hours</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customer Information Card -->
                <div class="bill-card">
                    <div class="card-header">
                        <h4><i class="fa fa-user"></i>Customer Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="customer-info" style="display: grid !important; grid-template-columns: repeat(6, 1fr) !important; grid-template-rows: 1fr !important; gap: 15px !important; width: 100% !important;">
                            <div class="info-item" style="grid-column: 1; grid-row: 1; width: 100%; box-sizing: border-box; min-width: 0;">
                                <div class="info-label">Customer Name</div>
                                <div class="info-value">${billInfo.firstName} ${billInfo.middleName != null ? billInfo.middleName : ''} ${billInfo.lastName}</div>
                            </div>
                            <div class="info-item" style="grid-column: 2; grid-row: 1; width: 100%; box-sizing: border-box; min-width: 0;">
                                <div class="info-label">Email</div>
                                <div class="info-value">${billInfo.email}</div>
                            </div>
                            <div class="info-item" style="grid-column: 3; grid-row: 1; width: 100%; box-sizing: border-box; min-width: 0;">
                                <div class="info-label">Phone</div>
                                <div class="info-value">${billInfo.mobilePhone}</div>
                            </div>
                            <div class="info-item" style="grid-column: 4; grid-row: 1; width: 100%; box-sizing: border-box; min-width: 0;">
                                <div class="info-label">Check-in</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${billInfo.checkinTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                            <div class="info-item" style="grid-column: 5; grid-row: 1; width: 100%; box-sizing: border-box; min-width: 0;">
                                <div class="info-label">Check-out</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${billInfo.checkoutTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                            <div class="info-item" style="grid-column: 6; grid-row: 1; width: 100%; box-sizing: border-box; min-width: 0;">
                                <div class="info-label">Discount</div>
                                <div class="info-value">${billInfo.discountPercentage}%</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Room Details Card -->
                <div class="bill-card">
                    <div class="card-header">
                        <h4><i class="fa fa-bed"></i>Room Details</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty roomDetails}">
                                <table class="details-table">
                                    <thead>
                                        <tr>
                                            <th>Room Name</th>
                                            <th>Category</th>
                                            <th>Capacity</th>
                                            <th>Guests</th>
                                            <th>Price</th>
                                            <th>Special Request</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="room" items="${roomDetails}">
                                            <tr>
                                                <td><strong>${room.roomName}</strong></td>
                                                <td>${room.categoryName}</td>
                                                <td>${room.capacity} persons</td>
                                                <td>${room.guestCount} persons</td>
                                                <td>
                                                    <strong style="color: #dfa974;">
                                                        <fmt:formatNumber value="${room.priceAtBooking}" type="currency" currencySymbol="đ"/>
                                                    </strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty room.specialRequest}">
                                                            ${room.specialRequest}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #6b6b6b; font-style: italic;">None</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p style="text-align: center; color: #6b6b6b; padding: 20px;">No room details available.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Service Details Card -->
                <div class="bill-card">
                    <div class="card-header">
                        <h4><i class="fa fa-cutlery"></i>Service Details</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty serviceDetails}">
                                <table class="details-table">
                                    <thead>
                                        <tr>
                                            <th>Service Name</th>
                                            <th>Description</th>
                                            <th>Price</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="service" items="${serviceDetails}">
                                            <tr>
                                                <td><strong>${service.serviceName}</strong></td>
                                                <td>${service.description}</td>
                                                <td>
                                                    <strong style="color: #dfa974;">
                                                        <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="đ"/>
                                                    </strong>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-confirmed">${service.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p style="text-align: center; color: #6b6b6b; padding: 20px;">No additional services.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Bill Charges Card (Edit Mode or View Mode) -->
                <div class="bill-card">
                    <div class="card-header">
                        <h4>
                            <i class="fa fa-calculator"></i>
                            <c:choose>
                                <c:when test="${editMode}">Edit Bill Charges</c:when>
                                <c:otherwise>Bill Breakdown</c:otherwise>
                            </c:choose>
                        </h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${editMode}">
                                <!-- Edit Form -->
                                <form action="${pageContext.request.contextPath}/receptionist/bills" method="post" id="editBillForm">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="invoiceId" value="${billInfo.invoice.invoiceId}">

                                    <!-- Grid Layout for Bill Breakdown -->
                                    <!-- Room Cost row -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                        <label class="form-label" style="font-weight: 600; color: #333; margin: 0;">Room Cost</label>
                                        <input type="number" step="0.01" name="totalRoomCost" class="form-control"
                                               value="${billInfo.invoice.totalRoomCost}" required
                                               style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #f8f9fa; text-align: right;">
                                    </div>

                                    <!-- Service Cost row -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                        <label class="form-label" style="font-weight: 600; color: #333; margin: 0;">Service Cost</label>
                                        <input type="number" step="0.01" name="totalServiceCost" class="form-control"
                                               value="${billInfo.invoice.totalServiceCost}" required
                                               style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #f8f9fa; text-align: right;">
                                    </div>

                                    <!-- Tax Amount row -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                        <label class="form-label" style="font-weight: 600; color: #333; margin: 0;">Tax Amount</label>
                                        <input type="number" step="0.01" name="taxAmount" class="form-control"
                                               value="${billInfo.invoice.taxAmount}" required
                                               style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #f8f9fa; text-align: right;">
                                    </div>

                                    <!-- Total Amount row -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                        <label class="form-label" style="font-weight: 900; color: #000; margin: 0; font-size: 16px;"><b><strong>TOTAL AMOUNT</strong></b></label>
                                        <input type="number" step="0.01" name="totalAmount" class="form-control"
                                               value="${billInfo.invoice.totalAmount}" readonly
                                               style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #dfa974; border-radius: 8px; font-size: 14px; font-weight: 700; background: #dfa974; color: white; text-align: right;">
                                    </div>

                                    <div class="action-buttons">
                                        <button type="submit" class="action-btn success">
                                            <i class="fa fa-save"></i> Save Changes
                                        </button>
                                        <a href="${pageContext.request.contextPath}/receptionist/bills?action=detail&id=${billInfo.invoice.invoiceId}"
                                           class="action-btn secondary">
                                            <i class="fa fa-times"></i> Cancel
                                        </a>
                                    </div>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <!-- View Mode -->
                                <!-- Room Cost row -->
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <label class="form-label" style="font-weight: 600; color: #333; margin: 0;">Room Cost</label>
                                    <input type="text" class="form-control" readonly
                                           value="đ<fmt:formatNumber value='${billInfo.invoice.totalRoomCost}' pattern='#,##0.00'/>"
                                           style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #f8f9fa; color: #333; text-align: right;">
                                </div>

                                <!-- Service Cost row -->
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <label class="form-label" style="font-weight: 600; color: #333; margin: 0;">Service Cost</label>
                                    <input type="text" class="form-control" readonly
                                           value="đ<fmt:formatNumber value='${billInfo.invoice.totalServiceCost}' pattern='#,##0.00'/>"
                                           style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #f8f9fa; color: #333; text-align: right;">
                                </div>

                                <!-- Tax Amount row -->
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <label class="form-label" style="font-weight: 600; color: #333; margin: 0;">Tax Amount</label>
                                    <input type="text" class="form-control" readonly
                                           value="đ<fmt:formatNumber value='${billInfo.invoice.taxAmount}' pattern='#,##0.00'/>"
                                           style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; background: #f8f9fa; color: #333; text-align: right;">
                                </div>

                                <!-- Total Amount row -->
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <label class="form-label" style="font-weight: 900; color: #000; margin: 0; font-size: 16px;"><b><strong>TOTAL AMOUNT</strong></b></label>
                                    <input type="text" class="form-control" readonly
                                           value="đ<fmt:formatNumber value='${billInfo.invoice.totalAmount}' pattern='#,##0.00'/>"
                                           style="width: auto; min-width: 180px; max-width: 250px; padding: 12px 15px; border: 1px solid #dfa974; border-radius: 8px; font-size: 14px; font-weight: 700; background: #dfa974; color: white; text-align: right;">
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Print-only signature section -->
                <div class="signature-section print-only" style="display: none;">
                    <div class="signature-box">
                        <div class="signature-line"></div>
                        <div class="signature-label">Customer Signature</div>
                    </div>
                    <div class="signature-box">
                        <div class="signature-line"></div>
                        <div class="signature-label">Receptionist Signature</div>
                    </div>
                </div>

                <!-- Print-only terms and conditions -->
                <div class="terms-section print-only" style="display: none;">
                    <h6>Terms and Conditions:</h6>
                    <p>1. Payment is due upon receipt of this invoice.</p>
                    <p>2. Late payments may incur additional charges.</p>
                    <p>3. All disputes must be reported within 7 days of invoice date.</p>
                    <p>4. This invoice is computer generated and does not require a signature.</p>
                </div>

                <!-- Action Buttons (View Mode Only) -->
                <c:if test="${not editMode}">
                    <div class="action-buttons no-print">
                        <a href="${pageContext.request.contextPath}/receptionist/bills" class="action-btn secondary">
                            <i class="fa fa-arrow-left"></i> Back to Bills
                        </a>
                        <a href="${pageContext.request.contextPath}/receptionist/bills?action=edit&id=${billInfo.invoice.invoiceId}"
                           class="action-btn primary">
                            <i class="fa fa-edit"></i> Edit Bill
                        </a>
                        <a href="${pageContext.request.contextPath}/receptionist/bills/export-pdf?id=${billInfo.invoice.invoiceId}"
                           class="action-btn primary" target="_blank">
                            <i class="fa fa-file-pdf-o"></i> Export PDF
                        </a>
                    </div>
                </c:if>
            </c:if>

            <!-- Error State -->
            <c:if test="${empty billInfo}">
                <div class="bill-card">
                    <div class="card-body" style="text-align: center; padding: 60px 20px;">
                        <i class="fa fa-exclamation-triangle" style="font-size: 4rem; color: #dc3545; margin-bottom: 20px;"></i>
                        <h4 style="color: #19191a; margin-bottom: 10px;">Bill Not Found</h4>
                        <p style="color: #6b6b6b; margin-bottom: 30px;">The requested bill could not be found or you don't have permission to view it.</p>
                        <a href="${pageContext.request.contextPath}/receptionist/bills" class="action-btn primary">
                            <i class="fa fa-arrow-left"></i> Back to Bills
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </section>

    <!-- Footer Section Begin -->
    <footer class="footer-section no-print">
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
        // Auto-calculate total amount when editing
        document.addEventListener('DOMContentLoaded', function() {
            const editForm = document.getElementById('editBillForm');
            if (editForm) {
                const roomCostInput = editForm.querySelector('input[name="totalRoomCost"]');
                const serviceCostInput = editForm.querySelector('input[name="totalServiceCost"]');
                const taxAmountInput = editForm.querySelector('input[name="taxAmount"]');
                const totalAmountInput = editForm.querySelector('input[name="totalAmount"]');

                function calculateTotal() {
                    const roomCost = parseFloat(roomCostInput.value) || 0;
                    const serviceCost = parseFloat(serviceCostInput.value) || 0;
                    const taxAmount = parseFloat(taxAmountInput.value) || 0;
                    const total = roomCost + serviceCost + taxAmount;
                    totalAmountInput.value = total.toFixed(2);
                }

                // Add event listeners for real-time calculation
                if (roomCostInput) roomCostInput.addEventListener('input', calculateTotal);
                if (serviceCostInput) serviceCostInput.addEventListener('input', calculateTotal);
                if (taxAmountInput) taxAmountInput.addEventListener('input', calculateTotal);

                // Form validation
                editForm.addEventListener('submit', function(e) {
                    const inputs = editForm.querySelectorAll('input[type="number"]');
                    let isValid = true;

                    inputs.forEach(input => {
                        if (parseFloat(input.value) < 0) {
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

        // PDF export functionality
        function exportPdf() {
            const invoiceId = '${billInfo.invoice.invoiceId}';
            window.open('${pageContext.request.contextPath}/receptionist/bills/export-pdf?id=' + invoiceId, '_blank');
        }
    </script>

</body>
</html>
