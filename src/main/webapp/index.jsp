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
                            <form action="post">
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
                                        <option value="">1 Adults</option>
                                        <option value="">2 Adults</option>
                                        <option value="">3 Adults</option>
                                        <option value="">4 Adults</option>
                                        <option value="">5 Adults</option>
                                    </select>
                                </div>
                                <div class="select-option">
                                    <label for="room">Room:</label>
                                    <select id="room">
                                        <option value="">1 Room</option>
                                        <option value="">2 Room</option>
                                        <option value="">3 Room</option>
                                        <option value="">4 Room</option>
                                    </select>
                                </div>
                                <button type="submit">Check Availability</button>
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

        <!-- Testimonial Section Begin -->
        <section class="testimonial-section spad">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-title">
                            <span>Testimonials</span>
                            <h2>What Customers Say?</h2>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="testimonial-slider owl-carousel">
                            <div class="ts-item">
                                <p>After a construction project took longer than expected, my husband, my daughter and I
                                    needed a place to stay for a few nights. As a Chicago resident, we know a lot about our
                                    city, neighborhood and the types of housing options available and absolutely love our
                                    vacation at 36 Hotel.</p>
                                <div class="ti-author">
                                    <div class="rating">
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star-half_alt"></i>
                                    </div>
                                    <h5> - Alexander Vasquez</h5>
                                </div>
                                <img src="img/testimonial-logo.png" alt="">
                            </div>
                            <div class="ts-item">
                                <p>After a construction project took longer than expected, my husband, my daughter and I
                                    needed a place to stay for a few nights. As a Chicago resident, we know a lot about our
                                    city, neighborhood and the types of housing options available and absolutely love our
                                    vacation at 36 Hotel.</p>
                                <div class="ti-author">
                                    <div class="rating">
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star-half_alt"></i>
                                    </div>
                                    <h5> - Alexander Vasquez</h5>
                                </div>
                                <img src="img/testimonial-logo.png" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Testimonial Section End -->

        <!-- Blog Section Begin -->
        <section class="blog-section spad">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-title">
                            <span>Hotel News</span>
                            <h2>Our Blog & Event</h2>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-4">
                        <div class="blog-item set-bg" data-setbg="img/blog/blog-1.jpg">
                            <div class="bi-text">
                                <span class="b-tag">Travel Trip</span>
                                <h4><a href="#">Tremblant In Canada</a></h4>
                                <div class="b-time"><i class="icon_clock_alt"></i> 15th April, 2019</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="blog-item set-bg" data-setbg="img/blog/blog-2.jpg">
                            <div class="bi-text">
                                <span class="b-tag">Camping</span>
                                <h4><a href="#">Choosing A Static Caravan</a></h4>
                                <div class="b-time"><i class="icon_clock_alt"></i> 15th April, 2019</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="blog-item set-bg" data-setbg="img/blog/blog-3.jpg">
                            <div class="bi-text">
                                <span class="b-tag">Event</span>
                                <h4><a href="#">Copper Canyon</a></h4>
                                <div class="b-time"><i class="icon_clock_alt"></i> 21th April, 2019</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="blog-item small-size set-bg" data-setbg="img/blog/blog-wide.jpg">
                            <div class="bi-text">
                                <span class="b-tag">Event</span>
                                <h4><a href="#">Trip To Iqaluit In Nunavut A Canadian Arctic City</a></h4>
                                <div class="b-time"><i class="icon_clock_alt"></i> 08th April, 2019</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="blog-item small-size set-bg" data-setbg="img/blog/blog-10.jpg">
                            <div class="bi-text">
                                <span class="b-tag">Travel</span>
                                <h4><a href="#">Traveling To Barcelona</a></h4>
                                <div class="b-time"><i class="icon_clock_alt"></i> 12th April, 2019</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Section End -->

        <!-- Footer Section Begin -->
        <jsp:include page="/common/footer.jsp"/>
        <!-- Footer Section End -->

        <!-- Search model Begin -->
        <div class="search-model">
            <div class="h-100 d-flex align-items-center justify-content-center">
                <div class="search-close-switch"><i class="icon_close"></i></div>
                <form class="search-model-form">
                    <input type="text" id="search-input" placeholder="Search here.....">
                </form>
            </div>
        </div>
        <!-- Search model end -->

        <!-- Js Plugins -->
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/jquery.nice-select.min.js"></script>
        <script src="js/jquery-ui.min.js"></script>
        <script src="js/jquery.slicknav.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>