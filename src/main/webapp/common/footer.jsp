<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="footer-section" style="margin-top: 60px; background-color: #eae1df">
    <div class="container">
        <div class="footer-text">
            <div class="row">
                <div class="col-lg-4">
                    <div class="ft-about">
                        <div class="logo">
                            <a href="#">
                                <img src="${pageContext.request.contextPath}/img/36x.png" alt="36 Hotel Logo"
                                     style="width: 70px; height: auto; display: block; max-width: 100%; object-fit: contain;
                                     transition: transform 0.3s ease; margin: 0 auto; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);"
                                     onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
                            </a>
                        </div>
                        <p style="color: #000000">We inspire and reach millions of travelers<br /> across 90 local websites</p>
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
                            <li style="color: #000000">(84) 359 797 703</li>
                            <li style="color: #000000">36hotel@gmail.com</li>
                            <li style="color: #000000">Thanh Hoa, Viet Nam</li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-3 offset-lg-1">
                    <div class="ft-newslatter">
                        <h6>New latest</h6>
                        <p style="color: #000000">Get the latest updates and offers.</p>

                        <form action="${pageContext.request.contextPath}/subscribe" method="post" class="fn-form">
                            <input type="email" name="email" placeholder="Email" required>
                            <button type="submit"><i class="fa fa-send"></i></button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="copyright-option" style="background-color: #e4d7d6">
        <div class="container">
            <div class="row">
                <div class="col-lg-7">
                    <ul>
                        <li><a href="#" style="color: #000000">Contact</a></li>
                        <li><a href="#" style="color: #000000">Terms of use</a></li>
                        <li><a href="#" style="color: #000000">Privacy</a></li>
                        <li><a href="#" style="color: #000000">Environmental Policy</a></li>
                    </ul>
                </div>
                <div class="col-lg-5">
                    <div class="co-text">
                        <p style="color: #000000">
                            Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                            All rights reserved by 36 Hotel
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>