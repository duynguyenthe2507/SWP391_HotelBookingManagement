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
    <title>Bill Management - 36 Hotel</title>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist-bills.css" type="text/css">
</head>

<body>
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Offcanvas Menu Section Begin -->
    <div class="offcanvas-menu-overlay"></div>
    <div class="canvas-open">
        <i class="icon_menu"></i>
    </div>
    <div class="offcanvas-menu-wrapper">
        <div class="canvas-close">
            <i class="icon_close"></i>
        </div>
        <div class="search-icon search-switch">
            <i class="icon_search"></i>
        </div>
        <div class="header-configure-area">
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
            <a href="#" class="bk-btn">Booking Now</a>
        </div>
        <nav class="mainmenu mobile-menu">
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
        <div id="mobile-menu-wrap"></div>
        <div class="top-social">
            <a href="#"><i class="fa fa-facebook"></i></a>
            <a href="#"><i class="fa fa-twitter"></i></a>
            <a href="#"><i class="fa fa-tripadvisor"></i></a>
            <a href="#"><i class="fa fa-instagram"></i></a>
        </div>
        <ul class="top-widget">
            <li><i class="fa fa-phone"></i> (12) 345 67890</li>
            <li><i class="fa fa-envelope"></i> info.colorlib@gmail.com</li>
        </ul>
    </div>
    <!-- Offcanvas Menu Section End -->

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
    <section class="receptionist-header">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2><i class="fa fa-file-text-o"></i>Bill Management</h2>
                    <p>Manage customer bills, invoices, and payment records</p>
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

            <!-- Search and Filter Section -->
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/receptionist/bills" method="get" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="search" class="search-input"
                           placeholder="Search by invoice ID, booking ID, customer name or phone..."
                           value="${searchTerm}">
                    <button type="submit" class="search-btn">
                        <i class="fa fa-search"></i> Search
                    </button>
                    <c:if test="${not empty searchTerm}">
                        <a href="${pageContext.request.contextPath}/receptionist/bills" class="action-btn secondary">
                            <i class="fa fa-times"></i> Clear
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/receptionist/bills?action=create" class="action-btn">
                    <i class="fa fa-plus"></i> Create New Bill
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/room-fees" class="action-btn secondary">
                    <i class="fa fa-bed"></i> Room Fees
                </a>
                <button onclick="window.print()" class="action-btn secondary">
                    <i class="fa fa-print"></i> Print List
                </button>
            </div>

            <!-- Pagination Controls -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Bills pagination" style="padding: 10px 20px 0 20px;">
                    <ul class="pagination" style="margin:0; display:flex; justify-content:center; flex-wrap: wrap;">
                        <li class="page-item ${page == 1 ? 'disabled' : ''}" style="margin: 2px;">
                            <a class="page-link" href="${pageContext.request.contextPath}/receptionist/bills?action=${empty searchTerm ? 'list' : 'search'}&search=${searchTerm}&page=${page - 1}&size=${size}" aria-label="Previous"
                               style="border-radius: 8px; padding: 8px 12px; border: 1px solid #e5e5e5; color: #19191a; text-decoration: none; display: inline-block;">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == page ? 'active' : ''}" style="margin: 2px;">
                                <a class="page-link" href="${pageContext.request.contextPath}/receptionist/bills?action=${empty searchTerm ? 'list' : 'search'}&search=${searchTerm}&page=${i}&size=${size}"
                                   style="border-radius: 8px; padding: 8px 12px; border: 1px solid ${i == page ? '#dfa974' : '#e5e5e5'}; background: ${i == page ? 'linear-gradient(135deg, #dfa974, #c8965a)' : 'white'}; color: ${i == page ? 'white' : '#19191a'}; text-decoration: none; display: inline-block;">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${page == totalPages ? 'disabled' : ''}" style="margin: 2px;">
                            <a class="page-link" href="${pageContext.request.contextPath}/receptionist/bills?action=${empty searchTerm ? 'list' : 'search'}&search=${searchTerm}&page=${page + 1}&size=${size}" aria-label="Next"
                               style="border-radius: 8px; padding: 8px 12px; border: 1px solid #e5e5e5; color: #19191a; text-decoration: none; display: inline-block;">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                    <div style="margin-top:10px; color:#6b6b6b; font-size: 12px; text-align:center;">
                        Page ${page} of ${totalPages} • Total ${totalItems} bills
                        <span style="margin-left:10px;">|</span>
                        <span style="margin-left:10px;">Per page:</span>
                        <a href="${pageContext.request.contextPath}/receptionist/bills?action=${empty searchTerm ? 'list' : 'search'}&search=${searchTerm}&page=1&size=10" style="margin-left:6px; ${size == 10 ? 'font-weight:700;color:#c8965a;' : ''}">10</a>
                        <a href="${pageContext.request.contextPath}/receptionist/bills?action=${empty searchTerm ? 'list' : 'search'}&search=${searchTerm}&page=1&size=20" style="margin-left:6px; ${size == 20 ? 'font-weight:700;color:#c8965a;' : ''}">20</a>
                        <a href="${pageContext.request.contextPath}/receptionist/bills?action=${empty searchTerm ? 'list' : 'search'}&search=${searchTerm}&page=1&size=50" style="margin-left:6px; ${size == 50 ? 'font-weight:700;color:#c8965a;' : ''}">50</a>
                    </div>
                </nav>
            </c:if>

            <!-- Bills Table -->
            <div class="bills-table">
                <div class="table-header">
                    <h4><i class="fa fa-list"></i>Bills List</h4>
                </div>

                <c:choose>
                    <c:when test="${not empty bills}">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Bill ID</th>
                                    <th>Customer</th>
                                    <th>Check-in / Check-out</th>
                                    <th>Total Amount</th>
                                    <th>Issue Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="bill" items="${bills}">
                                    <tr>
                                        <td>
                                            <div class="bill-id">#${bill.invoiceId}</div>
                                            <div class="bill-date">Booking #${bill.bookingId}</div>
                                        </td>
                                        <td>
                                            <div class="customer-name">${bill.customerName}</div>
                                            <div class="customer-phone">${bill.customerPhone}</div>
                                        </td>
                                        <td>
                                            <div class="bill-date">
                                                <fmt:formatDate value="${bill.checkinTime}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                            <div class="bill-date">
                                                <fmt:formatDate value="${bill.checkoutTime}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="bill-amount">
                                                <fmt:formatNumber value="${bill.totalAmount}" type="currency" currencySymbol="đ"/>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="bill-date">
                                                <fmt:formatDate value="${bill.issuedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${bill.bookingStatus == 'confirmed'}">
                                                    <span class="status-badge status-confirmed">Confirmed</span>
                                                </c:when>
                                                <c:when test="${bill.bookingStatus == 'pending'}">
                                                    <span class="status-badge status-pending">Pending</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-cancelled">Cancelled</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-links">
                                                <a href="${pageContext.request.contextPath}/receptionist/bills?action=detail&id=${bill.invoiceId}"
                                                   class="action-link view">
                                                    <i class="fa fa-eye"></i> View
                                                </a>
                                                <a href="${pageContext.request.contextPath}/receptionist/bills?action=edit&id=${bill.invoiceId}"
                                                   class="action-link edit">
                                                    <i class="fa fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/receptionist/bills/export-pdf?id=${bill.invoiceId}"
                                                   class="action-link print" target="_blank">
                                                    <i class="fa fa-file-pdf-o"></i> Export PDF
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fa fa-file-text-o"></i>
                            <h4>No Bills Found</h4>
                            <p>
                                <c:choose>
                                    <c:when test="${not empty searchTerm}">
                                        No bills found matching "${searchTerm}". Try a different search term.
                                    </c:when>
                                    <c:otherwise>
                                        No bills have been created yet. Create your first bill to get started.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <a href="${pageContext.request.contextPath}/receptionist/bills?action=create" class="action-btn">
                                <i class="fa fa-plus"></i> Create First Bill
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
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

    <!-- Search model Begin -->
    <div class="search-model">
        <div class="h-100 d-flex align-items-center justify-content-center">
            <div class="search-close-switch"><i class="icon_close"></i></div>
            <form class="search-model-form">
                <input type="text" id="search-input" placeholder="Search here.....">
            </form>
        </div>
    </div>
    <!-- Search model end -->

    <!-- Js Plugins -->
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