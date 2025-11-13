<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking List - Receptionist Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #f9f9f9; font-family: 'Cabin', sans-serif; } 
        .dashboard-wrapper { display: flex; min-height: calc(100vh - 70px); } 
        .dashboard-content { flex: 1; margin-left: 250px; padding: 40px; }
        .sidebar h3 { color: #dfa974; text-align: center; margin-bottom: 30px; font-weight: 700; }
        .sidebar a { display: block; color: #fff; padding: 12px 15px; border-radius: 6px; margin-bottom: 8px; text-decoration: none; transition: all 0.3s ease;}
        .sidebar a:hover, .sidebar a.active { background: #dfa974; color: #fff; } 
        .logout-link { color: #dfa974 !important; font-weight: bold; text-decoration: none !important; }
        .logout-link:hover { text-decoration: underline !important; }
        .header-section { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background-color: #ffffff; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .menu-item { border-bottom: none; }
        .search-filter-section { background: white; border-radius: 15px; padding: 30px; margin-bottom: 30px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); }
        .bills-table { background: white; border-radius: 15px; overflow: hidden; margin-bottom: 40px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); }
        .table-header { background: linear-gradient(135deg, #dfa974 0%, #c8965a 100%); padding: 20px 30px; color: white; }
        .table-header h4 { margin: 0; color: white; font-weight: 600; }
        .table thead th { background: #f8f9fa; color: #19191a; border-bottom: 2px solid #e5e5e5; font-weight: 700; text-transform: uppercase; font-size: 12px; }
        .table tbody td { vertical-align: middle; }
        .pagination .page-item.active .page-link { background: linear-gradient(135deg, #dfa974, #c8965a); border-color: #dfa974; color: white; }
        .pagination .page-link { color: #19191a; border-radius: 8px !important; margin: 0 3px; } 
        .empty-state { text-align: center; padding: 60px 20px; color: #6b6b6b; }
        .empty-state i { font-size: 4rem; color: #dfa974; margin-bottom: 20px; }
        .empty-state h4 { color: #19191a; margin-bottom: 10px; }
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
    </style>
</head>
<body>
<c:set var="dtFormatter" value="<%= DateTimeFormatter.ofPattern(\"dd/MM/yy HH:mm\") %>" />
<div id="preloder"><div class="loader"></div></div>

<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="dashboard-content">
        <div class="search-filter-section">
            <h5><i class="fa fa-search"></i> Search & Filter Bookings</h5>
            <form action="${pageContext.request.contextPath}/receptionist/booking-list" method="get">
                <div class="row">
                    <div class="col-md-5">
                        <input type="text" name="search" class="form-control" placeholder="Search Guest, Room..." value="${searchKeyword}">
                    </div>

                    <div class="col-md-3">
                        <input type="date" name="checkInDate" class="form-control" value="${checkInFilter}" placeholder="Check-in Date">
                    </div>

                    <div class="col-md-2">
                        <select name="status" class="form-control">
                            <option value="">All Statuses</option>
                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="checked-in" ${statusFilter == 'checked-in' ? 'selected' : ''}>Checked-In</option>
                            <option value="checked-out" ${statusFilter == 'checked-out' ? 'selected' : ''}>Checked-Out</option>
                            <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100" style="background-color: #dfa974; border-color: #dfa974;"><i class="fa fa-filter"></i> Filter</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="bills-table">
            <div class="table-header">
                <h4><i class="fa fa-list"></i> Bookings List (${totalItems} total)</h4>
            </div>
            <div class="table-responsive">
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <table class="table table-striped table-hover" style="margin: 0; width: 100%; min-width: 800px;"> <%-- Thêm min-width --%>
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Room</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="entry" items="${bookings}">
                                <c:set var="booking" value="${entry.booking}"/>
                                <tr>
                                    <td>#${booking.bookingId}</td>
                                    <td>${entry.customerName}</td>
                                    <td>${entry.roomName}</td>
                                    <td>${booking.checkinTime.format(dtFormatter)}</td>
                                    <td>${booking.checkoutTime.format(dtFormatter)}</td>
                                    <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencyCode="VND"/></td>
                                    <td>
                                        <span class="status-badge status-${booking.status}">${booking.status}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/receptionist/booking-details?bookingId=${booking.bookingId}"
                                           class="btn btn-sm btn-info" style="background-color: #dfa974; border-color: #dfa974; color: white; margin-right: 5px;">
                                            <i class="fa fa-eye"></i> Details
                                        </a>
                                        <c:if test="${booking.status == 'confirmed' && !bookingsWithInvoice.contains(booking.bookingId)}">
                                            <a href="${pageContext.request.contextPath}/receptionist/bills?action=createBill&bookingId=${booking.bookingId}"
                                               class="btn btn-sm btn-success" style="background-color: #28a745; border-color: #28a745; color: white;">
                                                <i class="fa fa-file-text"></i> Create Bill
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fa fa-calendar-times-o"></i>
                            <h4>No Bookings Found</h4>
                            <p>Try adjusting your search or filter criteria.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${totalPages > 1}">
            <nav aria-label="Bookings pagination" style="padding: 10px 0 20px 0;">
                <ul class="pagination" style="margin:0; display:flex; justify-content:center; flex-wrap: wrap;">
                    <li class="page-item ${page == 1 ? 'disabled' : ''}" style="margin: 2px;">
                        <a class="page-link" href="${pageContext.request.contextPath}/receptionist/booking-list?page=${page - 1}&size=${size}&status=${statusFilter}&checkInDate=${checkInFilter}&search=${searchKeyword}" aria-label="Previous">...</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == page ? 'active' : ''}" style="margin: 2px;">
                            <a class="page-link" href="${pageContext.request.contextPath}/receptionist/booking-list?page=${i}&size=${size}&status=${statusFilter}&checkInDate=${checkInFilter}&search=${searchKeyword}" style=""> ${i} </a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${page == totalPages ? 'disabled' : ''}" style="margin: 2px;">
                        <a class="page-link" href="${pageContext.request.contextPath}/receptionist/booking-list?page=${page + 1}&size=${size}&status=${statusFilter}&checkInDate=${checkInFilter}&search=${searchKeyword}" aria-label="Next">...</a>
                    </li>
                </ul>
                <div style="margin-top:10px; color:#6b6b6b; font-size: 12px; text-align:center;"> Page ${page} of ${totalPages} • Total ${totalItems} bookings </div>
            </nav>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>