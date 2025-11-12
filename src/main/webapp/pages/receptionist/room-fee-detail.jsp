<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zxx">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Room Fee Detail - 36 Hotel">
    <meta name="keywords" content="Room, Detail, Fee, Hotel">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Room Fee Detail - 36 Hotel</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

    <!-- Css Styles -->
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
        /* Room Detail Specific Styles */
        body {
            background: #f8f9fa;
            font-family: "Cabin", sans-serif;
        }

        /* Dashboard Layout */
        .dashboard-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .dashboard-content {
            flex: 1;
            margin-left: 250px; /* Width of sidebar */
            width: calc(100% - 250px);
            padding: 40px;
            padding-bottom: 80px; /* Extra space at bottom to prevent footer overlap */
            min-height: 100vh;
        }

        /* Room Detail Header - Removed */

        .main-content {
            background: transparent;
            margin: 0;
            border-radius: 0;
            box-shadow: none;
            padding: 0;
            padding-bottom: 80px;
            position: relative;
            z-index: 1;
        }

        .room-detail-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
        }

        .room-detail-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dfa974, #c8965a);
        }

        .room-title {
            color: #19191a;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 10px;
            font-family: "Lora", serif;
        }

        .room-subtitle {
            color: #6b6b6b;
            font-size: 1.1rem;
            margin-bottom: 30px;
        }

        .room-price-large {
            color: #dfa974;
            font-weight: 800;
            font-size: 3rem;
            font-family: "Lora", serif;
            margin-bottom: 10px;
        }

        .room-price-large span {
            font-size: 1.2rem;
            color: #6b6b6b;
            font-weight: 400;
            font-family: "Cabin", sans-serif;
        }

        .room-info-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin: 40px 0;
        }

        .info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .info-card i {
            font-size: 2.5rem;
            color: #dfa974;
            margin-bottom: 15px;
        }

        .info-card h4 {
            color: #19191a;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .info-card p {
            color: #6b6b6b;
            margin: 0;
            font-size: 1rem;
        }

        .status-badge-large {
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: 2px solid;
            display: inline-block;
            margin-bottom: 20px;
        }

        .status-available {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-color: #c3e6cb;
        }

        .status-booked {
            background: linear-gradient(135deg, #f8d7da, #f1b0b7);
            color: #721c24;
            border-color: #f1b0b7;
        }

        .status-maintenance {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border-color: #ffeaa7;
        }

        .room-description {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin: 30px 0;
        }

        .room-description h4 {
            color: #19191a;
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .room-description p {
            color: #6b6b6b;
            font-size: 1rem;
            line-height: 1.6;
            margin: 0;
        }

        .similar-rooms {
            margin-top: 50px;
        }

        .similar-rooms h3 {
            color: #19191a;
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 30px;
            text-align: center;
        }

        .similar-room-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .similar-room-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .similar-room-card h5 {
            color: #19191a;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .similar-room-card .price {
            color: #dfa974;
            font-weight: 700;
            font-size: 1.2rem;
        }

        .similar-room-card .status {
            font-size: 0.9rem;
            padding: 4px 8px;
            border-radius: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .back-button {
            display: inline-block;
            padding: 12px 25px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }

        .back-button:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3);
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 12px 25px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .action-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3);
        }

        .action-btn.secondary {
            background: #6c757d;
        }

        .action-btn.secondary:hover {
            background: #5a6268;
        }

        @media (max-width: 768px) {
            .room-detail-header h2 {
                font-size: 2rem;
            }

            .room-title {
                font-size: 1.8rem;
            }

            .room-price-large {
                font-size: 2.5rem;
            }

            .room-info-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-btn {
                text-align: center;
            }
        }

        @media (max-width: 576px) {
            .room-info-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
        }
    </style>
</head>

