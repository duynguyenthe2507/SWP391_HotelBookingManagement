<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zxx">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Sona Template">
    <meta name="keywords" content="Sona, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <%-- Title động theo tên phòng --%>
    <c:set var="room" value="${requestScope.room}" />
    <title>36 Hotel - <c:out value="${not empty room ? room.name : 'Room Details'}"/></title>

    <%-- Cập nhật đường dẫn CSS --%>
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
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: .25rem;
        }
        .text-center {
            text-align: center;
        }
        .mt-3 {
            margin-top: 1rem !important;
        }
        .btn-primary {
            color: #fff;
            background-color: #007bff;
            border-color: #007bff;
            padding: .375rem .75rem;
            font-size: 1rem;
            line-height: 1.5;
            border-radius: .25rem;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
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
        <div class="header-configure-area">
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
        </div>
        <nav class="mainmenu mobile-menu">
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                <li><a href="#">Pages</a>
                    <ul class="dropdown">
                        <li class="active"><a href="${pageContext.request.contextPath}/room-details">Room Details</a></li>
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
    <header class="header-section header-normal">
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
                        <div class="tn-right">
                            <div class="top-social">
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-facebook"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-twitter"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-tripadvisor"></i></a>
                                <a href="https://only-fans.me/highaileri"><i class="fa fa-instagram"></i></a>
                            </div>
                            <a href="${pageContext.request.contextPath}/booking" class="bk-btn">Booking Now</a>
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
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="menu-item">
            <div class="container">
                <div class="row">
                    <div class="col-lg-2">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home">
                                <img src="${pageContext.request.contextPath}/img/logo.png" alt="">
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-10">
                        <div class="nav-menu">
                            <nav class="mainmenu">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                    <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                                    <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                                    <li class="active"><a href="#">Pages</a>
                                        <ul class="dropdown">
                                            <li><a href="${pageContext.request.contextPath}/room-details">Room Details</a></li>
                                            <li><a href="${pageContext.request.contextPath}/blog-details">Blog Details</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/blog">News</a></li>
                                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                                </ul>
                            </nav>
                            <div class="nav-right search-switch">
                                <i class="icon_search"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

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

    <section class="room-details-section spad">
        <div class="container">
            <c:choose>
                <c:when test="${not empty room}">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="room-details-item">
                                <img src="${pageContext.request.contextPath}/${room.imgUrl}" 
                                     alt="${room.name}" 
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';"
                                     style="width: 100%; border-radius: 8px; margin-bottom: 30px;">
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
                                    <h2><fmt:formatNumber value="${room.price}" pattern="#,##0"/> VND<span>/Pernight</span></h2>
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Loại phòng:</td>
                                                <td><c:out value="${room.category.name}"/></td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Sức chứa:</td>
                                                <td>Tối đa <c:out value="${room.capacity}"/> người</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Trạng thái:</td>
                                                <td><c:out value="${room.status}"/></td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Dịch vụ:</td>
                                                <td>Wifi, Television, Bathroom,...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <p class="f-para"><c:out value="${room.description}"/></p>
                                    <p>Mauris molestie lectus in CLUDES quamlaoreet, a tincidunt lacus aliquet. Quisque non interdum
                                        massa. Phasellus et lacus id nunc venenatis fringilla. Aliquam Cursus commodo
                                        turpis, vitae orci aonsectetur. Interdum et malesuada fames ac ante ipsum primis in
                                        faucibus. </p>
                                </div>
                            </div>
                            <div class="rd-reviews">
                                <h4>Reviews</h4>
                                <div class="review-item">
                                    <div class="ri-pic">
                                        <img src="${pageContext.request.contextPath}/img/room/avatar/avatar-1.jpg" alt="">
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
                                        <img src="${pageContext.request.contextPath}/img/room/avatar/avatar-2.jpg" alt="">
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
                                                <h5>You Rating:</h5>
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
                                            <%-- Số khách tối đa theo sức chứa của phòng --%>
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
                            <h6>New latest</h6>
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
                        <div class="co-text"><p>
  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved by 36 Hotel
                    </div>
                </div>
            </div>
        </div>
    </footer>
    
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
        $(document).ready(function() {
            $(".date-input").datepicker({
                dateFormat: 'dd/mm/yy', 
                minDate: 0
            });
            $('select').niceSelect();
        });
    </script>
</body>

</html>