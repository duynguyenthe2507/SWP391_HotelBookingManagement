<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>36 Hotel - Wishlist</title>
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">

    <style>
        .wishlist-table table {
            width: 100%;
            text-align: center;
        }
        .wishlist-table table th {
            text-align: center;
        }
        .action-td .btn {
            margin: 0 5px;
        }
    </style>
</head>

<body>
<div id="preloder">
    <div class="loader"></div>
</div>

<%-- Include Header --%>
<jsp:include page="/common/header.jsp"/>

<%-- Include Breadcrumb --%>
<jsp:include page="/common/breadcrumb.jsp"/>

<section class="wishlist-section spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-10 offset-lg-1">
                <c:if test="${empty wishlistItems}">
                    <div class="text-center">
                        <h3>Your favorites list is empty!</h3>
                        <a href="${pageContext.request.contextPath}/rooms" class="primary-btn mt-5"
                           style="color: black">
                            See room now
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty wishlistItems}">
                    <div class="wishlist-table">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Image</th>
                                <th>Room</th>
                                <th>Price</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${wishlistItems}">
                                <tr style="vertical-align: middle;">
                                    <td><img src="${pageContext.request.contextPath}/${item.roomImgUrl}" alt="" width="170"></td>
                                    <td>
                                        <h5><a href="room-details?roomId=${item.roomId}" style="color: #19191a;">${item.roomName}</a></h5>
                                    </td>
                                    <td class="p-price">
                                        <fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND"/>
                                    </td>
                                    <td class="action-td">
                                        <form action="add-to-cart" method="post" style="display: inline;">
                                            <input type="hidden" name="roomId" value="${item.roomId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn"
                                                    style="background-color: #dfa974; color: white; border: none; font-weight: 700; text-transform: uppercase;">
                                                Add to cart
                                            </button>
                                        </form>

                                        <a href="wishlist?action=remove&wishlistId=${item.wishlistId}" class="btn btn-danger">
                                            Remove
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</section>

<%-- Sửa lại comment cho đúng cú pháp JSP --%>
<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>