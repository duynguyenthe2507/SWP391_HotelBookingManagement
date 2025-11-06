<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="description" content="36 Hotel Rooms List">
        <meta name="keywords" content="Hotel, Rooms, List, Booking">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>36 Hotel - Our Rooms</title>

        <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

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

        <style>
            .filter-form {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 30px;
                padding: 25px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background-color: #ffffff;
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }
            .filter-form .form-group {
                display: flex;
                flex-direction: column;
            }
            .filter-form label {
                font-weight: bold;
                margin-bottom: 8px;
                display: block;
                color: #333;
                font-size: 0.95em;
            }
            .filter-form input[type="text"],
            .filter-form input[type="number"],
            .filter-form select {
                padding: 10px 12px;
                border: 1px solid #d0d0d0;
                border-radius: 5px;
                width: 100%;
                box-sizing: border-box;
                font-size: 1em;
                color: #555;
                transition: border-color 0.3s;
                height: 46px;
            }
            .filter-form input.date-input {
                position: relative;
                background-color: #fff;
            }
            .filter-form .form-group-button {
                align-self: flex-end;
            }
            .filter-form button[type="submit"] {
                background-color: #dfa974;
                color: white;
                cursor: pointer;
                border: none;
                padding: 12px 20px;
                border-radius: 5px;
                font-size: 1em;
                font-weight: 600;
                transition: background-color 0.3s;
                margin-top: 29px;
                height: 46px;
                width: 100%;
            }
            .filter-form button[type="submit"]:hover {
                background-color: #c78d59;
            }
            .pagination {
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #eee;
                text-align: center;
            }
            .pagination a, .pagination span {
                display: inline-block;
                padding: 10px 15px;
                margin: 0 5px;
                border: 1px solid #ddd;
                border-radius: 5px;
                text-decoration: none;
                color: #666;
                font-weight: 600;
                transition: all 0.3s;
            }
            .pagination a:hover {
                background-color: #dfa974;
                color: white;
                border-color: #dfa974;
            }
            .pagination .current-page {
                background-color: #dfa974;
                color: white;
                border-color: #dfa974;
                pointer-events: none;
            }
            .pagination .disabled {
                color: #aaa;
                cursor: not-allowed;
                background-color: #f8f8f8;
            }
            .pagination span:not(.current-page):not(.disabled) {
                padding: 10px 8px;
                margin: 0 5px;
                color: #999;
                font-weight: normal;
            }
            .alert-warning, .alert-danger {
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid transparent;
                border-radius: 4px;
            }
            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }
            .alert-warning {
                color: #856404;
                background-color: #fff3cd;
                border-color: #ffeeba;
            }
            .room-item .ri-text table {
                width: 100%;
                margin-bottom: 15px;
                border-collapse: collapse;
            }
            .room-item .ri-text table td {
                padding: 8px 0;
                border-bottom: 1px dotted #e0e0e0;
                text-align: left;
                font-size: 0.9em;
            }
            .room-item .ri-text table td.r-o {
                width: 40%;
                font-weight: bold;
                color: #555;
            }
            .room-item .ri-text table tr:last-child td {
                border-bottom: none;
            }
            .room-item .primary-btn {
                display: inline-block;
                margin-top: 15px;
            }
            .room-item .ri-text .room-detail-btn {
                margin-right: 15px;
            }
            .header-divider {
                width: 100%;
                height: 1px;
                background-color: #e0e0e0;
                margin: 0 auto;
            }
            /* DEBUG BOX */
            .debug-box {
                background: #f0f8ff;
                border: 1px solid #b0e0e6;
                padding: 10px;
                margin: 15px 0;
                font-family: monospace;
                font-size: 13px;
                color: #006400;
            }
            .room-item-wrapper {
                height: 100%; /* Ensures the card wrapper fills the column height */
            }
            .room-item-card {
                height: 100%;
                display: flex;
                flex-direction: column; /* Arranges card content vertically */
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .room-item-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            }
            .room-item-card .card-img-top {
                width: 100%;
                height: 250px; /* Fixed height for all images */
                object-fit: cover; /* Prevents image stretching */
            }
            .room-item-card .card-body {
                display: flex;
                flex-direction: column;
                flex-grow: 1; /* Makes the card body fill remaining space */
            }
            .room-item-card .card-title {
                font-family: 'Lora', serif;
            }
            .room-item-card .room-price {
                font-size: 1.5rem;
                font-weight: 700;
                color: #dfa974;
                margin-bottom: 15px;
            }
            .room-item-card .room-info {
                font-size: 0.9em;
                color: #6c757d;
            }
            .room-item-card .card-actions {
                margin-top: auto; /* Pushes buttons to the bottom */
                display: flex;
                gap: 5px; /* Space between buttons */
            }
            .room-item-card .card-actions .btn,
            .room-item-card .card-actions form {
                flex: 1; /* Make buttons share space */
            }
            .room-item-card .card-actions .btn,
            .room-item-card .card-actions button {
                width: 100%;
                font-size: 12px;
                padding: 8px 5px;
                text-transform: uppercase;
                font-weight: 600;
            }
            .room-item-card .card-actions .btn-wishlist {
                flex-grow: 0; /* Stop wishlist button from growing */
                flex-basis: 45px; /* Give it a fixed width */
            }
        </style>
    </head>

    <body>
        <div id="preloder">
            <div class="loader"></div>
        </div>

        <jsp:include page="/common/header.jsp" />
        <jsp:include page="/common/breadcrumb.jsp" />

        <section class="rooms-section spad">
            <div class="container">


                <c:if test="${not empty requestScope.errorMessage || not empty requestScope.dateError}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${requestScope.errorMessage}"/><c:out value="${requestScope.dateError}"/>
                    </div>
                </c:if>

                <c:if test="${not empty sessionScope.cartMessage}">
                    <div class="alert ${sessionScope.cartMessageType == 'ERROR' ? 'alert-danger' : (sessionScope.cartMessageType == 'WARNING' ? 'alert-warning' : 'alert-success')}" role="alert">
                        <c:out value="${sessionScope.cartMessage}"/>
                    </div>
                    <% session.removeAttribute("cartMessage"); %>
                    <% session.removeAttribute("cartMessageType"); %>
                </c:if>

                <form action="${pageContext.request.contextPath}/rooms" method="GET" class="filter-form">
                    <div class="form-group">
                        <label for="search">Search:</label>
                        <input type="text" id="search" name="search" value="${fn:escapeXml(param.search)}" placeholder="Room name...">
                    </div>
                    <div class="form-group">
                        <label for="category">Room Type:</label>
                        <select id="category" name="categoryId" class="nice-select-custom">
                            <option value="">All Types</option>
                            <c:forEach var="cat" items="${requestScope.categories}">
                                <option value="${cat.categoryId}" ${cat.categoryId == param.categoryId ? 'selected' : ''}>
                                    <c:out value="${cat.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="minPrice">Price From:</label>
                        <input type="number" id="minPrice" name="minPrice" value="${fn:escapeXml(param.minPrice)}" placeholder="Min price..." min="0">
                    </div>
                    <div class="form-group">
                        <label for="maxPrice">Price To:</label>
                        <input type="number" id="maxPrice" name="maxPrice" value="${fn:escapeXml(param.maxPrice)}" placeholder="Max price..." min="0">
                    </div>
                    <div class="form-group">
                        <label for="minCapacity">Min Capacity:</label>
                        <input type="number" id="minCapacity" name="minCapacity" value="${fn:escapeXml(param.minCapacity)}" placeholder="Guests..." min="1">
                    </div>
                    <div class="form-group">
                        <label for="date-in">Check In:</label>
                        <input type="text" class="date-input" id="date-in" name="checkInDate" value="${fn:escapeXml(param.checkInDate)}" placeholder="dd/mm/yyyy">
                    </div>
                    <div class="form-group">
                        <label for="date-out">Check Out:</label>
                        <input type="text" class="date-input" id="date-out" name="checkOutDate" value="${fn:escapeXml(param.checkOutDate)}" placeholder="dd/mm/yyyy">
                    </div>

                    <div class="form-group form-group-button">
                        <button type="submit">Filter Rooms</button>
                    </div>
                </form>

                <div class="row">
                    <c:choose>
                        <c:when test="${not empty requestScope.rooms}">
                            <c:forEach var="room" items="${requestScope.rooms}">
                                <div class="col-lg-4 col-md-6">
                                    <div class="room-item">
                                        <c:set var="imgSrc" value="${not empty room.imgUrl ? pageContext.request.contextPath.concat('/').concat(room.imgUrl) : pageContext.request.contextPath.concat('/img/placeholder.jpg')}"/>
                                        <img src="${imgSrc}"
                                             alt="${room.name}"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';"
                                             style="width:100%; height:250px; object-fit: cover;">
                                        <div class="ri-text">
                                            <h4><c:out value="${room.name}"/></h4>
                                            <h3>
                                                <fmt:formatNumber value="${room.price}" pattern="#,##0"/> VND
                                                <span>/Pernight</span>
                                            </h3>   
                                            <table>
                                                <tbody>
                                                    <tr>
                                                        <td class="r-o">Type:</td>
                                                        <td><strong><c:out value="${room.category.name}"/></strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="r-o">Capacity:</td>
                                                        <td>Max <c:out value="${room.capacity}"/> person(s)</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="r-o">Status:</td>
                                                        <td><c:out value="${room.status}"/></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <c:url value="/room-details" var="detailsUrl">
                                                <c:param name="roomId" value="${room.roomId}"/>
                                            </c:url>
                                            <a href="${detailsUrl}" class="primary-btn room-detail-btn">More Details</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-lg-12">
                                <p class="text-center" style="font-size: 1.2em; margin-top: 30px;">
                                    No rooms were found matching your search criteria.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    
                    <div class="col-lg-12">
                         <div class="col-lg-12">
                        <div class="room-pagination pagination">
                            <c:url var="basePageUrl" value="/rooms">
                                <c:param name="search" value="${param.search}"/>
                                <c:param name="categoryId" value="${param.categoryId}"/>
                                <c:param name="minPrice" value="${param.minPrice}"/>
                                <c:param name="maxPrice" value="${param.maxPrice}"/>
                                <c:param name="minCapacity" value="${param.minCapacity}"/>
                                <c:param name="checkInDate" value="${param.checkInDate}"/>
                                <c:param name="checkOutDate" value="${param.checkOutDate}"/>
                                <c:param name="statusFilter" value="${param.statusFilter}"/>
                            </c:url>

                            <c:if test="${requestScope.currentPage > 1}">
                                <a href="${basePageUrl}&page=${requestScope.currentPage - 1}">&laquo; Before</a>
                            </c:if>
                            <c:if test="${requestScope.currentPage <= 1}">
                                <span class="disabled">&laquo; Before</span>
                            </c:if>

                            <c:forEach var="i" begin="1" end="${requestScope.noOfPages}">
                                <c:choose>
                                    <c:when test="${i == requestScope.currentPage}">
                                        <span class="current-page">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${basePageUrl}&page=${i}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${requestScope.currentPage < requestScope.noOfPages}">
                                <a href="${basePageUrl}&page=${requestScope.currentPage + 1}">After &raquo;</a>
                            </c:if>
                            <c:if test="${requestScope.currentPage >= requestScope.noOfPages}">
                                <span class="disabled">After &raquo;</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="/common/footer.jsp"/>

    <div class="search-model">
        <div class="h-100 d-flex align-items-center justify-content-center">
            <div class="search-close-switch"><i class="icon_close"></i></div>
            <form class="search-model-form">
                <input type="text" id="search-input" placeholder="Search here.....">
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
    <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <script>
        $(document).ready(function () {
            $(".date-input").datepicker({
                dateFormat: 'dd/mm/yy',
                minDate: 0,
                onSelect: function (selectedDate) {
                    var option = this.id === "date-in" ? "minDate" : "maxDate";
                    var instance = $(this).data("datepicker");
                    var date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);

                    if (this.id === "date-in") {
                        var dateOutVal = $("#date-out").val();
                        if (dateOutVal) {
                            var dateOut = $.datepicker.parseDate(instance.settings.dateFormat, dateOutVal, instance.settings);
                            if (dateOut < date) {
                                $("#date-out").val("");
                            }
                        }
                        $("#date-out").datepicker("option", "minDate", date);
                    } else if (this.id === "date-out") {
                        $("#date-in").datepicker("option", "maxDate", date);
                    }
                }
            });

            $('select.nice-select-custom').niceSelect();
        });
    </script>
</body>
</html>