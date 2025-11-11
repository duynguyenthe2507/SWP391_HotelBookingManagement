<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
  File: checkout.jsp
  This is the Stage 3 (View)
  === FIX (11/11/2025) ===
  1. Added <c:forEach> loop to display selected services.
  2. Translated to English.
--%>
<!DOCTYPE html>
<html lang="en"> <%-- Changed to 'en' --%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>36 Hotel - Checkout</title> <%-- Translated --%>
    
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    
    <style>
        .checkout-container { max-width: 960px; margin: 40px auto; padding: 20px; }
        .checkout-section { background: #fdfdfd; border: 1px solid #eee; border-radius: 8px; padding: 25px; margin-bottom: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .checkout-section h3 { font-size: 22px; font-weight: 700; color: #333; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #dfa974; }
        .user-info p, .summary-item p { font-size: 16px; color: #555; margin-bottom: 10px; }
        .user-info p strong, .summary-item p strong { color: #333; min-width: 120px; display: inline-block; }
        .cart-item { display: flex; align-items: center; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px dotted #ccc; }
        .cart-item:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .cart-item img { width: 120px; height: 90px; object-fit: cover; border-radius: 6px; margin-right: 20px; }
        .cart-item-info h5 { font-size: 18px; font-weight: 600; margin: 0 0 10px 0; }
        .cart-item-info p { margin: 0; font-size: 15px; color: #666; }
        .summary-total { text-align: right; border-top: 2px solid #dfa974; padding-top: 20px; margin-top: 20px; }
        .summary-total h4 { font-size: 24px; font-weight: 700; color: #dfa974; }
        .payment-methods { padding: 15px; }
        .payment-methods .form-check { padding: 15px; border: 1px solid #ddd; border-radius: 6px; margin-bottom: 15px; cursor: pointer; transition: all 0.3s; }
        .payment-methods .form-check:hover { border-color: #dfa974; background-color: #fffaf5; }
        .payment-methods .form-check-input { margin-top: 6px; cursor: pointer; }
        .payment-methods .form-check-label { font-size: 16px; font-weight: 600; cursor: pointer; display: flex; align-items: center; }
        .payment-methods .form-check-label img { height: 24px; vertical-align: middle; margin-right: 8px; }
        .btn-proceed { width: 100%; padding: 15px; font-size: 18px; font-weight: 700; text-transform: uppercase; background-color: #dfa974; border: none; color: white; border-radius: 6px; transition: all 0.3s; cursor: pointer; }
        .btn-proceed:hover { background-color: #c7956d; }
        .alert-danger, .alert-warning, .alert-success { padding: 15px; margin-bottom: 20px; border-radius: 6px; border: 1px solid transparent; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border-color: #f5c6cb; }
        .alert-warning { background-color: #fff3cd; color: #856404; border-color: #ffeeba; }
        .alert-success { background-color: #d4edda; color: #155724; border-color: #c3e6cb; }
        .close-alert { float: right; font-size: 1.5rem; font-weight: bold; line-height: 1; color: inherit; text-shadow: 0 1px 0 #fff; opacity: .5; background: transparent; border: 0; padding: 0; cursor: pointer; }
        .close-alert:hover { opacity: .75; color: inherit; }
        
        /* === CSS FOR SERVICES === */
        .service-summary-list {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px dashed #eee;
        }
        .service-summary-item {
            display: flex;
            justify-content: space-between;
            font-size: 15px;
            color: #555;
            margin-bottom: 5px;
        }
        .service-summary-item .name {
            font-weight: 500;
        }
        .service-summary-item .price {
            font-weight: 600;
            color: #333;
        }
        /* === END CSS === */
        
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp"/>

    <div class="breadcrumb-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb-text">
                        <h2>Checkout</h2> <%-- Translated --%>
                        <div class="bt-option">
                            <a href="${pageContext.request.contextPath}/home">Home</a>
                            <span>Checkout</span> <%-- Translated --%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container checkout-container">
        
        <c:if test="${not empty sessionScope.cartMessage}">
             <div class="alert ${sessionScope.cartMessageType == 'ERROR' ? 'alert-danger' : (sessionScope.cartMessageType == 'WARNING' ? 'alert-warning' : 'alert-success')}" role="alert">
                 <button type="button" class="close-alert" onclick="this.parentElement.style.display='none';">&times;</button>
                <c:out value="${sessionScope.cartMessage}"/>
             </div>
             <% session.removeAttribute("cartMessage"); %>
             <% session.removeAttribute("cartMessageType"); %>
         </c:if>

        <c:url value="/order/create" var="orderActionUrl"/>
        <form action="${orderActionUrl}" method="POST">
            <div class="row">
                <div class="col-lg-7">
                    <!-- 1. Guest Information -->
                    <div class="checkout-section user-info">
                        <h3>Guest Information</h3> <%-- Translated --%>
                        <p><strong>Full Name:</strong> <c:out value="${requestScope.user.lastName} ${requestScope.user.middleName} ${requestScope.user.firstName}"/></p>
                        <p><strong>Email:</strong> <c:out value="${requestScope.user.email}"/></p>
                        <p><strong>Phone:</strong> <c:out value="${requestScope.user.mobilePhone}"/></p>
                    </div>

                    <!-- 2. Cart Details -->
                    <div class="checkout-section cart-details">
                        <h3>Booking Details</h3> <%-- Translated --%>
                        <c:forEach var="item" items="${requestScope.cart}">
                            <div class="cart-item">
                                <c:set var="imgSrc" value="${not empty item.roomImgUrl ? pageContext.request.contextPath.concat('/').concat(item.roomImgUrl) : pageContext.request.contextPath.concat('/img/placeholder.jpg')}"/>
                                <img src="${imgSrc}" 
                                     alt="${item.roomName}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';">
                                <div class="cart-item-info">
                                    <h5><c:out value="${item.roomName}"/></h5>
                                    <p>Guests: <c:out value="${item.guestCount}"/></p> <%-- Translated --%>
                                    <p>Price / night: <fmt:formatNumber value="${item.priceAtBooking}" pattern="#,##0"/> VND</p> <%-- Translated --%>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-lg-5">
                    <!-- 3. Order Summary -->
                    <div class="checkout-section summary-details">
                        <h3>Summary</h3> <%-- Translated --%>
                        <div class="summary-item">
                            
                            <p><strong>Check-in:</strong> 
                                <c:out value="${requestScope.cartCheckInFormatted}"/>
                            </p>
                            <p><strong>Check-out:</strong> 
                                <c:out value="${requestScope.cartCheckOutFormatted}"/>
                            </p>
                            
                            <p><strong>Nights:</strong> <%-- Translated --%>
                                <c:out value="${requestScope.numberOfNights}"/> nights
                            </p>
                            
                            <!-- === ADDED: Display Services === -->
                            <c:if test="${not empty requestScope.selectedServices}">
                                <div class="service-summary-list">
                                    <p style="margin-top: 15px;"><strong>Additional Services:</strong></p> <%-- Translated --%>
                                    <c:forEach var="service" items="${requestScope.selectedServices}">
                                        <div class="service-summary-item">
                                            <span class="name">${service.name}</span>
                                            <span class="price">
                                                <fmt:formatNumber value="${service.price}" pattern="#,##0"/>
                                            </span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                            <!-- === END ADDED === -->
                            
                            <div class="summary-total">
                                <h4>Total Price:</h4> <%-- Translated --%>
                                <h4><fmt:formatNumber value="${requestScope.totalPrice}" pattern="#,##0"/> VND</h4>
                                <span style="font-size: 13px; color: #888;">(Estimated price, may change with extra services)</span> <%-- Translated --%>
                            </div>
                        </div>
                    </div>

                    <!-- 4. Payment Method -->
                    <div class="checkout-section payment-methods">
                        <h3>Payment</h3>
                        
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="paymentVNPAY" value="VNPAY" required checked>
                            <label class="form-check-label" for="paymentVNPAY">
                                <img src="${pageContext.request.contextPath}/img/vnpay-logo.png" alt="VNPAY">
                                VNPAY Payment
                            </label>
                        </div>

                        <button type="submit" class="btn-proceed mt-3">
                             <i class="fa fa-check-circle"></i> Confirm Booking
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <jsp:include page="/common/footer.jsp"/>

    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>