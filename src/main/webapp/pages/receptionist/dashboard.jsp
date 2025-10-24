<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard | 36 Hotel</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Dashboard custom styles */
        body {
            background-color: #f9f9f9;
            font-family: 'Cabin', sans-serif;
        }

        .dashboard-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: #222;
            color: #fff;
            padding: 30px 20px;
        }

        .sidebar h3 {
            color: #dfa974;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
        }

        .sidebar a {
            display: block;
            color: #fff;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #dfa974;
            color: #fff;
        }

        .dashboard-content {
            flex: 1;
            padding: 40px;
        }

        .welcome-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .welcome-card:hover {
            transform: translateY(-5px);
        }

        .welcome-card h2 {
            color: #333;
            font-weight: 700;
        }

        .welcome-card p {
            color: #777;
            margin-bottom: 25px;
        }

        .btn-primary-custom {
            background-color: #dfa974;
            border: none;
            color: #fff;
            padding: 12px 25px;
            border-radius: 5px;
            text-transform: uppercase;
            font-weight: 600;
            transition: background 0.3s ease;
        }

        .btn-primary-custom:hover {
            background-color: #b67b4b;
        }

        .logout-link {
            color: #dfa974;
            font-weight: bold;
            text-decoration: none;
        }

        .logout-link:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<!-- Include header -->
<jsp:include page="/common/header.jsp" />

<div class="dashboard-wrapper">
    <!-- Sidebar -->
    <div class="sidebar">
        <h3>Receptionist Panel</h3>
        <a href="${pageContext.request.contextPath}/pages/Receptionist/dashboard.jsp" class="active">
            <i class="fa fa-home"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/rules">
            <i class="fa fa-book"></i> Manage Rules
        </a>
        <a href="${pageContext.request.contextPath}/rooms">
            <i class="fa fa-bed"></i> Manage Rooms
        </a>
        <a href="${pageContext.request.contextPath}/bookings">
            <i class="fa fa-calendar"></i> Bookings
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-link">
            <i class="fa fa-sign-out"></i> Logout
        </a>
    </div>

    <!-- Main content -->
    <div class="dashboard-content">
        <div class="welcome-card">
            <h2>Welcome, ${loggedInUser.firstName}!</h2>
            <p>This is your Receptionist Dashboard — manage hotel rules, rooms, and bookings easily.</p>

            <a href="${pageContext.request.contextPath}/rules" class="btn-primary-custom">
                <i class="fa fa-book"></i> Manage Hotel Rules
            </a>
        </div>
    </div>
</div>

<!-- Include footer -->
<jsp:include page="/common/footer.jsp" />

<!-- JS -->
<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
</body>
</html>
