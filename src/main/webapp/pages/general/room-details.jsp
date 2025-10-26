<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Sona Template">
    <meta name="keywords" content="Sona, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <c:set var="room" value="${requestScope.room}" />
    <title>36 Hotel - <c:out value="${not empty room ? room.name : 'Room Details'}"/></title>

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
        /* Alert Styles */
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 20px;
            margin: 40px 0;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .alert-danger h4 {
            margin-bottom: 15px;
            font-size: 24px;
        }
        
        .alert-danger p {
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .text-center {
            text-align: center;
        }

        .mt-3 {
            margin-top: 1.5rem !important;
        }

        .btn-primary {
            color: #fff;
            background-color: #dfa974;
            border-color: #dfa974;
            padding: 12px 30px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background-color: #c7956d;
            border-color: #c7956d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(223, 169, 116, 0.4);
        }

        /* Header Improvements */
        .header-section .top-nav {
            background-color: #f8f9fa;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .header-section .top-nav .tn-left li {
            margin-right: 25px;
            font-size: 13px;
            color: #666;
        }

        .header-section .top-nav .tn-right {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        .header-section .top-nav .bk-btn {
            background-color: #dfa974;
            color: white !important;
            border: 1px solid #dfa974;
            padding: 8px 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            border-radius: 3px;
            transition: all 0.3s;
        }

        .header-section .top-nav .bk-btn:hover {
            background-color: #c7956d;
            border-color: #c7956d;
            transform: translateY(-1px);
        }

        .header-section .logo h1 {
            font-family: 'Lora', serif;
            font-size: 42px;
            font-weight: 700;
            color: #333;
            margin: 0;
            padding: 20px 0;
            display: inline-block;
            letter-spacing: 2px;
        }

        .header-section .menu-item {
            padding: 1px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        /* Room Details Section */
        .room-details-section {
            padding: 60px 0;
        }

        .room-details-item img {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 35px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .rd-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .rd-title h3 {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin: 0;
        }

        .rdt-right {
            text-align: right;
        }

        .rdt-right .rating {
            color: #dfa974;
            font-size: 16px;
            margin-bottom: 10px;
        }

        .rdt-right a {
            background-color: #dfa974;
            color: white;
            padding: 10px 25px;
            border-radius: 4px;
            text-transform: uppercase;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            transition: all 0.3s;
        }

        .rdt-right a:hover {
            background-color: #c7956d;
            transform: translateY(-2px);
        }

        .rd-text h2 {
            font-size: 36px;
            font-weight: 700;
            color: #dfa974;
            margin-bottom: 30px;
        }

        .rd-text h2 span {
            font-size: 16px;
            color: #666;
            font-weight: 400;
        }

        .rd-text table {
            width: 100%;
            margin-bottom: 30px;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        .rd-text table tr {
            background-color: #f8f9fa;
        }

        .rd-text table td {
            padding: 15px 20px;
            font-size: 15px;
        }

        .rd-text table td.r-o {
            font-weight: 600;
            color: #333;
            width: 180px;
        }

        .rd-text p {
            line-height: 1.8;
            color: #666;
            margin-bottom: 20px;
            text-align: justify;
        }

        /* Booking Form */
        .room-booking {
            background-color: #f8f9fa;
            padding: 35px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            position: sticky;
            top: 20px;
        }

        .room-booking h3 {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            margin-bottom: 30px;
            text-align: center;
            padding-bottom: 15px;
            border-bottom: 2px solid #dfa974;
        }

        .room-booking .check-date,
        .room-booking .select-option {
            margin-bottom: 25px;
        }

        .room-booking label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .room-booking input,
        .room-booking select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .room-booking input:focus,
        .room-booking select:focus {
            border-color: #dfa974;
            outline: none;
        }

        .room-booking button {
            width: 100%;
            background-color: #dfa974;
            color: white;
            padding: 15px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .room-booking button:hover {
            background-color: #c7956d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(223, 169, 116, 0.4);
        }

        /* Reviews Section */
        .rd-reviews {
            margin-top: 50px;
            padding-top: 40px;
            border-top: 2px solid #f0f0f0;
        }

        .rd-reviews h4 {
            font-size: 26px;
            font-weight: 700;
            color: #333;
            margin-bottom: 30px;
        }

        .review-item {
            display: flex;
            margin-bottom: 30px;
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .review-item .ri-pic {
            margin-right: 20px;
        }

        .review-item .ri-pic img {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
        }

        .review-item .ri-text {
            flex: 1;
        }

        .review-item .ri-text span {
            color: #999;
            font-size: 13px;
        }

        .review-item .ri-text h5 {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 10px 0;
        }

        .review-item .ri-text .rating {
            color: #dfa974;
            margin: 8px 0;
        }

        .review-item .ri-text p {
            color: #666;
            line-height: 1.7;
        }

        /* Add Review Form */
        .review-add {
            margin-top: 40px;
            padding: 35px;
            background-color: #f8f9fa;
            border-radius: 10px;
        }

        .review-add h4 {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            margin-bottom: 25px;
        }

        .review-add input,
        .review-add textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .review-add input:focus,
        .review-add textarea:focus {
            border-color: #dfa974;
            outline: none;
        }

        .review-add textarea {
            min-height: 120px;
            resize: vertical;
        }

        .review-add button {
            background-color: #dfa974;
            color: white;
            padding: 12px 35px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.3s;
        }

        .review-add button:hover {
            background-color: #c7956d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(223, 169, 116, 0.4);
        }

        /* Breadcrumb */
        .breadcrumb-section {
            background-color: #f8f9fa;
            padding: 50px 0;
            margin-bottom: 0;
        }

        .breadcrumb-text h2 {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
        }

        .bt-option a,
        .bt-option span {
            color: #666;
            margin: 0 8px;
            font-size: 14px;
        }

        .bt-option a:hover {
            color: #dfa974;
        }

        /* Responsive */
        @media (max-width: 991px) {
            .room-booking {
                margin-top: 40px;
                position: static;
            }

            .rd-title {
                flex-direction: column;
                align-items: flex-start;
            }

            .rdt-right {
                text-align: left;
                margin-top: 15px;
            }
        }
    </style>
</head>

<body>
    <!-- Preloader -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Offcanvas Menu -->
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
        <div class="header-configure-area">
            <div class="language-option">
                <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
                <span>EN <i class="fa fa-angle-down"></i></span>
                <div class="flag-dropdown">
                    <ul>
                        <li><a href="#">De</a></li>
                        <li><a href="#">Fr</a></li>
                    </ul>
                </div>
            </div>
            <c:choose>
                <c:when test="${sessionScope.loggedInUser == null}">
                    <a href="${pageContext.request.contextPath}/login" class="bk-btn">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="bk-btn" style="margin-left: 5px;">Register</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/profile" class="bk-btn">Profile</a>
                    <a href="${pageContext.request.contextPath}/cart" class="bk-btn" style="margin-left: 5px;">Cart</a>
                    <a href="${pageContext.request.contextPath}/wishlist" class="bk-btn" style="margin-left: 5px;">Wishlist</a>
                    <a href="${pageContext.request.contextPath}/logout" class="bk-btn" style="margin-left: 5px;">Logout</a>
                </c:otherwise>
            </c:choose>
        </div>
        <nav class="mainmenu mobile-menu">
            <ul>
                <li class="${(requestScope.activeMenu == 'home') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/home">Home</a>
                </li>
                <li class="${(requestScope.activeMenu == 'rooms') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
                </li>
                <li class="${(requestScope.activeMenu == 'contact') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/contact">Contact</a>
                </li>
                <li class="${(requestScope.activeMenu == 'rules') ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/rules">Rules</a>
                </li>
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

    <!-- Header Section -->
    <header class="header-section">
        <div class="top-nav">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-4 col-md-4 col-sm-6">
                        <ul class="tn-left">
                            <li><i class="fa fa-phone"></i> (84) 359 797 703</li>
                            <li><i class="fa fa-envelope"></i> 36hotel@gmail.com</li>
                        </ul>
                    </div>
                    <div class="col-lg-4 col-md-4 d-none d-md-block text-center">
                        <div class="top-social">
                            <a href="#"><i class="fa fa-facebook"></i></a>
                            <a href="#"><i class="fa fa-twitter"></i></a>
                            <a href="#"><i class="fa fa-tripadvisor"></i></a>
                            <a href="#"><i class="fa fa-instagram"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-6">
                        <div class="tn-right">
                            <c:choose>
                                <c:when test="${sessionScope.loggedInUser == null}">
                                    <a href="${pageContext.request.contextPath}/login" class="bk-btn">Login</a>
                                    <a href="${pageContext.request.contextPath}/register" class="bk-btn">Be our member</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/profile" class="bk-btn">Profile</a>
                                    <a href="${pageContext.request.contextPath}/cart" class="bk-btn">Cart</a>
                                    <a href="${pageContext.request.contextPath}/wishlist" class="bk-btn">Wishlist</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="bk-btn">Logout</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="menu-item">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-2">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home">
                                <h1>36</h1>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-10">
                        <div class="nav-menu">
                            <nav class="mainmenu">
                                <ul>
                                    <li class="${(requestScope.activeMenu == 'home') ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/home">Home</a>
                                    </li>
                                    <li class="${(requestScope.activeMenu == 'rooms') ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
                                    </li>
                                    <li class="${(requestScope.activeMenu == 'contact') ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/contact">Contact</a>
                                    </li>
                                    <li class="${(requestScope.activeMenu == 'rules') ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/rules">Rules</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Breadcrumb Section -->
    <div class="breadcrumb-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb-text">
                        <h2><c:out value="${not empty room ? room.name : 'Room Details'}"/></h2>
                        <div class="bt-option">
                            <a href="${pageContext.request.contextPath}/home">Home</a>
                            <a href="${pageContext.request.contextPath}/rooms">Rooms</a>
                            <span><c:out value="${not empty room ? room.name : 'Details'}"/></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Room Details Section -->
    <section class="room-details-section spad">
        <div class="container">
            <c:choose>
                <c:when test="${not empty room}">
                    <div class="row">
                        <!-- Left Column: Room Details -->
                        <div class="col-lg-8">
                            <div class="room-details-item">
                                <img src="${pageContext.request.contextPath}/${room.imgUrl}"
                                     alt="${room.name}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';">
                                
                                <div class="rd-text">
                                    <div class="rd-title">
                                        <h3><c:out value="${room.name}"/></h3>
                                        <div class="rdt-right">
                                            <div class="rating">
                                                <i class="icon_star"></i>
                                                <i class="icon_star"></i>
                                                <i class="icon_star"></i>
                                                <i class="icon_star"></i>
                                                <i class="icon_star-half_alt"></i>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/booking">Booking Now</a>
                                        </div>
                                    </div>
                                    
                                    <h2>
                                        <fmt:formatNumber value="${room.price}" pattern="#,##0"/> VND
                                        <span>/Pernight</span>
                                    </h2>
                                    
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Room Type:</td>
                                                <td><c:out value="${room.category.name}"/></td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Capacity:</td>
                                                <td>Max <c:out value="${room.capacity}"/> people</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Status:</td>
                                                <td><c:out value="${room.status}"/></td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Services:</td>
                                                <td>Wifi, Television, Bathroom,...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    
                                    <p class="f-para"><c:out value="${room.description}"/></p>
                                    <p>Mauris molestie lectus in CLUDES quamlaoreet, a tincidunt lacus aliquet. Quisque non interdum
                                        massa. Phasellus et lacus id nunc venenatis fringilla. Aliquam Cursus commodo
                                        turpis, vitae orci aonsectetur. Interdum et malesuada fames ac ante ipsum primis in
                                        faucibus.</p>
                                </div>
                            </div>

                            <!-- Reviews Section -->
                            <div class="rd-reviews">
                                <h4>Reviews</h4>
                                <div class="review-item">
                                    <div class="ri-pic">
                                        <img src="${pageContext.request.contextPath}/img/room/avatar/default-avatar.png" alt="">
                                    </div>
                                    <div class="ri-text">
                                        <span>27 Aug 2019</span>
                                        <div class="rating">
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star-half_alt"></i>
                                        </div>
                                        <h5>Brandon Kelley</h5>
                                        <p>Neque porro qui squam est, qui dolorem ipsum quia dolor sit amet, consectetur,
                                            adipisci velit, sed quia non numquam eius modi tempora.
                                            incidunt ut labore et dolore magnam.</p>
                                    </div>
                                </div>
                                <div class="review-item">
                                    <div class="ri-pic">
                                        <img src="${pageContext.request.contextPath}/img/room/avatar/default-avatar.png" alt="">
                                    </div>
                                    <div class="ri-text">
                                        <span>27 Aug 2019</span>
                                        <div class="rating">
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star"></i>
                                            <i class="icon_star-half_alt"></i>
                                        </div>
                                        <h5>Brandon Kelley</h5>
                                        <p>Neque porro qui squam est, qui dolorem ipsum quia dolor sit amet, consectetur,
                                            adipisci velit, sed quia non numquam eius modi tempora.
                                            incidunt ut labore et dolore magnam.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Add Review Form -->
                            <div class="review-add">
                                <h4>Add Review</h4>
                                <form action="post" class="ra-form">
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <input type="text" placeholder="Name*">
                                        </div>
                                        <div class="col-lg-6">
                                            <input type="text" placeholder="Email*">
                                        </div>
                                        <div class="col-lg-12">
                                            <div>
                                                <h5>Your Rating:</h5>
                                                <div class="rating">
                                                    <i class="icon_star"></i>
                                                    <i class="icon_star"></i>
                                                    <i class="icon_star"></i>
                                                    <i class="icon_star"></i>
                                                    <i class="icon_star-half_alt"></i>
                                                </div>
                                            </div>
                                            <textarea placeholder="Your Review"></textarea>
                                            <button type="submit">Submit Now</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Right Column: Booking Form -->
                        <div class="col-lg-4">
                            <div class="room-booking">
                                <h3>Your Reservation</h3>
                                <form action="#">
                                    <div class="check-date">
                                        <label for="date-in">Check In:</label>
                                        <input type="text" class="date-input" id="date-in">
                                        <i class="icon_calendar"></i>
                                    </div>
                                    <div class="check-date">
                                        <label for="date-out">Check Out:</label>
                                        <input type="text" class="date-input" id="date-out">
                                        <i class="icon_calendar"></i>
                                    </div>
                                    <div class="select-option">
                                        <label for="guest">Guests:</label>
                                        <select id="guest">
                                            <c:forEach begin="1" end="${room.capacity}" var="i">
                                                <option value="${i}">${i} Adult(s)</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="select-option">
                                        <label for="room">Room:</label>
                                        <select id="room">
                                            <option value="1">1 Room</option>
                                        </select>
                                    </div>
                                    <button type="submit">Check Availability</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Error Message -->
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="alert alert-danger text-center" role="alert">
                                <h4><c:out value="${not empty errorMessage ? errorMessage : 'Room not found.'}"/></h4>
                                <p>The room you are looking for does not exist or has been removed. Please return to the room list.</p>
                                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary mt-3">Back to Room List</a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Footer Section -->
    <footer class="footer-section">
        <div class="container">
            <div class="footer-text">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="ft-about">
                            <div class="logo">
                                <a href="${pageContext.request.contextPath}/home">
                                    <img src="${pageContext.request.contextPath}/img/footer-logo.png" alt="">
                                </a>
                            </div>
                            <p>We inspire and reach millions of travelers<br /> across 90 local websites</p>
                            <div class="fa-social">
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-facebook"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-twitter"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-tripadvisor"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-instagram"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-youtube-play"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 offset-lg-1">
                        <div class="ft-contact">
                            <h6>Contact Us</h6>
                            <ul>
                                <li>(84) 359 797 703</li>
                                <li>36hotel@gmail.com</li>
                                <li>Thanh Hoa, Viet Nam</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 offset-lg-1">
                        <div class="ft-newslatter">
                            <h6>Latest News</h6>
                            <p>Get the latest updates and offers.</p>
                            <form action="#" method="post" class="fn-form">
                                <input type="text" placeholder="Email">
                                <button type="submit"><i class="fa fa-send"></i></button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="copyright-option">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7">
                        <ul>
                            <li><a href="https://only-fans.me/highaileri">Contact</a></li>
                            <li><a href="https://only-fans.me/highaileri">Terms of use</a></li>
                            <li><a href="https://only-fans.me/highaileri">Privacy</a></li>
                            <li><a href="https://only-fans.me/highaileri">Environmental Policy</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-5">
                        <div class="co-text">
                            <p>Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved by 36 Hotel</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Search Model -->
    <div class="search-model">
        <div class="h-100 d-flex align-items-center justify-content-center">
            <div class="search-close-switch"><i class="icon_close"></i></div>
            <form class="search-model-form">
                <input type="text" id="search-input" placeholder="Search here.....">
            </form>
        </div>
    </div>

    <!-- JS Scripts -->
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
            // Initialize datepicker
            $(".date-input").datepicker({
                dateFormat: 'dd/mm/yy',
                minDate: 0
            });
            
            // Initialize nice select
            $('select').niceSelect();
        });
    </script>
</body>
</html>