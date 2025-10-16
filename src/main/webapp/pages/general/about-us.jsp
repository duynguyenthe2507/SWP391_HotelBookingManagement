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

        <!-- Offcanvas Menu Section Begin -->
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
                <% if (session.getAttribute("loggedInUser") == null) { %>
                <a href="login" class="bk-btn">Login</a>
                <a href="register" class="bk-btn">Be our member</a>
                <a href="./booking">Booking Now</a>
                <% } else { %>
                <div
                    class="dropdown"
                    style="display: inline-block; position: relative"
                    >
                    <a href="profile" class="bk-btn" style="padding: 8px 12px">
                        Profile
                    </a>
                </div>
                <a href="./booking">Booking Now</a>
                <% } %>
            </div>
            <nav class="mainmenu mobile-menu">
                <ul>
                    <li class="active"><a href="home">Home</a></li>
                    <li><a href="rooms">Rooms</a></li>
                    <li><a href="about-us">About Us</a></li>
                    <li><a href="#">Pages</a>
                        <ul class="dropdown">
                            <li><a href="room-details">Room Details</a></li>
                            <li><a href="blog-details">Blog Details</a></li>
                        </ul>
                    </li>
                    <li><a href="blog">News</a></li>
                    <li><a href="contact">Contact</a></li>
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
        <!-- Offcanvas Menu Section End -->

        <!-- Header Section Begin -->
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
                                <% if (session.getAttribute("loggedInUser") == null) { %>
                                <a href="login" class="bk-btn">Login</a>
                                <a href="register" class="bk-btn">Be our member</a>
                                <a href="./booking">Booking Now</a>
                                <% } else { %>
                                <div
                                    class="dropdown"
                                    style="display: inline-block; position: relative"
                                    >
                                    <a href="profile" class="bk-btn" style="padding: 8px 12px">
                                        Profile
                                    </a>
                                </div>
                                <a href="./booking">Booking Now</a>
                                <% } %>
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
                                <a href="./index.html">
                                    <img src="img/logo.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="nav-menu">
                                <nav class="mainmenu">
                                    <ul>
                                        <li class="active"><a href="home">Home</a></li>
                                        <li><a href="rooms">Rooms</a></li>
                                        <li><a href="about-us">About Us</a></li>
                                        <li><a href="#">Pages</a>
                                            <ul class="dropdown">
                                                <li><a href="room-details">Room Details</a></li>
                                                <li><a href="blog-details">Blog Details</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="blog">News</a></li>
                                        <li><a href="contact">Contact</a></li>
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
        <!-- Header End -->

        <!-- Breadcrumb Section Begin -->
        <div class="breadcrumb-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="breadcrumb-text">
                            <h2>About Us</h2>
                            <div class="bt-option">
                                <a href="home">Home</a>
                                <span>About Us</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Breadcrumb Section End -->

        <!-- About Us Page Section Begin -->
        <section class="aboutus-page-section spad">
            <div class="container">
                <div class="about-page-text">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="ap-title">
                                <h2>Welcome To 36 Hotel.</h2>
                                <p>Located in the heart of Thanh Hoa city, **36 Hotel** is built in a modern style,
                                    providing a comfortable resort experience, with easy access to famous attractions
                                    such as Sam Son Beach and Thanh Nha Ho. The hotel has elegantly decorated rooms.</p>
                            </div>
                        </div>
                        <div class="col-lg-5 offset-lg-1">
                            <ul class="ap-services">
                                <li><i class="icon_check"></i> 20% Off On Accommodation.</li>
                                <li><i class="icon_check"></i> Complimentary Daily Breakfast</li>
                                <li><i class="icon_check"></i> 3 Pcs Laundry Per Day</li>
                                <li><i class="icon_check"></i> Free Wifi.</li>
                                <li><i class="icon_check"></i> Discount 20% On F&B</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="about-page-services">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="ap-service-item set-bg" data-setbg="img/about/about-p1.jpg">
                                <div class="api-text">
                                    <h3>Restaurants Services</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="ap-service-item set-bg" data-setbg="img/about/about-p2.jpg">
                                <div class="api-text">
                                    <h3>Travel & Camping</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="ap-service-item set-bg" data-setbg="img/about/about-p3.jpg">
                                <div class="api-text">
                                    <h3>Event & Party</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- About Us Page Section End -->

        <!-- Video Section Begin -->
        <section class="video-section set-bg" data-setbg="img/video-bg.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="video-text">
                            <h2>Discover Our Hotel & Services.</h2>
                            <p>It S Hurricane Season But We Are Visiting Hilton Head Island</p>
                            <a href="https://www.youtube.com/watch?v=EzKkl64rRbM" class="play-btn video-popup"><img
                                    src="img/play.png" alt=""></a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Video Section End -->

        <!-- Gallery Section Begin -->
        <section class="gallery-section spad">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-title">
                            <span>Our Gallery</span>
                            <h2>Discover Our Work</h2>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="gallery-item set-bg" data-setbg="img/gallery/gallery-1.jpg">
                            <div class="gi-text">
                                <h3>Room Luxury</h3>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="gallery-item set-bg" data-setbg="img/gallery/gallery-3.jpg">
                                    <div class="gi-text">
                                        <h3>Room Luxury</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="gallery-item set-bg" data-setbg="img/gallery/gallery-4.jpg">
                                    <div class="gi-text">
                                        <h3>Room Luxury</h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="gallery-item large-item set-bg" data-setbg="img/gallery/gallery-2.jpg">
                            <div class="gi-text">
                                <h3>Room Luxury</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Gallery Section End -->

        <!-- Footer Section Begin -->
        <footer class="footer-section">
            <div class="container">
                <div class="footer-text">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="ft-about">
                                <div class="logo">
                                    <a href="#">
                                        <img src="img/footer-logo.png" alt="">
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
                                <form action="post" class="fn-form">
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
                            <div class="co-text"><p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                    Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved by 36Hotel<i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                                    <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p></div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
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