<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath"
       value="${requestScope['jakarta.servlet.forward.servlet_path'] != null ? requestScope['jakarta.servlet.forward.servlet_path'] : request.servletPath}"/>

<style>
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        height: 100vh;
        background-color: #222;
        color: white;
        padding: 30px 20px;
        box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
    }

    .sidebar h3 {
        text-align: center;
        font-weight: bold;
        color: #dfa974;
        margin-bottom: 30px;
        font-size: 24px;
    }

    .sidebar-nav {
        flex-grow: 1;
    }

    .sidebar a {
        display: flex;
        align-items: center;
        color: #fff;
        text-decoration: none;
        font-size: 16px;
        padding: 12px 15px;
        border-radius: 6px;
        transition: all 0.3s ease;
        margin-bottom: 8px;
    }

    .sidebar a i {
        margin-right: 10px;
        font-size: 17px;
    }

    .sidebar a:hover {
        background-color: #dfa974;
        color: #fff;
    }

    .sidebar a.active {
        background-color: #dfa974;
        color: #fff;
        font-weight: bold;
    }

    .sidebar-user-controls {
        padding-top: 10px;
        margin-top: 10px;
        border-top: 1px solid #444;
    }

    .sidebar a.logout-link {
        color: #dfa974;
        font-weight: bold;
    }

    .sidebar a.logout-link:hover {
        background-color: #dc3545;
        color: #fff;
        text-decoration: underline;
    }

    /* Dashboard wrapper và content */
    .dashboard-wrapper {
        display: flex;
        min-height: 100vh;
    }

    .dashboard-content {
        flex: 1;
        margin-left: 250px;
        padding: 40px;
        background-color: #f9f9f9;
    }

    @media (max-width: 768px) {
        .sidebar {
            position: relative;
            width: 100%;
            height: auto;
        }

        .dashboard-content {
            margin-left: 0;
        }

        .sidebar-nav {
            flex-grow: 0;
        }
    }
</style>

<div class="sidebar">
    <h3>Receptionist Panel</h3>

    <div class="sidebar-nav">
        <a href="${contextPath}/receptionist/booking-list"
           class="${currentPath == '/receptionist/booking-list' ? 'active' : ''}">
            <i class="fa fa-home"></i> Booking List
        </a>

        <a href="${contextPath}/receptionist/create-booking"
           class="${currentPath == '/receptionist/create-booking' ? 'active' : ''}">
            <i class="fa fa-calendar-plus-o"></i> Create Booking
        </a>

        <a href="${contextPath}/receptionist/room-fees"
           class="${currentPath == '/receptionist/room-fees' ? 'active' : ''}">
            <i class="fa fa-bed"></i> Room Fees
        </a>

        <a href="${contextPath}/receptionist/bills"
           class="${currentPath == '/receptionist/bills' ? 'active' : ''}">
            <i class="fa fa-file-text-o"></i> Bills
        </a>

        <a href="${contextPath}/receptionist/revenue-report"
           class="${currentPath == '/receptionist/revenue-report' ? 'active' : ''}">
            <i class="fa fa-line-chart"></i> Revenue Report
        </a>

        <a href="${contextPath}/receptionist/rooms"
           class="${currentPath == '/receptionist/rooms' ? 'active' : ''}">
            <i class="fa fa-list"></i> Room Edit
        </a>
        <a href="${contextPath}/guidelines"
           class="${currentPath == '/guidelines' ? 'active' : ''}">
            <i class="fa fa-info-circle"></i> Guidelines
        </a>
        <a href="${contextPath}/rules"
           class="${currentPath == '/rules' ? 'active' : ''}">
            <i class="fa fa-book"></i> Rules
        </a>
    </div>

    <div class="sidebar-user-controls">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <a href="${contextPath}/profile"
                   class="${currentPath == '/profile' ? 'active' : ''}">
                    <i class="fa fa-user"></i>
                        ${sessionScope.loggedInUser.firstName} ${sessionScope.loggedInUser.lastName}
                </a>
                <a href="${contextPath}/login" class="logout-link">
                    <i class="fa fa-sign-out"></i> Logout
                </a>
            </c:when>
            <c:otherwise>
                <a href="${contextPath}/login"
                   class="logout-link ${currentPath == '/login' ? 'active' : ''}">
                    <i class="fa fa-sign-in"></i> Login
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</div>