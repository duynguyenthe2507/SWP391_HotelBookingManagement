<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en"> <%-- Translated lang --%>
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
        /* (Your original CSS)... */
        
        /* === NEW CSS === */
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
            /* Add transition for new reviews */
            opacity: 1;
            transform: scale(1);
            transition: all 0.5s ease-out;
        }
        /* Style for new reviews (used by JS) */
        .review-item.new-review {
            opacity: 0;
            transform: scale(0.95);
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
            font-size: 16px; /* Added size */
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
        /* CSS for Star Rating */
        .star-rating {
            direction: rtl; /* Flip to color from right to left */
            display: inline-block;
            padding: 0;
            margin-bottom: 15px;
        }
        .star-rating input[type=radio] {
            display: none;
        }
        .star-rating label {
            color: #ddd; /* Empty star color */
            font-size: 30px;
            padding: 0 3px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .star-rating input[type=radio]:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #dfa974; /* Selected or hover star color */
        }

        /* Login/Permission Message */
        .review-permission-box {
            text-align: center;
            padding: 20px;
            background-color: #fffaf0;
            border: 1px solid #ffeeba;
            border-radius: 8px;
            color: #856404;
        }
        .review-permission-box a {
            color: #dfa974;
            font-weight: 600;
            text-decoration: underline;
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
        
        /* === NEW CSS FOR SERVICES & TOTAL PRICE === */
        .services-list {
            max-height: 200px;
            overflow-y: auto;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
        }
        .service-item {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }
         .service-item:last-child {
             margin-bottom: 0;
         }
        .service-item input[type="checkbox"] {
            width: auto;
            margin-right: 12px;
            transform: scale(1.2);
        }
        .service-item label {
            margin-bottom: 0;
            font-weight: 500;
            font-size: 15px;
            color: #555;
            flex: 1;
            cursor: pointer;
        }
         .service-item .service-price {
            font-weight: 600;
             color: #333;
             font-size: 14px;
         }

        .total-price-display {
            margin-top: 30px;
            padding-top: 25px;
            border-top: 2px dashed #dfa974;
        }
        .total-price-display h4 {
            font-size: 18px;
            font-weight: 600;
            color: #666;
            margin-bottom: 10px;
        }
        .total-price-display h3 {
            font-size: 30px;
            font-weight: 700;
            color: #dfa974;
            margin: 0;
        }
        /* === END NEW CSS === */
        
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
            
            <%-- === NEW SECTION: Display alerts (Add to cart success/fail) === --%>
            <c:if test="${not empty sessionScope.cartMessage}">
                <div class="alert ${sessionScope.cartMessageType == 'ERROR' ? 'alert-danger' : (sessionScope.cartMessageType == 'WARNING' ? 'alert-warning' : 'alert-success')}" role="alert">
                     <button type="button" class="close-alert" onclick="this.parentElement.style.display='none';">&times;</button>
                    <c:out value="${sessionScope.cartMessage}"/>
                </div>
                <%-- Clear message from session after displaying --%>
                <% session.removeAttribute("cartMessage"); %>
                <% session.removeAttribute("cartMessageType"); %>
            </c:if>
            <%-- === END NEW SECTION === --%>

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
                                    <%-- Translated Placeholder --%>
                                    <p>Welcome to our premium room. This space is designed for your comfort and relaxation. 
                                       Enjoy top-tier amenities, a beautiful view, and our 24/7 room service. 
                                       We hope you have a wonderful stay with us at 36 Hotel.</p>
                                </div>
                            </div>

                            <!-- === REVIEW SECTION (MODIFIED) === -->
                            <div class="rd-reviews">
                                <h4>Reviews</h4>
                                <div id="review-list-container">
                                    <%-- Display existing reviews --%>
                                    <c:if test="${empty feedbackList}">
                                        <p id="no-reviews-message">There are no reviews for this room yet. Be the first!</p>
                                    </c:if>
                                    
                                    <c:forEach var="fb" items="${feedbackList}">
                                        <div class="review-item">
                                            <div class="ri-pic">
                                                <c:set var="avatar" value="${not empty fb.userAvatarUrl ? fb.userAvatarUrl : pageContext.request.contextPath.concat('/img/room/avatar/default-avatar.png')}"/>
                                                <img src="${avatar}" alt="${fb.userFirstName}">
                                            </div>
                                            <div class="ri-text">
                                                <%-- === FIX (Line 406): Use .format() instead of <fmt:formatDate> === --%>
                                                <span>${fb.createdAt.format(myDateFormatter)}</span>
                                                <div class="rating">
                                                    <c:forEach begin="1" end="${fb.rating}">
                                                        <i class="fa fa-star"></i>
                                                    </c:forEach>
                                                    <c:forEach begin="${fb.rating + 1}" end="5">
                                                        <i class="fa fa-star-o"></i>
                                                    </c:forEach>
                                                </div>
                                                <h5>${fb.userFirstName} ${fb.userLastName}</h5>
                                                <p>${fb.content}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <%-- "View More" Button (Hidden for future logic) --%>
                                <!-- 
                                <div class="text-center" style="margin-top: 20px;">
                                    <a href="#" class="btn btn-primary btn-sm">View More</a>
                                </div> 
                                -->
                            </div>

                            <!-- === ADD REVIEW SECTION (MODIFIED) === -->
                            <div class="review-add">
                                <h4>Add Review</h4>
                                
                                <!-- AJAX Success/Error Message -->
                                <div id="review-message" style="display: none; margin-bottom: 20px;"></div>

                                <c:choose>
                                    <%-- 1. Has permission to review --%>
                                    <c:when test="${canReviewBookingId > 0}">
                                        <form action="#" id="review-form" class="ra-form">
                                            <!-- Store bookingId to send via AJAX -->
                                            <input type="hidden" id="review-booking-id" value="${canReviewBookingId}">
                                            <div class="star-rating">
                                                <input type="radio" id="star5" name="rating" value="5" required/><label for="star5" title="5 stars">★</label>
                                                <input type="radio" id="star4" name="rating" value="4" required/><label for="star4" title="4 stars">★</label>
                                                <input type="radio" id="star3" name="rating" value="3" required/><label for="star3" title="3 stars">★</label>
                                                <input type="radio" id="star2" name="rating" value="2" required/><label for="star2" title="2 stars">★</label>
                                                <input type="radio" id="star1" name="rating" value="1" required/><label for="star1" title="1 star">★</label>
                                            </div>
                                            
                                            <textarea id="review-content" placeholder="Your review" required></textarea>
                                            <button type="submit" id="submit-review-btn">Submit Review</button>
                                        </form>
                                    </c:when>
                                    
                                    <%-- 2. Logged in but no permission --%>
                                    <c:when test="${not empty sessionScope.user && canReviewBookingId == 0}">
                                        <div class="review-permission-box">
                                            You can only review this room after completing (checking-out) a booking.
                                        </div>
                                    </c:when>
                                    
                                    <%-- 3. Not logged in --%>
                                    <c:otherwise>
                                        <div class="review-permission-box">
                                            Please <a href="${pageContext.request.contextPath}/login?redirectUrl=${pageContext.request.contextPath}/room-details?roomId=${room.roomId}">login</a> and complete a booking to review this room.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                            </div>
                            <!-- === END REVIEW SECTION (MODIFIED) === -->
                            
                        </div>

                        <!-- Right Column: Booking Form -->
                        <div class="col-lg-4">
                            <div class="room-booking">
                                <h3>Your Reservation</h3>
                                
                                <c:url value="/booking/add" var="addToBookingUrl"/>
                                <form action="${addToBookingUrl}" method="POST" id="booking-form">
                                    
                                    <input type="hidden" name="roomId" value="${room.roomId}">
                                    <input type="hidden" id="base-room-price" value="${room.price}">
                                    
                                    <div class="check-date">
                                        <label for="date-in">Check In:</label>
                                        <input type="text" class="date-input" id="date-in" name="checkInDate" required autocomplete="off">
                                        <i class="icon_calendar"></i>
                                    </div>
                                    <div class="check-date">
                                        <label for="date-out">Check Out:</label>
                                        <input type="text" class="date-input" id="date-out" name="checkOutDate" required autocomplete="off">
                                        <i class="icon_calendar"></i>
                                    </div>
                                    <div class="select-option">
                                        <label for="guest">Guests:</label>
                                        <select id="guest" name="numGuests"> 
                                            <c:forEach begin="1" end="${room.capacity}" var="i">
                                                <option value="${i}">${i} Adult(s)</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- === NEW SECTION: SERVICES LIST === -->
                                    <div class="select-option">
                                        <label>Additional Services:</label>
                                        <div class="services-list">
                                            <c:if test="${empty servicesList}">
                                                <p>No additional services available.</p>
                                            </c:if>
                                            <c:forEach var="service" items="${servicesList}">
                                                <div class="service-item">
                                                    <input type="checkbox" 
                                                           name="serviceIds" 
                                                           id="service-${service.serviceId}" 
                                                           value="${service.serviceId}"
                                                           data-price="${service.price}"
                                                           class="service-checkbox">
                                                    <label for="service-${service.serviceId}">
                                                        ${service.name}
                                                    </label>
                                                    <span class="service-price">
                                                        <fmt:formatNumber value="${service.price}" pattern="#,##0"/>
                                                    </span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <!-- === END NEW SECTION === -->
                                    
                                    <!-- === NEW SECTION: TOTAL PRICE DISPLAY === -->
                                    <div class="total-price-display">
                                        <h4>Total Price:</h4>
                                        <h3 id="booking-total-price">
                                            <fmt:formatNumber value="${room.price}" pattern="#,##0"/> VND
                                        </h3>
                                    </div>
                                    <!-- === END NEW SECTION === -->
                                    
                                    <button type="submit">Add to Booking</button>
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

    <!-- === PRICE CALCULATION & REVIEW SCRIPT === -->
    <script>
        $(document).ready(function () {
            
            // ===================================
            // 1. TOTAL PRICE CALCULATION (BOOKING)
            // ===================================
            
            // Ensure room price exists before parsing
            const baseRoomPriceEl = $('#base-room-price');
            const baseRoomPrice = baseRoomPriceEl.length ? parseFloat(baseRoomPriceEl.val()) : 0;
            
            const checkInInput = $('#date-in');
            const checkOutInput = $('#date-out');
            const totalDisplay = $('#booking-total-price');

            function parseDate(dateStr) {
                if (!dateStr) return null;
                var parts = dateStr.split('/');
                // (Month in JS is 0-indexed)
                return new Date(parts[2], parts[1] - 1, parts[0]);
            }
            
            function formatCurrency(value) {
                return new Intl.NumberFormat('en-US').format(value) + ' VND';
            }

            function calculateTotal() {
                if (!baseRoomPriceEl.length) return; // Don't run if there's no room

                let checkInDate = parseDate(checkInInput.val());
                let checkOutDate = parseDate(checkOutInput.val());
                let numNights = 0;

                if (checkInDate && checkOutDate && checkOutDate > checkInDate) {
                    const diffTime = Math.abs(checkOutDate.getTime() - checkInDate.getTime());
                    numNights = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                } else if (checkInDate || checkOutDate) {
                     numNights = 1; // Default to 1 night if only one date is selected
                } else if (checkInDate && checkOutDate && checkInDate.getTime() === checkOutDate.getTime()) {
                    numNights = 1; // Check-in and check-out on the same day = 1 night
                } else {
                    numNights = 1; // Default (no date selected)
                }
                
                let totalRoomPrice = baseRoomPrice * numNights;
                let totalServicesPrice = 0;
                
                // Use the selector for checked checkboxes
                $('.service-checkbox:checked').each(function() {
                    totalServicesPrice += parseFloat($(this).data('price'));
                });

                // === SỬA LỖI (13/11/2025): Nhân tiền dịch vụ với số đêm ===
                let finalServicesPrice = totalServicesPrice * numNights;

                // Tính tổng
                let grandTotal = totalRoomPrice + finalServicesPrice;
                totalDisplay.text(formatCurrency(grandTotal));
            }

            $(".date-input").datepicker({
                dateFormat: 'dd/mm/yy',
                minDate: 0,
                onSelect: function(selectedDate) {
                    var instance = $(this).data("datepicker");
                    var date = $.datepicker.parseDate(instance.settings.dateFormat, selectedDate, instance.settings);
                    
                     if (this.id === "date-in") {
                        var dateOutVal = $("#date-out").val();
                        if (dateOutVal) {
                             var dateOut = $.datepicker.parseDate(instance.settings.dateFormat, dateOutVal, instance.settings);
                             if (dateOut <= date) { // Fix: <=
                                 $("#date-out").val("");
                             }
                        }
                         var nextDay = new Date(date);
                         nextDay.setDate(nextDay.getDate() + 1);
                         $("#date-out").datepicker("option", "minDate", nextDay);
                         
                     } else if (this.id === "date-out") {
                         var prevDay = new Date(date);
                         prevDay.setDate(prevDay.getDate() - 1);
                         $("#date-in").datepicker("option", "maxDate", prevDay);
                     }
                    calculateTotal();
                }
            });
            
            // === FIX: Use Event Delegation ===
            $(document).on('change', '.service-checkbox', calculateTotal);
            // === END FIX ===

            // Initialize nice select AFTER datepicker
            if ($('select').length) {
                $('select').niceSelect();
            }
            
            $(window).on('load', function() {
                $("#preloder").fadeOut("slow");
                $("body").removeClass("hidden-overflow");
            });
            $("body").addClass("hidden-overflow");
            
            // Initial calculation on page load
            calculateTotal();

            // ===================================
            // 2. SUBMIT REVIEW LOGIC (AJAX)
            // ===================================
            
            const reviewForm = $('#review-form');
            const submitBtn = $('#submit-review-btn');
            const reviewMessage = $('#review-message');
            const reviewListContainer = $('#review-list-container');
            const noReviewsMessage = $('#no-reviews-message');

            reviewForm.on('submit', function(e) {
                e.preventDefault(); // Prevent traditional form submission
                
                // Get data
                const bookingId = parseInt($('#review-booking-id').val());
                const ratingInput = $('input[name="rating"]:checked'); // Get the input
                const content = $('#review-content').val().trim();
                const addReviewUrl = '${pageContext.request.contextPath}/user/add-review';
                
                // Validate rating
                if (ratingInput.length === 0) {
                    reviewMessage.removeClass('alert-success').addClass('alert-danger').text('Error: Please select a star rating.').show();
                    return;
                }
                const rating = parseInt(ratingInput.val());

                // Disable button
                submitBtn.prop('disabled', true).text('Submitting...');
                reviewMessage.hide().removeClass('alert-danger alert-success');

                // Data to send
                const data = {
                    bookingId: bookingId,
                    rating: rating,
                    content: content
                };

                // Send AJAX
                fetch(addReviewUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(data)
                })
                .then(response => {
                    if (!response.ok) {
                        // If server returns an error (401, 400, 500)
                        return response.json().then(err => { throw new Error(err.error || 'Unknown error occurred'); });
                    }
                    return response.json(); // Return JSON of the new review
                })
                .then(newReview => {
                    // SUCCESS!
                    // 1. Show success message
                    reviewMessage.addClass('alert-success').text('Review submitted successfully!').show();
                    // 2. Hide form
                    reviewForm.hide();
                    // 3. Prepend new review to the list
                    prependNewReview(newReview);
                    // 4. Remove "No reviews" message (if present)
                    if(noReviewsMessage.length) noReviewsMessage.hide();
                })
                .catch(error => {
                    // FAILURE!
                    reviewMessage.addClass('alert-danger').text('Error: ' + error.message).show();
                    submitBtn.prop('disabled', false).text('Submit Review');
                });
            });
            
            // Helper function to create new review HTML
            function prependNewReview(fb) {
                // Create stars
                let starsHtml = '';
                for (let i = 0; i < fb.rating; i++) {
                    starsHtml += '<i class="fa fa-star"></i>';
                }
                for (let i = fb.rating; i < 5; i++) {
                    starsHtml += '<i class="fa fa-star-o"></i>';
                }
                
                // === FIX: Handle ISO Date String ===
                // fb.createdAt is an ISO string (e.g., "2025-11-11T14:30:00")
                // Replace "T" with a space to make it compatible across browsers
                const date = new Date(fb.createdAt.replace("T", " ")); 
                const formattedDate = date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });

                // Get avatar (fallback)
                const avatar = fb.userAvatarUrl ? fb.userAvatarUrl : '${pageContext.request.contextPath}/img/room/avatar/default-avatar.png';
                
                // Create HTML
                const reviewHtml = `
                    <div class="review-item new-review">
                        <div class="ri-pic">
                            <img src="${avatar}" alt="${fb.userFirstName}">
                        </div>
                        <div class="ri-text">
                            <span>${formattedDate}</span>
                            <div class="rating">${starsHtml}</div>
                            <h5>${fb.userFirstName} ${fb.userLastName}</h5>
                            <p>${fb.content}</p>
                        </div>
                    </div>
                `;
                
                // Prepend to list
                reviewListContainer.prepend(reviewHtml);
                
                // Trigger animation (fade in)
                setTimeout(() => {
                    reviewListContainer.find('.review-item.new-review').first().css({
                        'opacity': '1',
                        'transform': 'scale(1)'
                    });
                }, 100);
            }
        });
    </script>
    <!-- === END NEW SCRIPT === -->

</body>
</html>