<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
  File: checkout.jsp
  Đây là trang Giai đoạn 3 (View)
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>36 Hotel - Thanh Toán</title>
    
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    
    <%-- (Copy style từ file bạn gửi) --%>
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
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp"/>

    <div class="breadcrumb-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb-text">
                        <h2>Thanh Toán</h2>
                        <div class="bt-option">
                            <a href="${pageContext.request.contextPath}/home">Home</a>
                            <span>Thanh Toán</span>
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
                    <!-- 1. Thông tin người đặt -->
                    <div class="checkout-section user-info">
                        <h3>Thông tin Người đặt</h3>
                        <p><strong>Họ và tên:</strong> <c:out value="${requestScope.user.lastName} ${requestScope.user.middleName} ${requestScope.user.firstName}"/></p>
                        <p><strong>Email:</strong> <c:out value="${requestScope.user.email}"/></p>
                        <p><strong>Số điện thoại:</strong> <c:out value="${requestScope.user.mobilePhone}"/></p>
                    </div>

                    <!-- 2. Chi tiết Giỏ hàng -->
                    <div class="checkout-section cart-details">
                        <h3>Chi tiết Đặt phòng</h3>
                        <c:forEach var="item" items="${requestScope.cart}">
                            <div class="cart-item">
                                <c:set var="imgSrc" value="${not empty item.roomImgUrl ? pageContext.request.contextPath.concat('/').concat(item.roomImgUrl) : pageContext.request.contextPath.concat('/img/placeholder.jpg')}"/>
                                <img src="${imgSrc}" 
                                     alt="${item.roomName}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/img/placeholder.jpg';">
                                <div class="cart-item-info">
                                    <h5><c:out value="${item.roomName}"/></h5>
                                    <p>Số khách: <c:out value="${item.guestCount}"/></p>
                                    <p>Giá / đêm: <fmt:formatNumber value="${item.priceAtBooking}" pattern="#,##0"/> VND</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-lg-5">
                    <!-- 3. Tóm tắt Đơn hàng -->
                    <div class="checkout-section summary-details">
                        <h3>Tóm tắt</h3>
                        <div class="summary-item">
                            
                            <!-- === SỬA LỖI: Bỏ fmt:formatDate, dùng String đã định dạng === -->
                            <p><strong>Check-in:</strong> 
                                <c:out value="${requestScope.cartCheckInFormatted}"/>
                            </p>
                            <p><strong>Check-out:</strong> 
                                <c:out value="${requestScope.cartCheckOutFormatted}"/>
                            </p>
                            <!-- === KẾT THÚC SỬA LỖI === -->
                            
                            <p><strong>Số đêm:</strong> 
                                <c:out value="${requestScope.numberOfNights}"/> đêm
                            </p>
                            
                            <div class="summary-total">
                                <h4>Tổng cộng:</h4>
                                <h4><fmt:formatNumber value="${requestScope.totalPrice}" pattern="#,##0"/> VND</h4>
                                <span style="font-size: 13px; color: #888;">(Giá tạm tính, có thể thay đổi nếu có dịch vụ phát sinh)</span>
                            </div>
                        </div>
                    </div>

                    <!-- 4. Phương thức Thanh toán -->
                    <div class="checkout-section payment-methods">
                        <h3>Chọn Phương thức Thanh toán</h3>
                        
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="paymentCOD" value="COD" required checked>
                            <label class="form-check-label" for="paymentCOD">
                                <i class="fa fa-money" style="margin-right: 8px;"></i> Thanh toán tại khách sạn (COD)
                            </label>
                        </div>
                        
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="paymentVNPAY" value="VNPAY" required>
                            <label class="form-check-label" for="paymentVNPAY">
                                <img src="${pageContext.request.contextPath}/img/vnpay-logo.png" alt="VNPAY">
                                Thanh toán qua VNPAY
                            </label>
                        </div>

                        <button type="submit" class="btn-proceed mt-3">
                             <i class="fa fa-check-circle"></i> Xác nhận Đặt phòng
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

