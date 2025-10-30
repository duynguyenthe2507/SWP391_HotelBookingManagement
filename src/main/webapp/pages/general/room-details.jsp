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
        body.hidden-overflow {
            overflow: hidden;
        }
        .alert-danger, .alert-warning, .alert-success {
            padding: 20px;
            margin: 20px 0;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid transparent;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }
         .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border-color: #ffeeba;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
        .alert-danger h4, .alert-warning h4, .alert-success h4 {
            margin-bottom: 15px;
            font-size: 20px;
        }
        .alert-danger p, .alert-warning p, .alert-success p {
            margin-bottom: 10px;
            line-height: 1.6;
        }
         .close-alert {
            float: right;
            font-size: 1.5rem;
            font-weight: bold;
            line-height: 1;
            color: inherit;
            text-shadow: 0 1px 0 #fff;
            opacity: .5;
            background: transparent;
            border: 0;
            padding: 0;
            cursor: pointer;
        }
        .close-alert:hover {
            opacity: .75;
            color: inherit;
        }
        .text-center { text-align: center; }
        .mt-3 { margin-top: 1.5rem !important; }
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
        .room-details-section { padding: 60px 0; }
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
        .rdt-right { text-align: right; }
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
            text-decoration: none;
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
        .rd-text table tr { background-color: #f8f9fa; }
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
        .room-booking .select-option { margin-bottom: 25px; }
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
        .review-item .ri-pic { margin-right: 20px; }
        .review-item .ri-pic img {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
        }
        .review-item .ri-text { flex: 1; }
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
            text-decoration: none;
        }
        .bt-option a:hover { color: #dfa974; }
        @media (max-width: 991px) {
            .room-booking { margin-top: 40px; position: static; }
            .rd-title { flex-direction: column; align-items: flex-start; }
            .rdt-right { text-align: left; margin-top: 15px; }
        }
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp"/>

    <div class="breadcrumb-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb-text">
                        <h2><c:out value="${not empty room ? room.name : 'Room Details'}"/></h2>
                        <div class="bt-option">
                            <c:url value="/home" var="homeBreadcrumbUrl"/>
                            <a href="${homeBreadcrumbUrl}">Home</a>
                            <c:url value="/rooms" var="roomsBreadcrumbUrl"/>
                            <a href="${roomsBreadcrumbUrl}">Rooms</a>
                            <span><c:out value="${not empty room ? room.name : 'Details'}"/></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section class="room-details-section spad">
        <div class="container">
            
            <%-- === PHẦN THÊM MỚI: Hiển thị thông báo (Thêm vào giỏ thành công/thất bại) === --%>
            <c:if test="${not empty sessionScope.cartMessage}">
                <div class="alert ${sessionScope.cartMessageType == 'ERROR' ? 'alert-danger' : (sessionScope.cartMessageType == 'WARNING' ? 'alert-warning' : 'alert-success')}" role="alert">
                     <button type="button" class="close-alert" onclick="this.parentElement.style.display='none';">&times;</button>
                    <c:out value="${sessionScope.cartMessage}"/>
                </div>
                <%-- Xóa thông báo khỏi session sau khi hiển thị --%>
                <% session.removeAttribute("cartMessage"); %>
                <% session.removeAttribute("cartMessageType"); %>
            </c:if>
            <%-- === KẾT THÚC PHẦN THÊM MỚI === --%>

            <c:choose>
                <c:when test="${not empty room}">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="room-details-item">
                                <c:set var="imgSrc" value="${not empty room.imgUrl ? pageContext.request.contextPath.concat('/').concat(room.imgUrl) : pageContext.request.contextPath.concat('/img/placeholder.jpg')}"/>
                                <img src="${imgSrc}"
                                     alt="${room.name}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';">
                                
                                <div class="rd-text">
                                    <div class="rd-title">
                                        <h3><c:out value="${room.name}"/></h3>
                                        <%-- Đã bỏ nút "Booking Now" ở đây vì form ở bên phải --%>
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

                            <div class="rd-reviews">
                                <h4>Reviews</h4>
                                <div class="review-item">
                                    <div class="ri-pic">
                                        <img src="${pageContext.request.contextPath}/img/room/avatar/default-avatar.png" alt="">
                                    </div>
                                    <div class="ri-text">
                                        <span>27 Aug 2025</span>
                                        <div class="rating">...</div>
                                        <h5>Brandon Kelley</h5>
                                        <p>...</p>
                                    </div>
                                </div>
                            </div>

                            <div class="review-add">
                                <h4>Add Review</h4>
                                <form action="post" class="ra-form">
                                    <%-- Form thêm review (giữ nguyên như code của bạn) --%>
                                </form>
                            </div>
                        </div>

                        <!-- Right Column: Booking Form -->
                        <div class="col-lg-4">
                            <div class="room-booking">
                                <h3>Your Reservation</h3>
                                
                                <%-- === PHẦN SỬA ĐỔI QUAN TRỌNG: Cập nhật form === --%>
                                <c:url value="/booking/add" var="addToBookingUrl"/>
                                <form action="${addToBookingUrl}" method="POST">
                                    
                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                    
                                    <div class="check-date">
                                        <label for="date-in">Check In:</label>
                                        <input type="text" class="date-input" id="date-in" name="checkInDate" required>
                                        <i class="icon_calendar"></i>
                                    </div>
                                    <div class="check-date">
                                        <label for="date-out">Check Out:</label>
                                        <input type="text" class="date-input" id="date-out" name="checkOutDate" required>
                                        <i class="icon_calendar"></i>
                                    </div>
                                    <div class="select-option">
                                        <label for="guest">Guests:</label>
                                        <select id="guest" name="numGuests"> <%-- Thêm name attribute --%>
                                            <c:forEach begin="1" end="${room.capacity}" var="i">
                                                <option value="${i}">${i} Adult(s)</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <%-- Đã xóa bỏ phần <select id="room"> (chọn "1 Room") --%>
                                    
                                    <button type="submit">Add to Booking</button> <%-- Đổi text nút --%>
                                </form>
                                <%-- === KẾT THÚC PHẦN SỬA ĐỔI === --%>
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

    <jsp:include page="/common/footer.jsp"/>

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
                dateFormat: 'dd/mm/yy', // Giữ nguyên format này, BookingController sẽ xử lý
                minDate: 0, // Vẫn giữ minDate
                onSelect: function(selectedDate) {
                    var option = this.id == "date-in" ? "minDate" : "maxDate";
                    var instance = $(this).data("datepicker");
                    var date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
                    
                    // Cập nhật min/max cho datepicker còn lại
                     if (this.id === "date-in") {
                        // Nếu date-out đã có giá trị, và giá trị đó trước ngày check-in mới, thì xóa date-out
                        var dateOutVal = $("#date-out").val();
                        if (dateOutVal) {
                             var dateOut = $.datepicker.parseDate(instance.settings.dateFormat, dateOutVal, instance.settings);
                             if (dateOut < date) {
                                $("#date-out").val("");
                             }
                        }
                         $("#date-out").datepicker("option", "minDate", date);
                    } else if (this.id === "date-out") {
                         $("#date-in").datepicker("option", "maxDate", date);
                    }
                }
            });
            
            // Initialize nice select
            $('select').niceSelect();

             // Preloader logic (simplified)
            $(window).on('load', function() {
                $("#preloder").fadeOut("slow");
                $("body").removeClass("hidden-overflow");
            });
            $("body").addClass("hidden-overflow");
        });
    </script>
</body>
</html>