<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zxx">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Receptionist Dashboard - 36 Hotel">
    <meta name="keywords" content="Receptionist, dashboard, hotel">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Dashboard - Receptionist | 36 Hotel</title>
    <!-- Google Fonts & System CSS như bills.jsp -->
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist-bills.css" type="text/css">
</head>
<body>
<c:set var="pageActive" value="dashboard"/>
<div class="d-flex" style="min-height:100vh;">
  <!-- Sidebar full height/width begin -->
  <nav class="sidebar d-flex flex-column col-lg-2 col-md-3 col-3 p-0 min-vh-100" style="background-color: #23242a;">
    <div class="sidebar-sticky flex-grow-1 d-flex flex-column">
      <div class="text-center mt-4 mb-4">
        <div style="font-family: 'Lora', serif; font-style:italic; font-weight:bold; font-size:2em; color:#dfa974; letter-spacing:1px;">Sona.</div>
        <a href="${pageContext.request.contextPath}/home">
          <img src="${pageContext.request.contextPath}/img/logo.png" alt="36 Hotel Logo" class="img-fluid mb-2" style="max-width:80px; height:auto; display:none;"/>
        </a>
        <h5 style="color:#dfa974; font-weight:bold; font-size:1.7em;">Reception Dashboard</h5>
      </div>
      <ul class="nav flex-column flex-grow-1">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/pages/receptionist/receptionist-dashboard.jsp" class="nav-link text-white font-weight-bold active" style="background-color:#dfa974; color:#fff;">
            <i class="fa fa-tachometer mr-2"></i> Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/receptionist/bills" class="nav-link text-white">
            <i class="fa fa-file-text-o mr-2"></i> Bills
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/receptionist/room-fees" class="nav-link text-white">
            <i class="fa fa-dollar mr-2"></i> Room Fees
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/receptionist/bookings" class="nav-link text-white">
            <i class="fa fa-calendar mr-2"></i> Bookings
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/receptionist/penalties" class="nav-link text-white">
            <i class="fa fa-gavel mr-2"></i> Penalties
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/receptionist/feedback" class="nav-link text-white">
            <i class="fa fa-comments mr-2"></i> Feedback
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/receptionist/rooms" class="nav-link text-white">
            <i class="fa fa-home mr-2"></i> Room List
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/profile" class="nav-link text-white">
            <i class="fa fa-user mr-2"></i> Profile
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/login" class="nav-link text-white">
            <i class="fa fa-sign-out mr-2"></i> Logout
          </a>
        </li>
      </ul>
      <div class="mt-auto mb-3"></div>
    </div>
  </nav>
  <!-- Sidebar end -->
  <!-- Main layout block: header, content (empty), footer -->
  <div class="flex-grow-1 d-flex flex-column">
      <!-- Header/Offcanvas/Menu Begin (y hệt bills.jsp) -->
      <div id="preloder"><div class="loader"></div></div>
      <div class="offcanvas-menu-overlay"></div>
      <div class="canvas-open"><i class="icon_menu"></i></div>
      <div class="offcanvas-menu-wrapper">
        <div class="canvas-close"><i class="icon_close"></i></div>
        <div class="search-icon search-switch"><i class="icon_search"></i></div>
        <div class="header-configure-area">
          <div class="language-option">
            <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
            <span>EN <i class="fa fa-angle-down"></i></span>
            <div class="flag-dropdown">
              <ul><li><a href="#">Zi</a></li><li><a href="#">Fr</a></li></ul>
            </div>
          </div>
          <a href="#" class="bk-btn">Booking Now</a>
        </div>
        <nav class="mainmenu mobile-menu">
          <ul>
        <li class="active"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
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
          <a href="#"><i class="fa fa-facebook"></i></a>
          <a href="#"><i class="fa fa-twitter"></i></a>
          <a href="#"><i class="fa fa-tripadvisor"></i></a>
          <a href="#"><i class="fa fa-instagram"></i></a>
        </div>
        <ul class="top-widget">
          <li><i class="fa fa-phone"></i> (12) 345 67890</li>
          <li><i class="fa fa-envelope"></i> info.colorlib@gmail.com</li>
        </ul>
      </div>
      <header class="header-section">
        <div class="top-nav">
          <div class="container">
            <div class="row">
              <div class="col-lg-6">
                <ul class="tn-left">
                  <li><i class="fa fa-phone"></i> (12) 345 67890</li>
                  <li><i class="fa fa-envelope"></i> info.colorlib@gmail.com</li>
                </ul>
              </div>
              <div class="col-lg-6">
                <div class="tn-right">
                  <div class="top-social">
                    <a href="#"><i class="fa fa-facebook"></i></a>
                    <a href="#"><i class="fa fa-twitter"></i></a>
                    <a href="#"><i class="fa fa-tripadvisor"></i></a>
                    <a href="#"><i class="fa fa-instagram"></i></a>
                  </div>
                  <a href="#" class="bk-btn">Booking Now</a>
                  <div class="language-option">
                    <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
                    <span>EN <i class="fa fa-angle-down"></i></span>
                    <div class="flag-dropdown">
                      <ul><li><a href="#">Zi</a></li><li><a href="#">Fr</a></li></ul>
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
                      <li class="${pageActive eq 'dashboard' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/pages/receptionist/receptionist-dashboard.jsp">Dashboard</a></li>
                      <li class="${pageActive eq 'bills' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/receptionist/bills">Bills</a></li>
                      <li class="${pageActive eq 'room-fees' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/receptionist/room-fees">Room Fees</a></li>
                      <li class="${pageActive eq 'bookings' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/receptionist/bookings">Bookings</a></li>
                      <li class="${pageActive eq 'penalties' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/receptionist/penalties">Penalties</a></li>
                      <li class="${pageActive eq 'feedback' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/receptionist/feedback">Feedback</a></li>
                      <li class="${pageActive eq 'room-list' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/receptionist/rooms">Room List</a></li>
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
      <div class="receptionist-header">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <h2><i class="fa fa-diamond"></i> Receptionist Dashboard</h2>
              <p>Quick overview & shortcut for daily receptionist management</p>
            </div>
          </div>
        </div>
      </div>
      <!-- Main content: chỉ là khoảng trắng -->
      <main class="flex-fill"></main>
      <!-- Footer Section Begin (giữ nguyên bills.jsp) -->
      <footer class="footer-section">
        <div class="container">
          <div class="footer-text">
            <div class="row">
              <div class="col-lg-4">
                <div class="ft-about">
                  <div class="logo">
                    <a href="#"><img src="${pageContext.request.contextPath}/img/footer-logo.png" alt=""></a>
                  </div>
                  <p>We inspire and reach millions of travelers<br /> across 90 local websites</p>
                  <div class="fa-social">
                    <a href="#"><i class="fa fa-facebook"></i></a>
                    <a href="#"><i class="fa fa-twitter"></i></a>
                    <a href="#"><i class="fa fa-tripadvisor"></i></a>
                    <a href="#"><i class="fa fa-instagram"></i></a>
                    <a href="#"><i class="fa fa-youtube-play"></i></a>
                  </div>
                </div>
              </div>
              <div class="col-lg-3 offset-lg-1">
                <div class="ft-contact">
                  <h6>Contact Us</h6>
                  <ul>
                    <li>(12) 345 67890</li>
                    <li>info.colorlib@gmail.com</li>
                    <li>856 Cordia Extension Apt. 356, Lake, United State</li>
                  </ul>
                </div>
              </div>
              <div class="col-lg-3 offset-lg-1">
                <div class="ft-newslatter">
                  <h6>New latest</h6>
                  <p>Get the latest updates and offers.</p>
                  <form action="#" class="fn-form">
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
                  <li><a href="#">Contact</a></li>
                  <li><a href="#">Terms of use</a></li>
                  <li><a href="#">Privacy</a></li>
                  <li><a href="#">Environmental Policy</a></li>
                </ul>
              </div>
              <div class="col-lg-5">
                <div class="co-text"><p>Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a></p></div>
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
      <!-- Js Plugins giống bills.jsp -->
      <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
      <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
      <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
      <script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
      <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
      <script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
      <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
      <script src="${pageContext.request.contextPath}/js/main.js"></script>
  </div>
</div>
</body>
</html>
