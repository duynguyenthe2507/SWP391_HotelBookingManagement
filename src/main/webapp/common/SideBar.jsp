<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Style cho sidebar header */
        .sidebar-header {
            text-align: center; /* Canh giữa */
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f8f9fa; /* Màu nền nhẹ */
            border-bottom: 2px solid #ccc; /* Viền dưới để phân cách */
        }

        /* Style cho tên hotel */
        .sidebar-header h3 {
            font-family: 'Arial', sans-serif; /* Font chữ đẹp */
            color: #343a40; /* Màu chữ tối */
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 2px; /* Khoảng cách giữa các chữ */
            margin: 0; /* Loại bỏ margin mặc định */
        }

        /* Các item khác trong sidebar */
        .sidebar-item {
            padding: 10px;
            font-size: 18px;
            color: #495057;
            display: flex;
            align-items: center;
        }

        .sidebar-item i {
            margin-right: 10px; /* Khoảng cách giữa icon và chữ */
        }

        .sidebar-item:hover {
            background-color: #e9ecef; /* Nền màu xám khi hover */
            color: #007bff; /* Màu chữ khi hover */
        }

        /* General background and layout settings */
        body {
            background-color: #f4f7fc;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Sidebar styling */
        .sidebar-wrapper {
            background-color: #222;
            padding: 25px;
            width: 260px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            border-radius: 10px;
            box-shadow: 4px 0px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        .sidebar-wrapper:hover {
            width: 280px;
        }

        .sidebar-item {
            padding: 15px;
            color: #fff;
            font-size: 18px;
            text-decoration: none;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            border-radius: 8px;
            transition: background-color 0.3s ease, padding-left 0.3s ease;
        }

        .sidebar-item:hover {
            background-color: #f39c12;
            padding-left: 25px;
        }

        .sidebar-item i {
            margin-right: 15px;
        }

        /* Sub-items (Room Edit, Room Fees) */
        .sub-item {
            display: none; /* Initially hide the sub-items */
            padding-left: 30px;
        }

        /* Content Area styling */
        .content-area {
            margin-left: 280px; /* Adjust for sidebar */
            padding: 50px;
            font-size: 18px;
            color: #333;
            max-width: 80%;
        }

        .welcome-message {
            font-size: 30px;
            font-weight: 600;
            color: #333;
            margin-bottom: 25px;
        }

        .dashboard-description {
            font-size: 20px;
            color: #666;
            line-height: 1.7;
            font-weight: 300;
        }

        .footer {
            background-color: #2d2d2d;
            padding: 20px;
            text-align: center;
            color: #fff;
            position: fixed;
            bottom: 0;
            width: 100%;
            font-size: 14px;
        }

        .footer a {
            color: #f39c12;
            text-decoration: none;
            margin: 0 15px;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        .footer p {
            margin: 8px 0;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar-wrapper">
    <div class="sidebar-header">
        <h3>36 Hotel</h3>
    </div>
    <a href="javascript:void(0);" class="sidebar-item" id="rules-link"><i class="fa fa-book"></i> Rules</a>
    <a href="javascript:void(0);" class="sidebar-item" id="rooms-link"><i class="fa fa-bed"></i> Rooms</a>
    <div class="sub-item" id="room-edit">
        <a href="${pageContext.request.contextPath}/room/edit" class="sidebar-item"><i class="fa fa-edit"></i> Room Edit</a>
    </div>
    <div class="sub-item" id="room-fees">
        <a href="${pageContext.request.contextPath}/room/fees" class="sidebar-item"><i class="fa fa-dollar-sign"></i> Room Fees</a>
    </div>
    <a href="${pageContext.request.contextPath}/receptionist/bills" class="sidebar-item"><i class="fa fa-file-invoice"></i> Bills</a>
    <a href="${pageContext.request.contextPath}/login" class="sidebar-item"><i class="fa fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Content Area -->
<div class="content-area" id="content-area">
    <div class="welcome-message">
        Welcome, Receptionist!
    </div>
    <p class="dashboard-description">
        This is your Receptionist Dashboard — manage hotel rules, rooms, and bookings easily. You can also view and update room fees, edit room details, and more. It's your all-in-one hub for hotel management.
    </p>
</div>

<!-- Footer -->
<div class="footer">
    <p>Contact Us: (84) 359 797 703 | <a href="mailto:36hotel@gmail.com">36hotel@gmail.com</a></p>
    <p>Thanh Hoa, Vietnam</p>
    <p>Copyright ©2025 All rights reserved by 36 Hotel</p>
</div>

<!-- jQuery Script for AJAX -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // Tải nội dung khi nhấn vào liên kết "Rules"
        $('#rules-link').on('click', function() {
            $('#content-area').load("${pageContext.request.contextPath}/rules");  // Tải nội dung từ rules-list.jsp vào khu vực nội dung
        });

        // Toggle sub-items when "Rooms" is clicked
        $('#rooms-link').on('click', function() {
            $('#room-edit, #room-fees').toggle();  // Hiện/Ẩn các mục con
        });
    });
</script>

</body>
</html>
