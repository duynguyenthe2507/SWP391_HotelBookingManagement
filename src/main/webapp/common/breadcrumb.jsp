<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="homeName" value="${empty breadcrumbHomeName ? 'Home' : breadcrumbHomeName}" />
<c:set var="homeUrl" value="${empty breadcrumbHomeUrl ? '/home' : breadcrumbHomeUrl}" />

<div class="breadcrumb-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb-text">
                    <h2><c:out value="${pageTitle}" default="Page Title"/></h2>
                    <div class="bt-option">
                        <a href="${pageContext.request.contextPath}${homeUrl}">${homeName}</a>

                        <c:if test="${not empty breadcrumbParentName}">
                            <a href="${pageContext.request.contextPath}${breadcrumbParentUrl}">${breadcrumbParentName}</a>
                        </c:if>

                        <span><c:out value="${currentPage}" default="Current"/></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>