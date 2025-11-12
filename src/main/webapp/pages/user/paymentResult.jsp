<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Result - 36 Hotel</title> <%-- Translated --%>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            width: 100%;
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
            border-top: 5px solid #f09819;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            padding: 40px 40px 30px;
            text-align: center;
            position: relative;
        }

        .icon-success {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #f09819 0%, #ff5e00 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }

        .icon-error {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .icon-warning {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        .icon-success::before {
            content: "✓";
            color: white;
            font-size: 48px;
            font-weight: bold;
        }

        .icon-error::before {
            content: "✕";
            color: white;
            font-size: 48px;
            font-weight: bold;
        }

        .icon-warning::before {
            content: "!";
            color: white;
            font-size: 48px;
            font-weight: bold;
        }

        .header h1 {
            font-size: 28px;
            color: #1f2937;
            margin-bottom: 10px;
        }

        .header p {
            color: #6b7280;
            font-size: 16px;
        }

        .content {
            padding: 0 40px 40px;
        }

        .message-box {
            background: #f9fafb;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            line-height: 1.6;
            color: #374151;
        }

        .user-info {
            background: #fffaf0;
            border-left: 4px solid #f09819;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .user-info p {
            color: #c2410c; /* Darker orange */
            margin: 5px 0;
        }

        .warning-box {
            background: #fef2f2;
            border-left: 4px solid #ef4444;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .warning-box p {
            color: #991b1b;
            margin: 0;
        }

        .actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 14px 24px;
            border-radius: 10px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #f09819 0%, #ff5e00 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(240, 152, 25, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(240, 152, 25, 0.6);
        }

        .btn-secondary {
            background: white;
            color: #f09819;
            border: 2px solid #f09819;
        }

        .btn-secondary:hover {
            background: #fffaf0;
        }

        .divider {
            height: 1px;
            background: linear-gradient(to right, transparent, #e5e7eb, transparent);
            margin: 30px 0;
        }

        @media (max-width: 640px) {
            .container {
                margin: 10px;
            }
            
            .header, .content {
                padding: 30px 20px;
            }

            .actions {
                flex-direction: column;
            }

            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <c:choose>
                <%-- Check for "thành công" (success) --%>
                <c:when test="${message.contains('thành công')}">
                    <div class="icon-success"></div>
                </c:when>
                <%-- Check for "hủy" (cancel) --%>
                <c:when test="${message.contains('hủy')}">
                    <div class="icon-warning"></div>
                </c:when>
                <c:otherwise>
                    <div class="icon-error"></div>
                </c:otherwise>
            </c:choose>

            <h1>
                <c:choose>
                    <c:when test="${message.contains('thành công')}">
                        Payment Successful!
                    </c:when>
                    <c:when test="${message.contains('hủy')}">
                        Payment Cancelled
                    </c:when>
                    <c:otherwise>
                        Payment Failed
                    </c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${message.contains('thành công')}">
                        Your booking has been confirmed
                    </c:when>
                    <c:when test="${message.contains('hủy')}">
                        The transaction has been cancelled
                    </c:when>
                    <c:otherwise>
                        An error occurred during payment
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <div class="content">
            <!-- Message Box -->
            <div class="message-box">
                ${message}
            </div>

            <!-- User Info (if logged in) -->
            <c:if test="${not empty sessionScope.user}">
                <div class="user-info">
                    <p><strong>👤 Account:</strong> ${sessionScope.user.firstName} ${sessionScope.user.lastName}</p>
                    <p><strong>✅ Status:</strong> Logged In</p>
                </div>
            </c:if>

            <!-- If NOT logged in (Session bug) -->
            <c:if test="${empty sessionScope.user}">
                <div class="warning-box">
                    <p>
                        ⚠️ <strong>Warning:</strong> Your session has expired. Please log in again to view your order details.
                    </p>
                </div>
            </c:if>

            <div class="divider"></div>

            <!-- Action Buttons -->
            <div class="actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                            🏠 Back to Home
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- If logged out -->
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                            🔐 Login
                        </a>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                            🏠 Back to Home
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>