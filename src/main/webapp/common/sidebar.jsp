<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Lấy đường dẫn context --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath" value="${requestScope['jakarta.servlet.forward.servlet_path'] != null ? requestScope['jakarta.servlet.forward.servlet_path'] : request.servletPath}"/>

<div class="sidebar">
    <h3>Receptionist Panel</h3>

    <a href="${contextPath}/receptionist/booking-list"
       class="${currentPath == '/receptionist/booking-list' ? 'active' : ''}">
        <i class="fa fa-home"></i> Booking List
    </a>

    <%-- Link Create Booking --%>
    <a href="${contextPath}/receptionist/create-booking"
       class="${currentPath == '/receptionist/create-booking' ? 'active' : ''}">
        <i class="fa fa-calendar-plus-o"></i> Create Booking
    </a>

    <%-- Link Room Fees Management --%>
    <a href="${contextPath}/receptionist/room-fees"
       class="${currentPath == '/receptionist/room-fees' ? 'active' : ''}">
        <i class="fa fa-bed"></i> Room Fees
    </a>

    <%-- Link Bill Management --%>
    <a href="${contextPath}/receptionist/bills"
       class="${currentPath == '/receptionist/bills' ? 'active' : ''}">
        <i class="fa fa-file-text-o"></i> Bills
    </a>

    <%-- Link Rules --%>
    <a href="${contextPath}/receptionist/rules"
       class="${currentPath == '/receptionist/rules' ? 'active' : ''}">
        <i class="fa fa-book"></i> Manage Rules
    </a>
</div>