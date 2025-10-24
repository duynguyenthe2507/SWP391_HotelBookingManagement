<!DOCTYPE html>
<html lang="zxx">

    <head>
        <meta charset="UTF-8">
        <meta name="description" content="Sona Template">
        <meta name="keywords" content="Sona, unica, creative, html">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>36 Hotel</title>

        <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

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
                    <li class="active"><a href="./home">Home</a></li>
                    <li><a href="./rooms">Rooms</a></li>
                    <li><a href="about-us">About Us</a></li>
                    <li><a href="#">Pages</a>
                        <ul class="dropdown">
                            <li><a href="./room-details">Room Details</a></li>
                            <li><a href="./blog-details">Blog Details</a></li>
                        </ul>
                    </li>
                    <li><a href="./blog">News</a></li>
                    <li><a href="./contact">Contact</a></li>
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
                <li><i class="fa
                       fa-phone"></i> (84) 359 797 703</li>
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
                                <a href="./home">
                                    <img src="img/logo.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="nav-menu">
                                <nav class="mainmenu">
                                    <ul>
                                        <li class="active"><a href="./home">Home</a></li>
                                        <li><a href="./rooms">Rooms</a></li>
                                        <li><a href="./about-us">About Us</a></li>
                                        <li><a href="#">Pages</a>
                                            <ul class="dropdown">
                                                <li><a href="./room-details">Room Details</a></li>
                                                <li><a href="./blog-details">Blog Details</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="./blog">News</a></li>

                                        <li><a href="./contact">Contact</a></li>
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
        <section class="contact-section spad">
            <div class="container">
                <div class="row">
                    <div
                        class="col-lg-4">
                        <div class="contact-text">
                            <h2>Contact Info</h2>
                            <p>Please contact us for detailed information and best booking support. 36 Hotel team is always
                                ready to serve you!</p>
                            <table>
                                <tbody>
                                    <tr>
                                        <td class="c-o">Address:</td>
                                        <td>Thanh Hoa, Viet Nam</td>
                                    </tr>
                                    <tr>
                                        <td class="c-o">Phone:</td>
                                        <td>(84) 359 797 703</td>
                                    </tr>

                                    <tr>
                                        <td class="c-o">Email:</td>
                                        <td>36hotel@gmail.com</td>

                                    </tr>
                                    <tr>
                                        <td class="c-o">Fax:</td>
                                        <td>+(84) 359 797 703</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                    </div>
                    <div class="col-lg-7 offset-lg-1">
                        <form action="post" class="contact-form">
                            <div class="row">
                                <div class="col-lg-6">
                                    <input type="text" placeholder="Your Name">
                                </div>

                                <div class="col-lg-6">
                                    <input type="text" placeholder="Your Email">
                                </div>

                                <div class="col-lg-12">
                                    <textarea placeholder="Your Message"></textarea>
                                    <button type="submit">Submit Now</button>

                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="map">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.0606825994123!2d-72.8735845851828!3d40.760690042573295!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89e85b24c9274c91%3A0xf310d41b791bcb71!2sWilliam%20Floyd%20Pkwy%2C%20Mastic%20Beach%2C%20NY%2C%20USA!5e0!3m2!1sen!2sbd!4v1578582744646!5m2!1sen!2sbd"
                        height="470" style="border:0;"
                        allowfullscreen=""></iframe>
                </div>
            </div>
        </section>
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
                            <div class="co-text"><p>Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                                    All rights reserved by 36Hotel
                                </p></div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <div class="search-model">
            <div class="h-100 d-flex align-items-center
                 justify-content-center">
                <div class="search-close-switch"><i class="icon_close"></i></div>
                <form class="search-model-form">
                    <input type="text" id="search-input" placeholder="Search here.....">
                </form>
            </div>
        </div>

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