<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receptionist Dashboard</title>
    <c:url var="baseUrl" value="/"/>
    <link rel="stylesheet" href="${baseUrl}css/bootstrap.min.css">
    <link rel="stylesheet" href="${baseUrl}css/font-awesome.min.css">

    <style>
        :root {
            --primary-color: #f39c12; /* Màu cam chính */
            --sidebar-bg: #222d32; /* Màu nền sidebar */
            --sidebar-text: #b8c7ce; /* Màu chữ sidebar */
            --sidebar-hover: #1a2226; /* Màu khi hover */
            --content-bg: #f4f6f9; /* Màu nền nội dung */
            --card-border: #dee2e6;
            --text-dark: #343a40;
        }

        body {
            background-color: var(--content-bg);
            font-family: 'Arial', sans-serif;
            margin: 0;
        }

        .wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
        }

        /* --- Sidebar --- */
        .sidebar-wrapper {
            width: 260px;
            background: var(--sidebar-bg);
            transition: all .3s ease;
            position: fixed;
            height: 100%;
            overflow-y: auto;
            z-index: 1000;
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #4b545c;
        }

        .sidebar-header h3 {
            color: #fff;
            font-size: 24px;
            font-weight: bold;
            margin: 0;
            letter-spacing: 1px;
        }

        .sidebar-nav {
            padding: 15px;
        }

        .sidebar-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: var(--sidebar-text);
            font-size: 16px;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 8px;
            transition: background-color .3s, color .3s;
        }

        .sidebar-item i {
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        .sidebar-item:hover,
        .sidebar-item.active {
            background: var(--primary-color);
            color: #fff;
            text-decoration: none;
        }

        /* Submenu */
        .submenu {
            padding-left: 20px;
        }

        .submenu .sidebar-item {
            font-size: 15px;
            padding: 10px 15px;
            background: var(--sidebar-hover);
        }

        .submenu .sidebar-item:hover,
        .submenu .sidebar-item.active {
            background: var(--primary-color);
        }

        /* --- Main Content Area --- */
        .main-content {
            flex-grow: 1;
            margin-left: 260px; /* Bằng chiều rộng sidebar */
            display: flex;
            flex-direction: column;
            transition: all .3s ease;
        }

        /* --- Top Navbar --- */
        .top-navbar {
            background: #fff;
            padding: 10px 30px;
            border-bottom: 1px solid var(--card-border);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .user-info {
            color: var(--text-dark);
            font-weight: 600;
        }

        .user-info a {
            color: #dc3545; /* Màu đỏ cho logout */
            text-decoration: none;
            margin-left: 15px;
            font-weight: bold;
        }

        .user-info a:hover {
            text-decoration: underline;
        }

        /* --- Content Area --- */
        .content-area {
            padding: 30px;
            flex-grow: 1;
        }

        /* --- Dashboard Stats Cards --- */
        .stat-card {
            border: none;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .stat-card .card-body {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-card .stat-icon {
            font-size: 45px;
            opacity: 0.3;
        }

        .stat-card .stat-info h5 {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .stat-card .stat-info h3 {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
        }

        /* Màu cho các thẻ */
        .card-primary .stat-icon { color: #007bff; }
        .card-success .stat-icon { color: #28a745; }
        .card-warning .stat-icon { color: #ffc107; }
        .card-danger .stat-icon { color: #dc3545; }

        /* --- Footer --- */
        .footer {
            background: #fff;
            border-top: 1px solid var(--card-border);
            padding: 20px 30px;
            text-align: center;
            color: #6c757d;
            font-size: 14px;
            margin-top: auto; /* Đẩy footer xuống dưới cùng */
        }

        .footer a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="wrapper">
    <div class="sidebar-wrapper">
        <div class="sidebar-header">
            <h3>36 Hotel</h3>
        </div>
        <nav class="sidebar-nav">
            <a href="${ctx}/receptionist/dashboard" class="sidebar-item js-load active"
               data-url="${ctx}/receptionist/dashboard-content">
                <i class="fa fa-dashboard"></i> Dashboard
            </a>

            <a href="${ctx}/rules" class="sidebar-item js-load"
               data-url="${ctx}/rules">
                <i class="fa fa-book"></i> Rules
            </a>

            <!-- Rooms Toggle -->
            <a href="#rooms-submenu" class="sidebar-item" data-toggle="collapse" aria-expanded="false">
                <i class="fa fa-bed"></i> Rooms <i class="fa fa-angle-down float-right"></i>
            </a>
            <div class="collapse submenu" id="rooms-submenu">

                <a href="${ctx}/receptionist/rooms" class="sidebar-item js-load"
                   data-url="${ctx}/receptionist/rooms">
                    <i class="fa fa-list"></i> Room Edit
                </a>
                <a href="${ctx}/receptionist/room-fees" class="sidebar-item"
                   data-url="${ctx}/receptionist/room-fees">
                    <i class="fa fa-dollar"></i> Room Fees
                </a>
            </div>
            <!-- Bills -->
            <a href="${ctx}/receptionist/bills" class="sidebar-item">
                <i class="fa fa-file-text-o"></i> Bills
            </a>
        </nav>
    </div>

    <div class="main-content">

        <nav class="top-navbar">
            <div class="user-info">
                Welcome, <strong>Receptionist</strong>!
                <a href="${ctx}/login">
                    <i class="fa fa-sign-out"></i> Logout
                </a>
            </div>
        </nav>

        <main class="content-area" id="content-area">

            <h2>Dashboard Overview</h2>
            <p class="text-muted">Welcome to the 36 Hotel Management System.</p>

            <div class="row mt-4">
                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card card-primary">
                        <div class="card-body">
                            <div class="stat-info">
                                <h5>New Bookings</h5>
                                <h3>12</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="fa fa-calendar-check-o"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card card-success">
                        <div class="card-body">
                            <div class="stat-info">
                                <h5>Available Rooms</h5>
                                <h3>45</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="fa fa-bed"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card card-warning">
                        <div class="card-body">
                            <div class="stat-info">
                                <h5>Check-ins Today</h5>
                                <h3>8</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="fa fa-sign-in"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card card-danger">
                        <div class="card-body">
                            <div class="stat-info">
                                <h5>Today's Revenue</h5>
                                <h3>$1,250</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="fa fa-money"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mt-4">
                <div class="card-header">
                    <h5 class="mb-0">Recent Bookings</h5>
                </div>
                <div class="card-body">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Guest Name</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>B-1001</td>
                            <td>Nguyen Van Hung</td>
                            <td>Deluxe 201</td>
                            <td>2025-10-30 14:00</td>
                            <td><span class="badge badge-success">Confirmed</span></td>
                        </tr>
                        <tr>
                            <td>B-1002</td>
                            <td>Tran Thi Linh</td>
                            <td>Family 102</td>
                            <td>2025-10-30 15:00</td>
                            <td><span class="badge badge-warning">Pending</span></td>
                        </tr>
                        <tr>
                            <td>B-1003</td>
                            <td>Le Van A</td>
                            <td>Double 301</td>
                            <td>2025-10-31 12:00</td>
                            <td><span class="badge badge-success">Confirmed</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <footer class="footer">
            <p class="mb-0">Contact Us: (84) 359 797 703 | <a href="mailto:36hotel@gmail.com">36hotel@gmail.com</a></p>
            <p class="mb-0">Thanh Hoa, Vietnam ©2025 36 Hotel</p>
        </footer>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
<script>
    $(function () {

        // MỚI: Xử lý trạng thái "active" cho sidebar
        $('.sidebar-item').on('click', function () {
            // Xóa active khỏi tất cả các item
            $('.sidebar-item').removeClass('active');

            // Thêm active cho item được click
            $(this).addClass('active');

            // Xử lý cho submenu
            if ($(this).closest('.submenu').length) {
                // Nếu click vào submenu, active cả (cha) của nó
                $(this).closest('.submenu').prev('.sidebar-item').addClass('active');
            }
        });

        // Load content động (AJAX)
        // Lưu ý: data-url của Dashboard nên trỏ đến một trang/servlet
        // chỉ trả về phần nội dung dashboard (không phải toàn bộ trang)
        $(document).on('click', '.js-load', function (e) {
            e.preventDefault();
            const url = $(this).data('url');

            // Giả lập URL cho dashboard nếu chưa có
            if (url === '${ctx}/receptionist/dashboard-content') {
                // Tải lại nội dung dashboard (ví dụ)
                // Trong thực tế, bạn sẽ gọi một servlet trả về HTML fragment
                $('#content-area').load(url, function (res, status, xhr) {
                    if (status === "error") {
                        $('#content-area').html('<div class="alert alert-danger">Cannot load dashboard content. (' + xhr.status + ')</div>');
                    }
                });
                // Tạm thời chỉ hiển thị lại nội dung đã có
                // Bỏ dòng dưới nếu bạn đã có servlet 'dashboard-content'
                console.log("Đang tải dashboard...");
                return;
            }

            if (!url || url === '#') return;

            $('#content-area').html('<div class="text-center p-5"><i class="fa fa-spinner fa-spin fa-3x"></i></div>'); // Hiệu ứng loading

            $('#content-area').load(url, function (res, status, xhr) {
                if (status === 'error') {
                    $('#content-area').html('<div class="alert alert-danger">Cannot load content. (' + xhr.status + ')</div>');
                }
            });
        });

        // MỚI: Đảm bảo submenu của Bootstrap hoạt động
        // Mã 'slideToggle' cũ của bạn đã được thay thế bằng
        // thuộc tính 'data-toggle="collapse"' của Bootstrap.
    });
</script>
</body>
</html>