<body>
<c:set var="pageActive" value="room-fees"/>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    <div class="dashboard-content">
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Header removed to match booking-list.jsp layout -->

    <!-- Room Detail Section Begin -->
    <section class="main-content">
        <div class="container">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 30px;">
                    <i class="fa fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <c:if test="${empty room}">
                <div class="alert alert-warning" style="background: #fff3cd; color: #856404; padding: 15px; border-radius: 5px; margin-bottom: 30px;">
                    <i class="fa fa-exclamation-triangle"></i> Room not found. Please check the room ID and try again.
                </div>
                <a href="${pageContext.request.contextPath}/receptionist/room-fees" class="back-button">
                    <i class="fa fa-arrow-left"></i> Back to Room Fees List
                </a>
            </c:if>

            <c:if test="${not empty room}">
                <!-- Back Button -->
                <a href="${pageContext.request.contextPath}/receptionist/room-fees" class="back-button">
                    <i class="fa fa-arrow-left"></i> Back to Room Fees List
                </a>

                <!-- Room Detail Card -->
                <div class="room-detail-card">
                    <div class="row">
                        <div class="col-lg-8">
                            <h1 class="room-title">${room.name}</h1>
                            <p class="room-subtitle">Room #${room.roomId} • ${category.name} Category</p>
                            
                            <c:choose>
                                <c:when test="${room.status == 'available'}">
                                    <span class="status-badge-large status-available">
                                        <i class="fa fa-check"></i> Available
                                    </span>
                                </c:when>
                                <c:when test="${room.status == 'booked'}">
                                    <span class="status-badge-large status-booked">
                                        <i class="fa fa-times"></i> Booked
                                    </span>
                                </c:when>
                                <c:when test="${room.status == 'maintenance'}">
                                    <span class="status-badge-large status-maintenance">
                                        <i class="fa fa-wrench"></i> Maintenance
                                    </span>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="col-lg-4 text-right">
                            <div class="room-price-large">
                                <fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND"/>
                                <span>/night</span>
                            </div>
                        </div>
                    </div>

                    <!-- Room Information Grid -->
                    <div class="room-info-grid">
                        <div class="info-card">
                            <i class="fa fa-users"></i>
                            <h4>Capacity</h4>
                            <p>${room.capacity} guests</p>
                        </div>
                        <div class="info-card">
                            <i class="fa fa-tag"></i>
                            <h4>Category</h4>
                            <p>${category.name}</p>
                        </div>
                        <div class="info-card">
                            <i class="fa fa-dollar"></i>
                            <h4>Price per Night</h4>
                            <p><fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND"/></p>
                        </div>
                        <div class="info-card">
                            <i class="fa fa-calendar"></i>
                            <h4>Last Updated</h4>
                            <p>${room.updatedAt.toString().substring(0, 10)}</p>
                        </div>
                    </div>

                    <!-- Room Description -->
                    <c:if test="${not empty room.description}">
                        <div class="room-description">
                            <h4><i class="fa fa-info-circle"></i> Room Description</h4>
                            <p>${room.description}</p>
                        </div>
                    </c:if>

                    <!-- Category Description -->
                    <c:if test="${not empty category.description}">
                        <div class="room-description">
                            <h4><i class="fa fa-star"></i> Category Information</h4>
                            <p>${category.description}</p>
                        </div>
                    </c:if>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/receptionist/room-fees" class="action-btn">
                            <i class="fa fa-list"></i> View All Rooms
                        </a>
                        <button class="action-btn secondary" onclick="window.print()">
                            <i class="fa fa-print"></i> Print Details
                        </button>
                        <button class="action-btn secondary" onclick="exportRoomDetails()">
                            <i class="fa fa-download"></i> Export Details
                        </button>
                    </div>
                </div>

                <!-- Similar Rooms Section -->
                <c:if test="${not empty similarRooms}">
                    <div class="similar-rooms">
                        <h3><i class="fa fa-home"></i> Similar Rooms in ${category.name} Category</h3>
                        <div class="row">
                            <c:forEach var="similarRoom" items="${similarRooms}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="col-lg-4 col-md-6">
                                        <div class="similar-room-card" onclick="viewRoomDetail('${similarRoom.roomId}')">
                                            <h5>${similarRoom.name}</h5>
                                            <p class="price">
                                                <fmt:formatNumber value="${similarRoom.price}" type="currency" currencyCode="VND"/>
                                                <span>/night</span>
                                            </p>
                                            <p class="capacity">
                                                <i class="fa fa-users"></i> ${similarRoom.capacity} guests
                                            </p>
                                            <span class="status status-${similarRoom.status}">
                                                ${similarRoom.status}
                                            </span>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </c:if>
        </div>
    </section>
    <!-- Room Detail Section End -->

    <!-- Footer removed to match booking-list.jsp layout -->

    <!-- Js Plugins -->
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
    <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <script>
        function viewRoomDetail(roomId) {
            window.location.href = '${pageContext.request.contextPath}/receptionist/room-fee-detail?roomId=' + roomId;
        }

        function exportRoomDetails() {
            const roomName = '${room.name}';
            const roomPrice = '${room.price}';
            const roomCapacity = '${room.capacity}';
            const roomStatus = '${room.status}';
            const roomDescription = '${room.description}';
            const categoryName = '${category.name}';
            
            const csvContent = "Room Name,Category,Price,Capacity,Status,Description\n" +
                `"${roomName}","${categoryName}","${roomPrice}","${roomCapacity}","${roomStatus}","${roomDescription}"`;
            
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'room-detail-${room.roomId}.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }

        // Animate elements on load
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.info-card, .similar-room-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.6s ease';

                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 100);
                }, index * 150);
            });
        });
    </script>
    </div>
</div>
</body>
</html>
