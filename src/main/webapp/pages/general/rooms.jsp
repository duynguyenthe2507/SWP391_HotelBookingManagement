<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zxx">

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
            }
            .filter-form input:focus,
            .filter-form select:focus {
                border-color: #007bff;
                outline: none;
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
                margin-top: 25px;
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
            .error-message {
                color: red;
                font-weight: bold;
                text-align: center;
                margin-bottom: 20px;
                font-size: 1.1em;
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

/*            .header-section .top-nav {
                border-bottom: 1px solid #eee;
                padding: 10px 0;
            }
            .header-section .top-nav .tn-left {
                padding: 0;
                margin: 0;
                list-style: none;
                display: flex;
                gap: 20px;
                align-items: center;
                height: 100%;
            }
            .header-section .top-nav .tn-left li {
                color: #555;
                font-size: 14px;
                line-height: 24px;
            }
            .header-section .top-nav .tn-left li i {
                color: #dfa974;
                margin-right: 5px;
            }
            .header-section .top-nav .tn-right {
                text-align: right;
                display: flex;
                align-items: center;
                justify-content: flex-end;
                height: 100%;
            }
            .header-section .top-nav .top-social a {
                font-size: 16px;
                color: #888;
                margin-left: 17px;
                transition: all 0.3s;
            }
            .header-section .top-nav .top-social a:hover {
                color: #dfa974;
            }
            .header-section .top-nav .bk-btn {
                display: inline-block;
                font-size: 14px;
                font-weight: 500;
                text-transform: uppercase;
                padding: 8px 20px;
                border-radius: 0;
            }*/

            .menu-item {
                padding: 1px 0;
            }
            .menu-item .logo a {
                text-decoration: none;
            }
            .menu-item .logo h1 {
                font-family: 'Lora', serif;
                font-size: 36px;
                color: #333;
                margin: 0;
                padding: 0;
            }
            .mainmenu ul {
                margin: 0;
                padding: 0;
                list-style: none;
                text-align: right;
            }
            .mainmenu ul li {
                display: inline-block;
                margin-left: 40px;
                position: relative;
            }
            .mainmenu ul li a {
                font-size: 16px;
                color: #333;
                font-weight: 600;
                display: block;
                padding: 5px 0;
                transition: all 0.3s;
                text-decoration: none;
            }
            .mainmenu ul li.active a,
            .mainmenu ul li a:hover {
                color: #dfa974;
            }
            .mainmenu ul li.active a:after {
                content: '';
                position: absolute;
                left: 0;
                bottom: 0;
                width: 100%;
                height: 2px;
                background-color: #dfa974;
            }

            
            .header-divider {
                width: 100%; 
                height: 1px;
                background-color: #e0e0e0;
                margin: 0 auto; 
            }
        </style>
    </head>

    <body>
        <div id="preloder">
            <div class="loader"></div>
        </div>

        <div class="offcanvas-menu-overlay"></div>
        <div class="canvas-open">
            <i class="icon_menu"></i>
        </div>
        <div class="offcanvas-menu-wrapper">
            <div class="canvas-close">
                <i class="icon_close"></i>
            </div>
            <div class="search-icon search-switch">
                <i class="icon_search"></i>
            </div>
<!--            <div class="header-configure-area">
                <div class="language-option">
                    <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
                    <span>EN <i class="fa fa-angle-down"></i></span>
                    <div class="flag-dropdown">
                        <ul>
                            <li><a href="#">Zi</a></li>
                            <li><a href="#">Fr</a></li>
                        </ul>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="bk-btn">Booking Now</a>
            </div>-->
            <nav class="mainmenu mobile-menu">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li class="active"><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                    <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                    <li><a href="#">Pages</a>
                        <ul class="dropdown">
                            <li><a href="${pageContext.request.contextPath}/room-details">Room Details</a></li>
                            <li><a href="${pageContext.request.contextPath}/blog-details">Blog Details</a></li>
                        </ul>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/blog">News</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </nav>
            <div id="mobile-menu-wrap"></div>
            <div class="top-social">
                <a href="https://only-fans.me/highaileri"><i class="fa fa-facebook"></i></a>
                <a href="https://only-fans.me/highaileri"><i class="fa fa-twitter"></i></a>
                <a href="https://only-fans.me/highaileri"><i class="fa fa-tripadvisor"></i></a>
                <a href="https://only-fans.me/highaileri"><i class="fa fa-instagram"></i></a>
            </div>
            <ul class="top-widget">
                <li><i class="fa fa-phone"></i> (84) 359 797 703</li>
                <li><i class="fa fa-envelope"></i> 36hotel@gmail.com</li>
            </ul>
        </div>

        <jsp:include page="/common/header.jsp"/>

        <div class="header-divider"></div>

        <div class="breadcrumb-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="breadcrumb-text">
                            <h2>Our Rooms</h2>
                            <div class="bt-option">
                                <a href="${pageContext.request.contextPath}/home">Home</a>
                                <span>Rooms</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <section class="rooms-section spad">
            <div class="container">
                <c:if test="${not empty requestScope.errorMessage}">
                    <p class="error-message"><c:out value="${requestScope.errorMessage}"/></p>
                </c:if>

                <form action="${pageContext.request.contextPath}/rooms" method="GET" class="filter-form">
                    <div>
                        <label for="search">Search:</label>
                        <input type="text" id="search" name="search" value="${fn:escapeXml(param.search)}" placeholder="Room name...">
                    </div>
                    <div>
                        <label for="category">Rooms Type:</label>
                        <select id="category" name="categoryId">
                            <option value="">All</option>
                            <c:forEach var="cat" items="${requestScope.categories}">
                                <option value="${cat.categoryId}" ${cat.categoryId == param.categoryId ? 'selected' : ''}>
                                    <c:out value="${cat.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label for="minPrice">Price from:</label>
                        <input type="number" id="minPrice" name="minPrice" value="${fn:escapeXml(param.minPrice)}" placeholder="Lowest price..." min="0">
                    </div>
                    <div>
                        <label for="maxPrice">Price to:</label>
                        <input type="number" id="maxPrice" name="maxPrice" value="${fn:escapeXml(param.maxPrice)}" placeholder="Highest pricet..." min="0">
                    </div>
                    <div>
                        <label for="minCapacity">Minimum capacity:</label>
                        <input type="number" id="minCapacity" name="minCapacity" value="${fn:escapeXml(param.minCapacity)}" placeholder="Capacity..." min="1">
                    </div>

                    <div>
                        <label for="check-in">Check-in date:</label>
                        <input type="text" class="date-input" id="check-in" name="checkInDate" value="${fn:escapeXml(param.checkInDate)}" placeholder="dd/mm/yyyy" readonly>
                        <i class="icon_calendar"></i>
                    </div>
                    <div>
                        <label for="check-out">Check-out date:</label>
                        <input type="text" class="date-input" id="check-out" name="checkOutDate" value="${fn:escapeXml(param.checkOutDate)}" placeholder="dd/mm/yyyy" readonly>
                        <i class="icon_calendar"></i>
                    </div>
                    <div>
                        <label for="statusFilter">Status:</label>
                        <select id="statusFilter" name="statusFilter">
                            <option value="">All statuses</option>
                            <option value="Available" ${param.statusFilter == 'Available' ? 'selected' : ''}>Available</option>
                            <option value="Booked" ${param.statusFilter == 'Booked' ? 'selected' : ''}>Booked</option>
                        </select>
                    </div>

                    <div>
                        <button type="submit">Filter and Search</button>
                    </div>
                </form>

                <div class="row">
                    <c:choose>
                        <c:when test="${not empty requestScope.rooms}">
                            <c:forEach var="room" items="${requestScope.rooms}">
                                <div class="col-lg-4 col-md-6">
                                    <div class="room-item">
                                        <img src="${pageContext.request.contextPath}/${room.imgUrl}"
                                             alt="${room.name}"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';"
                                             style="width:100%; height:250px; object-fit: cover;">
                                        <div class="ri-text">
                                            <h4><c:out value="${room.name}"/></h4>
                                            <h3>
                                                <fmt:formatNumber value="${room.price}" pattern="#,##0"/> VND
                                                <span>/Pernight</span>
                                            </h3>    <table>
                                                <tbody>
                                                    <tr>
                                                        <td class="r-o">Type:</td>
                                                        <td><strong><c:out value="${room.category.name}"/></strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="r-o">Capacity:</td>
                                                        <td>Max <c:out value="${room.capacity}"/> persion</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="r-o">Describe:</td>
                                                        <td><c:out value="${room.description}"/></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="r-o">Status:</td>
                                                        <td><c:out value="${room.status}"/></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <a href="${pageContext.request.contextPath}/room-details?roomId=${room.roomId}" class="primary-btn room-detail-btn">More Details</a>
                                            <a href="#" class="primary-btn">Booking Now</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-lg-12">
                                <p class="text-center">No rooms were found matching your search/filter criteria.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

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
                                                    var option = this.id == "check-in" ? "minDate" : "maxDate";
                                                    var instance = $(this).data("datepicker");
                                                    var date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);

                                                    if (this.id === "check-in" && $("#check-out").val()) {
                                                        $("#check-out").datepicker("option", "minDate", date);
                                                    }
                                                    if (this.id === "check-out" && $("#check-in").val()) {
                                                        $("#check-in").datepicker("option", "maxDate", date);
                                                    }
                                                }
                                            });
                                            $('select').niceSelect();
                                        });
        </script>
    </body>

</html>