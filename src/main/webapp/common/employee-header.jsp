<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="header-section" style="position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background-color: #ffffff; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
    <div class="menu-item" style="border-bottom: none; padding: 10px 0;">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-2 col-md-3">
                    <div class="logo" style="padding: 0;">
                        <a href="${pageContext.request.contextPath}/receptionist/booking-list">
                            <img src="${pageContext.request.contextPath}/img/36x.png" alt="36 Hotel Logo" style="width: 50px; height: auto;">
                        </a>
                    </div>
                </div>
                <%-- Welcome & Profile/Logout --%>
                <div class="col-lg-10 col-md-9 text-right">
                    <div class="receptionist-info" style="color: #19191a; font-weight: 500;">
                        Welcome,
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser}">
                                <span style="color: #dfa974;">${sessionScope.loggedInUser.firstName} ${sessionScope.loggedInUser.lastName}</span>
                                <a href="${pageContext.request.contextPath}/profile" class="bk-btn" style="padding: -1px 0px">
                                    Profile
                                </a>
                                | <a href="${pageContext.request.contextPath}/logout" class="logout-link" style="color: #dc3545; font-weight: bold;">Logout</a>
                            </c:when>
                            <c:otherwise>
                                Guest | <a href="${pageContext.request.contextPath}/login">Login</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
<div style="height: 70px;"></div>