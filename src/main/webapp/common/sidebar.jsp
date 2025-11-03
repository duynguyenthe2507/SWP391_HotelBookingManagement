<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Lấy đường dẫn context và servlet path để xác định trang hiện tại --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath"
       value="${requestScope['jakarta.servlet.forward.servlet_path'] != null ? requestScope['jakarta.servlet.forward.servlet_path'] : request.servletPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard</title>

    <link rel="stylesheet" href="${contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${contextPath}/css/font-awesome.min.css">

    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 0;
            background-color: #f4f7fc;
        }

        /* SIDEBAR */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 220px;
            height: 100vh;
            background-color: #336699;
            color: white;
            padding-top: 20px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
            z-index: 100;
        }

        .sidebar h3 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            padding: 10px 20px;
            border-radius: 6px;
            transition: background 0.3s;
            margin: 5px 10px;
        }

        .sidebar a i {
            margin-right: 10px;
            font-size: 17px;
        }

        .sidebar a:hover {
            background-color: #2d5986;
        }

        .sidebar a.active {
            background-color: #254d73;
            font-weight: bold;
        }

        /* TOP-NAV (HEADER) */
        .top-nav {
            position: fixed;
            top: 0;
            left: 220px;
            width: calc(100% - 220px);
            height: 60px;
            background-color: #ffffff;
            border-bottom: 1px solid #e3e6f0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 40px;
            z-index: 99;
        }

        .user-info {
            color: #19191a;
            font-weight: 500;
            font-size: 16px;
        }

        .user-info span {
            color: #dfa974;
            font-weight: bold;
        }

        .user-info a {
            text-decoration: none;
            margin-left: 10px;
        }

        .user-info .profile-btn {
            background: #336699;
            color: #fff;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            transition: background 0.3s;
        }

        .user-info .profile-btn:hover {
            background: #2d5986;
        }

        .user-info .logout-link {
            color: #dc3545;
            font-weight: bold;
        }

        .user-info .logout-link:hover {
            text-decoration: underline;
        }

        /* CONTENT (ĐÃ ĐIỀU CHỈNH) */
        .content {
            margin-left: 220px;
            margin-top: 60px; /* Đẩy xuống dưới top-nav */
            padding: 40px;
            /* THAY ĐỔI: Thêm đệm dưới để không bị footer che */
            padding-bottom: 100px;
        }

        .welcome-box {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .welcome-box h2 {
            color: #222;
            font-weight: 600;
        }

        .welcome-box p {
            color: #666;
        }

        /* FOOTER (ĐÃ ĐIỀU CHỈNH) */
        .footer {
            /* THAY ĐỔI: Cố định footer */
            position: fixed;
            bottom: 0;
            left: 220px;
            width: calc(100% - 220px);
            z-index: 99;

            text-align: center;
            color: #333;
            padding: 15px;
            background: #f8f9fc;
            border-top: 1px solid #e3e6f0;
            font-size: 14px;
            /* Bỏ margin-top vì đã cố định */
        }

        .footer a {
            color: #1a73e8;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        /* MEDIA QUERY (ĐÃ ĐIỀU CHỈNH) */
        @media (max-width: 768px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }

            .top-nav {
                position: relative;
                left: 0;
                width: 100%;
                height: auto;
                padding: 15px;
                flex-direction: column;
                gap: 10px;
            }

            .content {
                margin-left: 0;
                margin-top: 0;
                padding: 40px; /* Đặt lại padding */
            }

            /* THAY ĐỔI: Cho footer cuộn bình thường */
            .footer {
                position: relative;
                left: 0;
                width: 100%;
                margin-top: 40px; /* Thêm lại margin-top */
            }
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h3>Receptionist Panel</h3>

    <a href="${contextPath}/receptionist/booking-list"
       class="${currentPath == '/receptionist/booking-list' ? 'active' : ''}">
        <i class="fa fa-home"></i> Booking List
    </a>

    <a href="${contextPath}/receptionist/create-booking"
       class="${currentPath == '/receptionist/create-booking' ? 'active' : ''}">
        <i class="fa fa-calendar-plus-o"></i> Create Booking
    </a>

    <a href="${contextPath}/receptionist/room-fees"
       class="${currentPath == '/receptionist/room-fees' ? 'active' : ''}">
        <i class="fa fa-bed"></i> Room Fees
    </a>

    <a href="${contextPath}/receptionist/bills"
       class="${currentPath == '/receptionist/bills' ? 'active' : ''}">
        <i class="fa fa-file-text-o"></i> Bills
    </a>

    <a href="${contextPath}/receptionist/rooms" class="sidebar-item js-load" data-url="${contextPath}/receptionist/rooms">
        <i class="fa fa-list"></i> Room Edit
    </a>

    <a href="${contextPath}/rules" class="sidebar-item js-load"
       data-url="${contextPath}/rules">
        <i class="fa fa-book"></i> Rules
    </a>
</div>


<div class="footer">
    <p>Contact Us: (84) 359 797 703 |
        <a href="mailto:36hotel@gmail.com">36hotel@gmail.com</a></p>
    <p>Thanh Hoa, Vietnam ©2025 36 Hotel</p>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const contentContainer = document.querySelector(".content");
        document.querySelectorAll(".sidebar a").forEach(link => {
            if (link.classList.contains("js-load")) {
                link.addEventListener("click", function (e) {
                    e.preventDefault();
                    const url = this.getAttribute("data-url");
                    if (!url) return;
                    updateActiveLink(this);
                    loadContent(url, contentContainer);
                });
            }
        });

        function loadContent(url, container) {
            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Lỗi mạng khi tải nội dung.");
                    }
                    return response.text();
                })
                .then(html => {
                    container.innerHTML = html;
                    container.querySelectorAll("script").forEach(oldScript => {
                        const newScript = document.createElement("script");
                        Array.from(oldScript.attributes).forEach(attr => {
                            newScript.setAttribute(attr.name, attr.value);
                        });
                        if (oldScript.innerHTML) {
                            newScript.innerHTML = oldScript.innerHTML;
                        }
                        document.head.appendChild(newScript);
                        oldScript.parentNode.removeChild(oldScript);
                    });
                })
                .catch(error => {
                    container.innerHTML = `<div class="welcome-box" style="border: 1px solid red;"><p>Lỗi: ${error.message}</p></div>`;
                    console.error("Không thể tải nội dung:", error);
                });
        }

        function updateActiveLink(activeLink) {
            document.querySelectorAll(".sidebar a").forEach(a => a.classList.remove("active"));
            activeLink.classList.add("active");
        }

    });
</script>
</body>
</html>