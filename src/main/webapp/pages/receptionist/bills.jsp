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
<c:set var="pageActive" value="bills"/>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    <div class="dashboard-content">
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Main Content Section -->
    <section class="main-content">
        <div class="container-fluid">
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

            <!-- Alert Messages - Display above table -->
            <c:if test="${not empty success}">
                <div class="alert alert-success-pastel" style="background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <i class="fa fa-check-circle" style="margin-right: 10px; font-size: 18px; color: #28a745;"></i>
                    <span style="flex: 1;">${success}</span>
                    <button type="button" class="close-alert" onclick="this.parentElement.style.display='none'" style="background: none; border: none; font-size: 20px; color: #155724; cursor: pointer; margin-left: 10px; opacity: 0.5;">&times;</button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error" style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <i class="fa fa-exclamation-circle" style="margin-right: 10px; font-size: 18px; color: #dc3545;"></i>
                    <span style="flex: 1;">${error}</span>
                    <button type="button" class="close-alert" onclick="this.parentElement.style.display='none'" style="background: none; border: none; font-size: 20px; color: #721c24; cursor: pointer; margin-left: 10px; opacity: 0.5;">&times;</button>
                </div>
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
                                                <a href="${pageContext.request.contextPath}/receptionist/bills?action=detailBill&id=${bill.invoiceId}"
                                                   class="action-link view">
                                                    <i class="fa fa-eye"></i> View
                                                </a>
                                                <a href="${pageContext.request.contextPath}/receptionist/bills?action=editBill&id=${bill.invoiceId}"
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

                <!-- Pagination Controls -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Bills pagination" style="padding: 10px 20px 20px 20px;">
                        <ul class="pagination" style="margin:0; display:flex; justify-content:center; flex-wrap: wrap;">
                            <li class="page-item ${page == 1 ? 'disabled' : ''}" style="margin: 2px;">
                                <a class="page-link" href="${pageContext.request.contextPath}/receptionist/bills?page=${page - 1}&size=${size}" aria-label="Previous"
                                   style="border-radius: 8px; padding: 8px 12px; border: 1px solid #e5e5e5; color: #19191a; text-decoration: none; display: inline-block;">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == page ? 'active' : ''}" style="margin: 2px;">
                                    <a class="page-link" href="${pageContext.request.contextPath}/receptionist/bills?page=${i}&size=${size}"
                                       style="border-radius: 8px; padding: 8px 12px; text-decoration: none; display: inline-block;">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page == totalPages ? 'disabled' : ''}" style="margin: 2px;">
                                <a class="page-link" href="${pageContext.request.contextPath}/receptionist/bills?page=${page + 1}&size=${size}" aria-label="Next"
                                   style="border-radius: 8px; padding: 8px 12px; border: 1px solid #e5e5e5; color: #19191a; text-decoration: none; display: inline-block;">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                        <div style="margin-top:10px; color:#6b6b6b; font-size: 12px; text-align:center;">
                            Page ${page} of ${totalPages} • Total ${totalItems} bills
                            <span style="margin-left:10px;">|</span>
                            <span style="margin-left:10px;">Per page:</span>
                            <a href="${pageContext.request.contextPath}/receptionist/bills?page=1&size=5" style="margin-left:6px;">5</a>
                            <a href="${pageContext.request.contextPath}/receptionist/bills?page=1&size=10" style="margin-left:6px;">10</a>
                            <a href="${pageContext.request.contextPath}/receptionist/bills?page=1&size=20" style="margin-left:6px;">20</a>
                            <a href="${pageContext.request.contextPath}/receptionist/bills?page=1&size=50" style="margin-left:6px;">50</a>
                        </div>
                    </nav>
                </c:if>
        </div>
    </section>

    <!-- Footer removed to match booking-list.jsp layout -->
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

</body>
</html>