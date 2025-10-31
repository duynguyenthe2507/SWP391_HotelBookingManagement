<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="breadcrumb-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb-text">
                    <h2><c:out value="${pageTitle}" default="Page Title"/></h2>
                    <div class="bt-option">
                        <a href="${pageContext.request.contextPath}/home">Home</a>
                        <span><c:out value="${currentPage}" default="Current"/></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>