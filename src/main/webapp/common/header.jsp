<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="header-section">
    <div class="top-nav">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <ul class="tn-left">
                        <li><i class="fa fa-phone"></i> (84) 359 797 703</li>
                        <li><i class="fa fa-envelope"></i> 36hotel@gmail.com</li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    <%-- === PHẦN ĐIỀU HƯỚNG USER ĐÃ SỬA LẠI === --%>
                    <div class="tn-right">
                        
                        <c:if test="${empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/login" class="user-nav-link">
                                <i class="fa fa-sign-in"></i> Login
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="user-nav-link register-btn">
                                <i class="fa fa-user-plus"></i> Be our member
                            </a>
                        </c:if>
                        
                        <c:if test="${not empty sessionScope.user}">
                            <div class="user-nav-link user-welcome">
                                <a href="${pageContext.request.contextPath}/profile">
                                    <i class="fa fa-user-circle-o"></i> Hi, ${sessionScope.user.firstName}
                                </a>
                            </div>
                            <a href="${pageContext.request.contextPath}/cart" class="user-nav-link">
                                <i class="fa fa-shopping-cart"></i> Cart
                            </a>
                            <a href="${pageContext.request.contextPath}/wishlist" class="user-nav-link">
                                <i class="fa fa-heart-o"></i> Wishlist
                            </a>
                            <a href="${pageContext.request.contextPath}/my-bookings" class="user-nav-link">
                                <i class="fa fa-book"></i> My Bookings
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="user-nav-link">
                                <i class="fa fa-sign-out"></i> Logout
                            </a>
                        </c:if>
                        
                    </div>
                    <%-- === KẾT THÚC SỬA LỖI === --%>
                </div>
            </div>
        </div>
    </div>
    <div class="menu-item">
        <div class="container">
            <%-- === SỬA LỖI CĂN CHỈNH === --%>
            <div class="row" style="align-items: center;">
                <div class="col-lg-2" style="padding: 0; margin-bottom: 0;">
                    <div class="logo" style="padding: 15px 0; margin: 0; text-align: center;">
                        <a href="${pageContext.request.contextPath}/home">
                            <img src="${pageContext.request.contextPath}/img/36x.png" alt="36 Hotel Logo"
                                 style="width: 60px; height: auto; display: block; max-width: 100%; object-fit: contain;
                                 transition: transform 0.3s ease; margin: 0 auto; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);"
                                 onmouseover="this.style.transform = 'scale(1.05)'" onmouseout="this.style.transform = 'scale(1)'">
                        </a>
                    </div>
                </div>
                <div class="col-lg-10">
                    <div class="nav-menu">
                        <nav class="mainmenu">
                            <c:choose>
                                <%-- Menu for Receptionist --%>
                                <c:when test="${not empty pageActive}">
                                    <ul>
                                        <li <c:if test="${pageActive eq 'booking-list'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/receptionist/booking-list">Booking List</a>
                                        </li>
                                        <li <c:if test="${pageActive eq 'create-booking'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/receptionist/create-booking">Create Booking</a>
                                        </li>
                                        <li <c:if test="${pageActive eq 'room-fees'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/receptionist/room-fees">Room Fees</a>
                                        </li>
                                        <li <c:if test="${pageActive eq 'bills'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/receptionist/bills">Bills</a>
                                        </li>
                                        <li <c:if test="${pageActive eq 'rules'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/receptionist/rules">Rules</a>
                                        </li>
                                        <li <c:if test="${pageActive eq 'rooms'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/receptionist/rooms">Rooms</a>
                                        </li>
                                    </ul>
                                </c:when>
                                <%-- Menu for Customer/Guest --%>
                                <c:otherwise>
                                    <ul>
                                        <li <c:if test="${pageContext.request.servletPath eq '/home' or pageContext.request.servletPath eq '/index.jsp'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/home">Home</a>
                                        </li>
                                        <li <c:if test="${pageContext.request.servletPath eq '/rooms'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
                                        </li>
                                        <li <c:if test="${pageContext.request.servletPath eq '/guidelines'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/guidelines">Guidelines</a>
                                        </li>
                                        <li <c:if test="${pageContext.request.servletPath eq '/rules'}">class="active"</c:if>>
                                            <a href="${pageContext.request.contextPath}/rules">Rules</a>
                                        </li>
                                        
                                        <!-- === THÊM MỚI (2/2): Link "My Bookings" cho mobile menu === -->
                                        <c:if test="${not empty sessionScope.user}">
                                             <li <c:if test="${pageContext.request.servletPath eq '/my-bookings'}">class="active"</c:if>
                                                 style="display: none;" class="mobile-only-link">
                                                 <a href="${pageContext.request.contextPath}/my-bookings">My Bookings</a>
                                             </li>
                                        </c:if>
                                        <!-- === KẾT THÚC THÊM MỚI (2/2) === -->
                                        
                                    </ul>
                                </c:otherwise>
                            </c:choose>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<%-- Script logout() (nếu cần) đã được xóa vì chúng ta dùng <a> --%>

<style>
    .mainmenu ul {
        list-style: none;
        margin: 0;
        padding: 0;
        display: flex;
        gap: 20px;
    }

    .mainmenu ul li {
        display: inline-block;
    }

    .mainmenu ul li a {
        display: block;
        padding: 10px 15px;
        border-bottom: 2.5px solid transparent !important;
        background: none;
        color: #222;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.3s ease;
        border-radius: 2px;
    }

    .mainmenu ul li.active a {
        border-bottom: 2.5px solid #dfa974 !important;
        color: #dfa974;
    }

    .mainmenu ul li a:hover {
        color: #dfa974;
        border-bottom-color: #dfa974 !important;
    }

    .bk-btn {
        padding: 8px 20px !important;
        display: inline-block;
        text-decoration: none;
    }

    .top-nav {
        background-color: #f8f9fa;
        padding: 12px 0; 
    }

    .tn-left {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .tn-left li {
        display: inline-block;
        margin-right: 20px;
        color: #666;
        font-size: 14px;
    }

    .tn-left li i {
        margin-right: 5px;
        color: #dfa974;
    }

    .tn-right {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 22px; 
    }

    .top-social a {
        display: inline-block;
        margin-right: 10px;
        color: #666;
        transition: color 0.3s;
    }

    .top-social a:hover {
        color: #dfa974;
    }
    
    @media (min-width: 992px) {
        .mobile-only-link {
            display: none !important;
        }
    }
    
    .user-nav-link {
        color: #666;
        font-size: 18px; 
        text-decoration: none;
        transition: all 0.3s;
        position: relative;
        padding-bottom: 3px; 
        border-bottom: 1px solid transparent; 
    }
    .user-nav-link:hover {
        color: #dfa974;
        text-decoration: none;
        border-bottom-color: #dfa974; 
    }
    .user-nav-link i {
        margin-right: 6px;
        color: #dfa974; 
        font-size: 17px; 
        vertical-align: middle; 
    }
    
    .user-welcome a {
        color: #333; 
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s;
        font-size: 18px; 
    }
    .user-welcome a:hover {
        color: #dfa974;
        text-decoration: none;
    }
    
    .user-nav-link.register-btn {
        font-weight: 600;
        color: #333;
    }
    
</style>