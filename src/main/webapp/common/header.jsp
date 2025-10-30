<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header class="header-section">
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
                            <a href="#"><i class="fa fa-facebook"></i></a>
                            <a href="#"><i class="fa fa-twitter"></i></a>
                            <a href="#"><i class="fa fa-tripadvisor"></i></a>
                            <a href="#"><i class="fa fa-instagram"></i></a>
                        </div>
                        <% if (session.getAttribute("loggedInUser") == null) { %>
                        <a href="${pageContext.request.contextPath}/login" class="bk-btn">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="bk-btn">Be our member</a>
                        <% } else { %>
                        <div class="dropdown" style="display: inline-block; position: relative">
                            <a href="${pageContext.request.contextPath}/profile" class="bk-btn" style="padding: -1px 0px">
                                Profile
                            </a>
                        </div>
                        <a href="${pageContext.request.contextPath}/cart" class="bk-btn" style="padding: -1px 0px; margin-left: 5px;">Cart</a>
                        <a href="${pageContext.request.contextPath}/wishlist" class="bk-btn" style="padding: -1px 0px; margin-left: 5px;">Wishlist</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="menu-item">
        <div class="container">
            <div class="row">
                <div class="col-lg-2" style="padding: 0; margin-bottom: 0;">
                    <div class="logo" style="padding: 0; margin: 0 0; text-align: center;">
                        <a href="${pageContext.request.contextPath}/home">
                            <img src="${pageContext.request.contextPath}/img/36x.png" alt="36 Hotel Logo"
                                 style="width: 60px; height: auto; display: block; max-width: 100%; object-fit: contain;
                                 transition: transform 0.3s ease; margin: 0 auto; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);"
                                 onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
                        </a>
                    </div>
                </div>
                <div class="col-lg-10">
                    <div class="nav-menu">
                        <nav class="mainmenu">
                            <ul>
                                <li class="active"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                                <li><a href="${pageContext.request.contextPath}/rules">Rules</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>