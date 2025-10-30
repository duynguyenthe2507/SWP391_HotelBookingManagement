<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>36 Hotel - Kết quả Thanh toán</title>
    
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">

    <style>
        .result-section { padding: 80px 0; min-height: 70vh; display: flex; align-items: center; background-color: #f8f9fa; }
        .result-container { text-align: center; background: #fff; padding: 50px 40px; border-radius: 10px; box-shadow: 0 5px 25px rgba(0,0,0,0.1); max-width: 700px; margin: auto; }
        .result-icon { width: 80px; height: 80px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 25px; }
        .result-icon.success { background: #28a745; }
        .result-icon.error { background: #dc3545; }
        .result-icon.cod { background: #007bff; }
        .result-icon i { font-size: 40px; color: white; }
        .result-container h1 { font-size: 32px; margin-bottom: 15px; font-weight: 700; }
        .result-container h1.success { color: #28a745; }
        .result-container h1.error { color: #dc3545; }
        .result-container h1.cod { color: #007bff; }
        .result-container p { font-size: 16px; color: #666; margin-bottom: 15px; line-height: 1.7; }
        .transaction-details { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 25px 0; text-align: left; border: 1px solid #eee; }
        .transaction-details h3 { font-size: 18px; color: #333; margin-bottom: 15px; font-weight: 600; border-bottom: 1px solid #ddd; padding-bottom: 10px; }
        .detail-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; }
        .detail-label { font-weight: 600; color: #555; margin-right: 10px; }
        .detail-value { color: #333; word-break: break-all; }
        .detail-value.status-success { color: #28a745; font-weight: bold; }
        .detail-value.status-error { color: #dc3545; font-weight: bold; }
        .detail-value.status-pending { color: #007bff; font-weight: bold; }
        .action-buttons { margin-top: 30px; }
        .btn { padding: 10px 30px; font-size: 14px; font-weight: 600; text-transform: uppercase; border-radius: 5px; margin: 0 8px; transition: all 0.3s; text-decoration: none !important; display: inline-block; border: 2px solid transparent; }
        .btn-primary { background: #dfa974; color: white; border-color: #dfa974; }
        .btn-primary:hover { background: #c7956d; border-color: #c7956d; color: white; }
        .btn-secondary { background: transparent; color: #333; border-color: #ddd; }
        .btn-secondary:hover { border-color: #333; color: #333; }
        .alert-warning { background: #fff3cd; border: 1px solid #ffeeba; color: #856404; padding: 15px; border-radius: 5px; margin-top: 20px; text-align: left; }
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp"/>

    <section class="result-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-10 offset-lg-1">
                    <div class="result-container">

                        <c:set var="vnp_ResponseCode" value="${param.vnp_ResponseCode}"/>
                        <c:set var="isCodSuccess" value="${param.cod == 'true' && param.RspCode == '00'}"/>
                        <c:set var="isVnpaySuccess" value="${vnp_ResponseCode == '00'}"/>
                        
                        <c:choose>
                            <c:when test="${isVnpaySuccess}">
                                <div class="result-icon success"><i class="fa fa-check"></i></div>
                                <h1 class="success">Payment Successful!</h1>
                                <p>Thank you for your payment. Your transaction has been processed successfully.</p>
                                <p>Your booking status will be updated shortly after we confirm the payment internally (via IPN).</p>
                            </c:when>
                            
                            <c:when test="${isCodSuccess}">
                                <div class="result-icon cod"><i class="fa fa-check"></i></div>
                                <h1 class="cod">Booking Placed Successfully!</h1>
                                <p>Your booking has been confirmed. Please pay the total amount upon check-in at the hotel.</p>
                            </c:when>
                            
                            <c:otherwise>
                                <div class="result-icon error"><i class="fa fa-times"></i></div>
                                <h1 class="error">Payment Failed or Cancelled</h1>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty vnp_ResponseCode}">
                                            Your payment could not be processed or was cancelled. (Response Code: ${vnp_ResponseCode})
                                        </c:when>
                                        <c:otherwise>
                                            There was an issue processing your payment, or the transaction details are missing.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty param.vnp_TxnRef || not empty param.bookingId}">
                            <div class="transaction-details">
                                <h3>Transaction Details</h3>
                                <div class="detail-row">
                                    <span class="detail-label">Booking Reference:</span>
                                    <span class="detail-value">#${not empty param.vnp_TxnRef ? param.vnp_TxnRef : param.bookingId}</span>
                                </div>
                                
                                <c:if test="${not empty param.vnp_TxnRef}">
                                    <div class="detail-row">
                                        <span class="detail-label">Amount:</span>
                                        <span class="detail-value">
                                            <fmt:formatNumber value="${param.vnp_Amount / 100}" pattern="#,##0"/> VND
                                        </span>
                                    </div>
                                    <c:if test="${not empty param.vnp_BankCode}">
                                        <div class="detail-row">
                                            <span class="detail-label">Bank Code:</span>
                                            <span class="detail-value">${param.vnp_BankCode}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty param.vnp_TransactionNo}">
                                        <div class="detail-row">
                                            <span class="detail-label">VNPAY Transaction No:</span>
                                            <span class="detail-value">${param.vnp_TransactionNo}</span>
                                        </div>
                                    </c:if>
                                </c:if>

                                <div class="detail-row">
                                    <span class="detail-label">Payment Status:</span>
                                    <span class="detail-value ${isVnpaySuccess ? 'status-success' : (isCodSuccess ? 'status-pending' : 'status-error')}">
                                        <c:choose>
                                            <c:when test="${isVnpaySuccess}">Successful (Awaiting Confirmation)</c:when>
                                            <c:when test="${isCodSuccess}">Confirmed (Pay at Hotel)</c:when>
                                            <c:otherwise>Failed/Cancelled</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </c:if>

                         <c:if test="${isVnpaySuccess}">
                             <div class="alert alert-warning" role="alert">
                               <i class="fa fa-exclamation-triangle"></i> <strong>Important:</strong> Please check your booking history later to see the final confirmed status. This page only shows the immediate result from VNPAY.
                             </div>
                         </c:if>

                        <div class="action-buttons">
                            <c:url value="/booking?action=viewUserBookings" var="myBookingsUrl"/> 
                            <a href="${myBookingsUrl}" class="btn btn-primary">
                                <i class="fa fa-list"></i> View My Bookings
                            </a>
                            <c:url value="/rooms" var="roomsUrl"/>
                            <a href="${roomsUrl}" class="btn btn-secondary">
                                <i class="fa fa-bed"></i> Browse More Rooms
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="/common/footer.jsp"/>
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

