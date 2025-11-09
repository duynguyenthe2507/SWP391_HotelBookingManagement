<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="zxx">
    <head>
        <meta charset="UTF-8">
        <meta name="description" content="Sona Template">
        <meta name="keywords" content="Sona, unica, creative, html">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>36 Hotel</title>

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

        <!-- Css Styles -->
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="css/font-awesome.min.css" type="text/css">
        <link rel="stylesheet" href="css/elegant-icons.css" type="text/css">
        <link rel="stylesheet" href="css/flaticon.css" type="text/css">
        <link rel="stylesheet" href="css/owl.carousel.min.css" type="text/css">
        <link rel="stylesheet" href="css/nice-select.css" type="text/css">
        <link rel="stylesheet" href="css/jquery-ui.min.css" type="text/css">
        <link rel="stylesheet" href="css/magnific-popup.css" type="text/css">
        <link rel="stylesheet" href="css/slicknav.min.css" type="text/css">
        <link rel="stylesheet" href="css/style.css" type="text/css">
    </head>

    <body>
        <!-- Page Preloder -->
        <div id="preloder">
            <div class="loader"></div>
        </div>

        <!-- Header Section Begin -->
        <jsp:include page="/common/header.jsp"/>
        <!-- Header End -->

        <!-- Hero Section Begin -->
        <section class="hero-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="hero-text">
                            <h1>36 Hotel</h1>
                            <p>Discover the top hotel booking sites for international travel and
                                affordable hotel rooms.</p>
                            <a href="./booking" class="primary-btn">Discover Now</a>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-5 offset-xl-2 offset-lg-1">
                        <div class="booking-form">
                            <h3>Booking Your Hotel</h3>
                            <form action="${pageContext.request.contextPath}/rooms" method="GET" id="homeBookingForm">

                                <div class="check-date">
                                    <label for="date-in-home">Check In:</label>
                                    <input type="text" class="date-input" name="checkInDate" id="date-in-home" required>
                                    <i class="icon_calendar"></i>
                                </div>

                                <div class="check-date">
                                    <label for="date-out-home">Check Out:</label>
                                    <input type="text" class="date-input" name="checkOutDate" id="date-out-home" required>
                                    <i class="icon_calendar"></i>
                                </div>

                                <div class="select-option">
                                    <label for="guestCount">Guests:</label>
                                    <select id="guestCount" name="minCapacity">
                                        <option value="1">1 Guest</option>
                                        <option value="2">2 Guests</option>
                                        <option value="3">3 Guests</option>
                                        <option value="4">4 Guests</option>
                                    </select>
                                </div>

                                <div class="select-option">
                                    <label for="categorySelect">Category:</label>
                                    <select id="categorySelect" name="categoryId">
                                        <option value="">All Categories</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}">${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <button type="submit" id="btnGoToCheckout">Find Rooms</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="hero-slider owl-carousel">
                <div class="hs-item set-bg" data-setbg="img/hero/hero-1.jpg"></div>
                <div class="hs-item set-bg" data-setbg="img/hero/hero-2.jpg"></div>
                <div class="hs-item set-bg" data-setbg="img/hero/hero-3.jpg"></div>
            </div>
        </section>
        <!-- Hero Section End -->

        <!-- Services Section End -->
            <section class="services-section spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="section-title">
                                <span>What We Do</span>
                                <h2>Discover Our Services</h2>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <c:forEach var="service" items="${services}">
                            <div class="col-lg-4 col-sm-6">
                                <div class="service-item">
                                    <i class="${service.iconClass}"></i>
                                    <h4>${service.name}</h4>
                                    <p>${service.description}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </section>
        <!-- Services Section End -->

        <!-- Category Section Begin -->
            <section class="hp-room-section">
                <div class="container-fluid">
                    <div class="hp-room-items">
                        <div class="row">
                            <c:forEach var="category" items="${categories}">
                                <div class="col-lg-4 col-md-6">
                                    <div class="hp-room-item set-bg" data-setbg="${category.imgUrl}">
                                        <div class="hr-text">
                                            <h3 style="
                                            color: #1a1a1a; font-weight: 600; font-size: 24px; text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
                                            margin-bottom: 20px; padding: 10px;">
                                                    ${category.name}
                                            </h3>
                                            <p style="
                                            color: #1a1a1a; font-weight: 600; font-size: 18px; text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
                                            margin-bottom: 20px; background: rgba(255, 255, 255, 0.8); padding: 10px; border-radius: 5px;">
                                                    ${category.description}
                                            </p>
                                            <a href="rooms?categoryId=${category.categoryId}" class="primary-btn"
                                               style="background: #dfa974; color: #ffffff; padding: 12px 24px; border-radius: 5px; text-transform: uppercase; font-weight: 500; transition: background 0.3s ease;">
                                                View Rooms
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </section>
        <!-- Category Section End -->

        <!-- Footer Section Begin -->
        <jsp:include page="/common/footer.jsp"/>
        <!-- Footer Section End -->

        <!-- Js Plugins -->
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/jquery.nice-select.min.js"></script>
        <script src="js/jquery-ui.min.js"></script>
        <script src="js/jquery.slicknav.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>

        <script>
            $(document).ready(function() {
                // Khởi tạo Datepicker
                $('#date-in-home').datepicker({
                    dateFormat: 'dd/mm/yy',
                    minDate: 0,
                    onSelect: function(selectedDate) {
                        var date = $(this).datepicker('getDate');
                        if (date) {
                            date.setDate(date.getDate() + 1);
                            $('#date-out-home').datepicker('option', 'minDate', date);
                        }
                    }
                });
                $('#date-out-home').datepicker({
                    dateFormat: 'dd/mm/yy',
                    minDate: 0
                });

                // Khởi tạo Nice Select
                $('select').niceSelect();
            });
        </script>
    </body>
</html>