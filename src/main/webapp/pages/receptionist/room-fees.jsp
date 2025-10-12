<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zxx">

<head>
    <meta charset="UTF-8">
    <meta name="description" content="Sona Template">
    <meta name="keywords" content="Sona, unica, creative, html">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Room Fees - 36 Hotel</title>

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
        /* Enhanced Professional Styles for Room Fees Management */

        /* Page Layout & Background */
        body {
            background: #f8f9fa;
            font-family: "Cabin", sans-serif;
        }

        /* Professional Header Section */
        .receptionist-header {
            background: linear-gradient(135deg, #dfa974 0%, #c8965a 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 0;
            position: relative;
            overflow: hidden;
        }

        .receptionist-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .receptionist-header .container {
            position: relative;
            z-index: 2;
        }

        .receptionist-header h2 {
            color: white;
            margin: 0;
            font-size: 2.5rem;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .receptionist-header p {
            color: rgba(255, 255, 255, 0.9);
            margin: 10px 0 0 0;
            font-size: 1.1rem;
            font-weight: 300;
        }

        .receptionist-header .fa {
            margin-right: 10px;
            font-size: 2rem;
            vertical-align: middle;
        }

        /* Main Content Area */
        .main-content {
            background: white;
            margin: -20px 0 0 0;
            border-radius: 20px 20px 0 0;
            box-shadow: 0 -5px 20px rgba(0,0,0,0.1);
            padding: 40px 0;
            position: relative;
            z-index: 1;
        }

        /* Enhanced Statistics Cards */
        .stats-card {
            background: white;
            border: none;
            border-radius: 15px;
            padding: 35px 25px;
            text-align: center;
            margin-bottom: 30px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dfa974, #c8965a);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .stats-card:hover::before {
            transform: scaleX(1);
        }

        .stats-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .stats-card .icon-wrapper {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .stats-card .icon-wrapper::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: inherit;
            opacity: 0.2;
            transform: scale(1.2);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1.2); opacity: 0.2; }
            50% { transform: scale(1.4); opacity: 0.1; }
        }

        .stats-card i {
            font-size: 32px;
            color: white;
            position: relative;
            z-index: 1;
        }

        .stats-card h3 {
            color: #19191a;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
            font-family: "Lora", serif;
        }

        .stats-card p {
            color: #6b6b6b;
            margin: 0;
            font-size: 1rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Enhanced Search and Filter Section */
        .search-filter-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .search-filter-section h5 {
            color: #19191a;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .search-filter-section h5 i {
            margin-right: 10px;
            color: #dfa974;
        }

        .search-input-wrapper {
            position: relative;
        }

        .search-input-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6b6b6b;
            font-size: 16px;
        }

        .search-input {
            width: 100%;
            padding: 15px 15px 15px 45px;
            border: 2px solid #e5e5e5;
            border-radius: 10px;
            font-size: 16px;
            color: #19191a;
            transition: all 0.3s ease;
            background: #fafafa;
        }

        .search-input:focus {
            outline: none;
            border-color: #dfa974;
            box-shadow: 0 0 0 3px rgba(223, 169, 116, 0.1);
            background: white;
        }

        /* Filter Groups */
        .filter-group {
            margin-bottom: 20px;
        }

        .filter-label {
            display: block;
            color: #19191a;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .filter-label i {
            margin-right: 8px;
            color: #dfa974;
        }

        .filter-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 6px 12px;
            border: 2px solid #e5e5e5;
            background: white;
            color: #6b6b6b;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filter-btn:hover,
        .filter-btn.active {
            border-color: #dfa974;
            background: #dfa974;
            color: white;
        }

        /* Price Range Filter */
        .price-range-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .price-input {
            flex: 1;
            min-width: 80px;
            padding: 8px 12px;
            border: 2px solid #e5e5e5;
            border-radius: 8px;
            font-size: 14px;
            color: #19191a;
            transition: all 0.3s ease;
            text-align: center;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .price-input:focus {
            outline: none;
            border-color: #dfa974;
            box-shadow: 0 0 0 2px rgba(223, 169, 116, 0.1);
        }

        .price-input::placeholder {
            color: #6b6b6b;
            text-align: center;
        }

        .price-separator {
            color: #6b6b6b;
            font-weight: 600;
        }

        .price-filter-btn {
            padding: 8px 12px;
            background: #dfa974;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .price-filter-btn:hover {
            background: #c8965a;
            transform: scale(1.05);
        }

        /* Filter Select Dropdowns */
        .filter-select {
            width: 100%;
            padding: 8px 12px;
            border: 2px solid #e5e5e5;
            border-radius: 8px;
            font-size: 14px;
            color: #19191a;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: left;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: flex-start;
        }

        .filter-select:focus {
            outline: none;
            border-color: #dfa974;
            box-shadow: 0 0 0 2px rgba(223, 169, 116, 0.1);
        }

        /* Style for placeholder options */
        .filter-select option[value="all"] {
            color: #6b6b6b;
            text-align: left;
        }

        .filter-select option:not([value="all"]) {
            color: #19191a;
            text-align: left;
        }

        /* Search Action Button */
        .search-action-btn {
            width: 100%;
            padding: 12px 20px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .search-action-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(223, 169, 116, 0.3);
        }

        .search-action-btn i {
            font-size: 12px;
        }

        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .action-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .action-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(223, 169, 116, 0.3);
        }

        .action-btn i {
            font-size: 12px;
        }

        /* Professional Table Design */
        .room-fees-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 40px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .table-header {
            background: linear-gradient(135deg, #dfa974 0%, #c8965a 100%);
            padding: 20px 30px;
            color: white;
        }

        .table-header h4 {
            margin: 0;
            color: white;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .table-header h4 i {
            margin-right: 10px;
        }

        .room-fees-table table {
            margin: 0;
            width: 100%;
        }

        .room-fees-table thead th {
            background: #f8f9fa;
            color: #19191a;
            border: none;
            padding: 10px 5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 11px;
            border-bottom: 2px solid #e5e5e5;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .room-fees-table tbody td {
            padding: 12px 8px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
            transition: all 0.3s ease;
        }

        .room-fees-table tbody tr {
            transition: all 0.3s ease;
        }

        .room-fees-table tbody tr:hover {
            background: linear-gradient(90deg, rgba(223, 169, 116, 0.05), rgba(223, 169, 116, 0.02));
            transform: scale(1.01);
        }

        .room-fees-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Enhanced Room Information Styling */
        .room-name {
            font-weight: 700;
            color: #19191a;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .room-number {
            font-size: 14px;
            color: #6b6b6b;
            font-weight: 500;
        }

        .room-price {
            color: #dfa974;
            font-weight: 800;
            font-size: 16px;
            font-family: "Lora", serif;
        }

        /* Enhanced Badge Designs */
        .category-badge {
            background: linear-gradient(135deg, #dfa974, #c8965a);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 2px 8px rgba(223, 169, 116, 0.3);
            position: relative;
            overflow: hidden;
        }

        .category-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .category-badge:hover::before {
            left: 100%;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border: 1px solid;
            position: relative;
            overflow: hidden;
            white-space: nowrap;
            display: inline-block;
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
            color: #6b6b6b;
            font-size: 12px;
            line-height: 1.3;
            max-width: 200px;
            word-wrap: break-word;
        }

        /* Status column specific styling */
        .room-fees-table td:nth-child(5) {
            text-align: center;
            min-width: 120px;
        }

        .room-fees-table td:nth-child(5) .status-badge {
            margin: 0 auto;
            display: inline-block;
        }

        .capacity-info {
            display: flex;
            align-items: center;
            color: #6b6b6b;
            font-size: 14px;
            font-weight: 500;
        }

        .capacity-info i {
            margin-right: 8px;
            color: #dfa974;
        }

        /* Enhanced Section Titles */
        .section-title {
            text-align: center;
            margin-bottom: 60px;
            position: relative;
        }

        .section-title span {
            font-size: 14px;
            color: #dfa974;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 3px;
            position: relative;
        }

        .section-title span::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 2px;
            background: #dfa974;
        }

        .section-title h2 {
            font-size: 2.8rem;
            color: #19191a;
            line-height: 1.2;
            margin-top: 20px;
            font-weight: 600;
            font-family: "Lora", serif;
        }

        /* Enhanced Category Summary Cards */
        .category-summary {
            background: white;
            border: none;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            position: relative;
            overflow: hidden;
        }

        .category-summary::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #dfa974, #c8965a);
        }

        .category-summary:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .category-summary h6 {
            color: #19191a;
            margin-bottom: 15px;
            font-weight: 700;
            font-size: 18px;
        }

        .category-summary p {
            color: #6b6b6b;
            font-size: 14px;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .category-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
        }

        .category-room-count {
            color: #6b6b6b;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .category-room-count i {
            margin-right: 5px;
            color: #dfa974;
        }

        .category-price-range {
            color: #dfa974;
            font-weight: 700;
            font-size: 14px;
            font-family: "Lora", serif;
        }

        /* Enhanced Buttons */
        .primary-btn {
            display: inline-block;
            font-size: 13px;
            color: #ffffff;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            position: relative;
            background: linear-gradient(135deg, #dfa974, #c8965a);
            padding: 15px 35px;
            border-radius: 25px;
            text-decoration: none;
            transition: all 0.4s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3);
            overflow: hidden;
        }

        .primary-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .primary-btn:hover::before {
            left: 100%;
        }

        .primary-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a);
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(223, 169, 116, 0.4);
        }

        .primary-btn:after {
            display: none;
        }

        /* Alert Styling */
        .alert {
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f1b0b7);
            color: #721c24;
        }

        /* Table Column Width Optimization */
        .room-fees-table table {
            table-layout: fixed;
        }

        .room-fees-table th:nth-child(1),
        .room-fees-table td:nth-child(1) {
            width: 18%;
        }

        .room-fees-table th:nth-child(2),
        .room-fees-table td:nth-child(2) {
            width: 12%;
        }

        .room-fees-table th:nth-child(3),
        .room-fees-table td:nth-child(3) {
            width: 12%;
        }

        .room-fees-table th:nth-child(4),
        .room-fees-table td:nth-child(4) {
            width: 8%;
        }

        .room-fees-table th:nth-child(5),
        .room-fees-table td:nth-child(5) {
            width: 12%;
        }

        .room-fees-table th:nth-child(6),
        .room-fees-table td:nth-child(6) {
            width: 25%;
        }

        .room-fees-table th:nth-child(7),
        .room-fees-table td:nth-child(7) {
            width: 13%;
        }

        /* Responsive Design Enhancements */
        @media (max-width: 768px) {
            .receptionist-header h2 {
                font-size: 2rem;
            }

            .stats-card {
                margin-bottom: 20px;
            }

            .room-fees-table {
                font-size: 14px;
            }

            .room-fees-table thead th,
            .room-fees-table tbody td {
                padding: 8px 5px;
            }

            .section-title h2 {
                font-size: 2.2rem;
            }

            .filter-buttons {
                justify-content: center;
            }

            /* Enhanced responsive design for new filters */
            .search-filter-section .row {
                margin: 0;
            }

            .search-filter-section .col-lg-3 {
                margin-bottom: 20px;
            }

            .price-range-wrapper {
                flex-direction: column;
                gap: 10px;
            }

            .price-input {
                min-width: 100%;
            }

            .quick-actions {
                flex-direction: column;
                gap: 10px;
            }

            .action-btn {
                justify-content: center;
            }

            .filter-group {
                margin-bottom: 15px;
            }

            .search-action-btn {
                padding: 10px 15px;
                font-size: 13px;
            }
        }

        @media (max-width: 576px) {
            .search-filter-section {
                padding: 20px 15px;
            }

            .filter-buttons {
                gap: 5px;
            }

            .filter-btn {
                padding: 5px 10px;
                font-size: 11px;
            }

            .action-btn {
                padding: 8px 15px;
                font-size: 13px;
            }

            /* Mobile table optimization */
            .room-fees-table {
                font-size: 12px;
            }

            .room-fees-table thead th,
            .room-fees-table tbody td {
                padding: 6px 3px;
            }

            .status-badge {
                padding: 3px 6px;
                font-size: 9px;
            }

            .room-description {
                max-width: 120px;
                font-size: 11px;
            }

            .room-price {
                font-size: 12px;
            }
        }

        /* Loading Animation */
        .loading {
            display: none;
            text-align: center;
            padding: 40px;
        }

        .loading i {
            font-size: 2rem;
            color: #dfa974;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b6b6b;
        }

        .empty-state i {
            font-size: 4rem;
            color: #dfa974;
            margin-bottom: 20px;
        }

        .empty-state h4 {
            color: #19191a;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Offcanvas Menu Section Begin -->
    <div class="offcanvas-menu-overlay"></div>
    <div class="canvas-open">
        <i class="icon_menu"></i>
    </div>
    <div class="offcanvas-menu-wrapper">
        <div class="canvas-close">
            <i class="icon_close"></i>
        </div>
        <div class="search-icon  search-switch">
            <i class="icon_search"></i>
        </div>
        <div class="header-configure-area">
            <div class="language-option">
                <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
                <span>EN <i class="fa fa-angle-down"></i></span>
                <div class="flag-dropdown">
                    <ul>
                        <li><a href="#">Zi</a></li>
                        <li><a href="#">Fr</a></li>
                    </ul>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="bk-btn">Logout</a>
        </div>
        <nav class="mainmenu mobile-menu">
            <ul>
                <li class="active"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                <li><a href="#">Pages</a>
                    <ul class="dropdown">
                        <li><a href="${pageContext.request.contextPath}/room-details">Room Details</a></li>
                        <li><a href="${pageContext.request.contextPath}/blog-details">Blog Details</a></li>
                    </ul>
                </li>
                <li><a href="${pageContext.request.contextPath}/blog">News</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
            </ul>
        </nav>
        <div id="mobile-menu-wrap"></div>
        <div class="top-social">
            <a href="#"><i class="fa fa-facebook"></i></a>
            <a href="#"><i class="fa fa-twitter"></i></a>
            <a href="#"><i class="fa fa-tripadvisor"></i></a>
            <a href="#"><i class="fa fa-instagram"></i></a>
        </div>
        <ul class="top-widget">
            <li><i class="fa fa-phone"></i> (84) 359 797 703</li>
            <li><i class="fa fa-envelope"></i> 36hotel@gmail.com</li>
        </ul>
    </div>
    <!-- Offcanvas Menu Section End -->

    <!-- Header Section Begin -->
    <header class="header-section">
        <div class="top-nav">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6">
                        <ul class="tn-left">
                            <li><i class="fa fa-phone"></i> (84) 359 797 703</li>
                            <li><i class="fa fa-envelope"></i> 36hotel@gmail.com</li>
                        </ul>
                    </div>
                    <div class="col-lg-6">
                        <div class="tn-right">
                            <div class="top-social">
                                <a href="#"><i class="fa fa-facebook"></i></a>
                                <a href="#"><i class="fa fa-twitter"></i></a>
                                <a href="#"><i class="fa fa-tripadvisor"></i></a>
                                <a href="#"><i class="fa fa-instagram"></i></a>
                            </div>
                            <a href="${pageContext.request.contextPath}/login" class="bk-btn">Logout</a>
                            <div class="language-option">
                                <img src="${pageContext.request.contextPath}/img/flag.jpg" alt="">
                                <span>EN <i class="fa fa-angle-down"></i></span>
                                <div class="flag-dropdown">
                                    <ul>
                                        <li><a href="#">Zi</a></li>
                                        <li><a href="#">Fr</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="menu-item">
            <div class="container">
                <div class="row">
                    <div class="col-lg-2">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home">
                                <img src="${pageContext.request.contextPath}/img/logo.png" alt="">
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-10">
                        <div class="nav-menu">
                            <nav class="mainmenu">
                                <ul>
                                    <li class="active"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                    <li><a href="${pageContext.request.contextPath}/rooms">Rooms</a></li>
                                    <li><a href="${pageContext.request.contextPath}/about-us">About Us</a></li>
                                    <li><a href="#">Pages</a>
                                        <ul class="dropdown">
                                            <li><a href="${pageContext.request.contextPath}/room-details">Room Details</a></li>
                                            <li><a href="${pageContext.request.contextPath}/blog-details">Blog Details</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/blog">News</a></li>
                                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                                </ul>
                            </nav>
                            <div class="nav-right search-switch">
                                <i class="icon_search"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <!-- Header End -->

    <!-- Receptionist Header Section Begin -->
    <div class="receptionist-header">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2><i class="fa fa-dollar"></i> Room Fees Management</h2>
                    <p>View and manage room pricing information for receptionist</p>
                </div>
            </div>
        </div>
    </div>
    <!-- Receptionist Header Section End -->

    <!-- Room Fees Section Begin -->
    <section class="main-content">
        <div class="container">
            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="icon-wrapper">
                            <i class="fa fa-bed"></i>
                        </div>
                        <h3>${roomsWithCategory.size()}</h3>
                        <p>Total Rooms</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="icon-wrapper">
                            <i class="fa fa-check-circle"></i>
                        </div>
                        <h3>
                            <c:set var="availableCount" value="0" />
                            <c:forEach var="room" items="${roomsWithCategory}">
                                <c:if test="${room.status == 'available'}">
                                    <c:set var="availableCount" value="${availableCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${availableCount}
                        </h3>
                        <p>Available</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="icon-wrapper">
                            <i class="fa fa-times-circle"></i>
                        </div>
                        <h3>
                            <c:set var="bookedCount" value="0" />
                            <c:forEach var="room" items="${roomsWithCategory}">
                                <c:if test="${room.status == 'booked'}">
                                    <c:set var="bookedCount" value="${bookedCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${bookedCount}
                        </h3>
                        <p>Booked</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="icon-wrapper">
                            <i class="fa fa-wrench"></i>
                        </div>
                        <h3>
                            <c:set var="maintenanceCount" value="0" />
                            <c:forEach var="room" items="${roomsWithCategory}">
                                <c:if test="${room.status == 'maintenance'}">
                                    <c:set var="maintenanceCount" value="${maintenanceCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${maintenanceCount}
                        </h3>
                        <p>Maintenance</p>
                    </div>
                </div>
            </div>

            <!-- Enhanced Search and Filter Section -->
            <div class="search-filter-section">
                <h5><i class="fa fa-search"></i> Search & Filter Rooms</h5>
                
                <!-- Search Input -->
                <div class="search-input-wrapper">
                    <i class="fa fa-search"></i>
                    <input type="text" id="searchInput" class="search-input" placeholder="Search rooms by name, category, status, or description...">
                </div>
                
                <!-- Advanced Filters Row -->
                <div class="row mt-4">
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="filter-label"><i class="fa fa-filter"></i> Status</label>
                            <select id="statusFilter" class="filter-select">
                                <option value="all">All Rooms</option>
                                <option value="available">Available</option>
                                <option value="booked">Booked</option>
                                <option value="maintenance">Maintenance</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="filter-label"><i class="fa fa-tag"></i> Category</label>
                            <select id="categoryFilter" class="filter-select">
                                <option value="all">All Categories</option>
                                <option value="family">Family</option>
                                <option value="deluxe">Deluxe</option>
                                <option value="double">Double</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="filter-label"><i class="fa fa-dollar"></i> Price Range</label>
                            <div class="price-range-wrapper">
                                <input type="number" id="minPrice" class="price-input" placeholder="Min Price" min="0">
                                <span class="price-separator">-</span>
                                <input type="number" id="maxPrice" class="price-input" placeholder="Max Price" min="0">
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6">
                        <div class="filter-group">
                            <label class="filter-label"><i class="fa fa-search"></i> Search Action</label>
                            <button class="search-action-btn" id="applyAllFilters">
                                <i class="fa fa-search"></i> Search & Filter
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions mt-3">
                    <button class="action-btn" id="clearFilters">
                        <i class="fa fa-refresh"></i> Clear All Filters
                    </button>
                    <button class="action-btn" id="exportData">
                        <i class="fa fa-download"></i> Export Data
                    </button>
                    <button class="action-btn" id="printTable">
                        <i class="fa fa-print"></i> Print Table
                    </button>
                </div>
            </div>

            <!-- Enhanced Room Fees Table -->
            <div class="room-fees-table">
                <div class="table-header">
                    <h4><i class="fa fa-table"></i> Room Pricing Information</h4>
                </div>
                <div class="loading" id="tableLoading">
                    <i class="fa fa-spinner"></i>
                    <p>Loading room data...</p>
                </div>
                <table class="table" id="roomTable">
                    <thead>
                        <tr>
                            <th><i class="fa fa-home"></i> Room Name</th>
                            <th><i class="fa fa-tag"></i> Category</th>
                            <th><i class="fa fa-dollar"></i> Price(/Night)</th>
                            <th><i class="fa fa-users"></i> Capacity</th>
                            <th><i class="fa fa-info-circle"></i> Status</th>
                            <th><i class="fa fa-file-text"></i> Description</th>
                            <th><i class="fa fa-eye"></i> Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="room" items="${roomsWithCategory}">
                            <tr data-status="${room.status}" data-category="${room.categoryName}">
                                <td>
                                    <div class="room-name">
                                        <a href="${pageContext.request.contextPath}/receptionist/room-fee-detail?roomId=${room.roomId}" 
                                           style="color: #19191a; text-decoration: none; font-weight: 700;">
                                            ${room.name}
                                        </a>
                                    </div>
                                    <div class="room-number">Room #${room.roomId}</div>
                                </td>
                                <td>
                                    <span class="category-badge">${room.categoryName}</span>
                                </td>
                                <td>
                                    <div class="room-price">
                                        <fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND"/>
                                    </div>
                                </td>
                                <td>
                                    <div class="capacity-info">
                                        <i class="fa fa-users"></i>
                                        ${room.capacity} guests
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${room.status == 'available'}">
                                            <span class="status-badge status-available">
                                                <i class="fa fa-check"></i> Available
                                            </span>
                                        </c:when>
                                        <c:when test="${room.status == 'booked'}">
                                            <span class="status-badge status-booked">
                                                <i class="fa fa-times"></i> Booked
                                            </span>
                                        </c:when>
                                        <c:when test="${room.status == 'maintenance'}">
                                            <span class="status-badge status-maintenance">
                                                <i class="fa fa-wrench"></i> Maintenance
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="room-description">${room.description}</div>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/receptionist/room-fee-detail?roomId=${room.roomId}" 
                                       class="btn btn-sm" 
                                       style="background: linear-gradient(135deg, #dfa974, #c8965a); color: white; border: none; padding: 8px 15px; border-radius: 15px; font-size: 12px; font-weight: 600; text-decoration: none; transition: all 0.3s ease;">
                                        <i class="fa fa-eye"></i> View Details
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="empty-state" id="emptyState" style="display: none;">
                    <i class="fa fa-search"></i>
                    <h4>No rooms found</h4>
                    <p>Try adjusting your search criteria or filters</p>
                </div>
            </div>

            <!-- Category Summary Section -->
            <div class="section-title">
                <span>Room Categories</span>
                <h2>Category Overview</h2>
            </div>

            <div class="row">
                <c:forEach var="category" items="${categories}">
                    <div class="col-lg-4 col-md-6">
                        <div class="category-summary">
                            <h6>
                                <span class="category-badge">${category.name}</span>
                            </h6>
                            <p>${category.description}</p>
                            <div class="category-stats">
                                <span class="category-room-count">
                                    <i class="fa fa-home"></i>
                                    <c:set var="categoryRoomCount" value="0" />
                                    <c:forEach var="room" items="${roomsWithCategory}">
                                        <c:if test="${room.categoryName == category.name}">
                                            <c:set var="categoryRoomCount" value="${categoryRoomCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${categoryRoomCount} rooms
                                </span>
                                <span class="category-price-range">
                                    <c:set var="minPrice" value="999999999" />
                                    <c:set var="maxPrice" value="0" />
                                    <c:forEach var="room" items="${roomsWithCategory}">
                                        <c:if test="${room.categoryName == category.name}">
                                            <c:if test="${room.price < minPrice}">
                                                <c:set var="minPrice" value="${room.price}" />
                                            </c:if>
                                            <c:if test="${room.price > maxPrice}">
                                                <c:set var="maxPrice" value="${room.price}" />
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                    <fmt:formatNumber value="${minPrice}" type="currency" currencyCode="VND"/> -
                                    <fmt:formatNumber value="${maxPrice}" type="currency" currencyCode="VND"/>
                                </span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-top: 20px;">
                    <i class="fa fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>
        </div>
    </section>
    <!-- Room Fees Section End -->

    <!-- Footer Section Begin -->
    <footer class="footer-section">
        <div class="container">
            <div class="footer-text">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="ft-about">
                            <div class="logo">
                                <a href="${pageContext.request.contextPath}/home">
                                    <img src="${pageContext.request.contextPath}/img/footer-logo.png" alt="">
                                </a>
                            </div>
                            <p>We inspire and reach millions of travelers<br /> across 90 local websites</p>
                            <div class="fa-social">
                                <a href="#"><i class="fa fa-facebook"></i></a>
                                <a href="#"><i class="fa fa-twitter"></i></a>
                                <a href="#"><i class="fa fa-tripadvisor"></i></a>
                                <a href="#"><i class="fa fa-instagram"></i></a>
                                <a href="#"><i class="fa fa-youtube-play"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 offset-lg-1">
                        <div class="ft-contact">
                            <h6>Contact Us</h6>
                            <ul>
                                <li>(84) 359 797 703</li>
                                <li>36hotel@gmail.com</li>
                                <li>Thanh Hoa, Viet Nam</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 offset-lg-1">
                        <div class="ft-newslatter">
                            <h6>New latest</h6>
                            <p>Get the latest updates and offers.</p>
                            <form action="post" class="fn-form">
                                <input type="text" placeholder="Email">
                                <button type="submit"><i class="fa fa-send"></i></button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="copyright-option">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                            <li><a href="#">Terms of use</a></li>
                            <li><a href="#">Privacy</a></li>
                            <li><a href="#">Environmental Policy</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-5">
                        <div class="co-text">
                            <p>
                                Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                                All rights reserved by 36 Hotel
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <!-- Footer Section End -->

    <!-- Search model Begin -->
    <div class="search-model">
        <div class="h-100 d-flex align-items-center justify-content-center">
            <div class="search-close-switch"><i class="icon_close"></i></div>
            <form class="search-model-form">
                <input type="text" id="search-input" placeholder="Search here.....">
            </form>
        </div>
    </div>
    <!-- Search model end -->

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
        // Enhanced Search and Filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchInput');
            const statusFilter = document.getElementById('statusFilter');
            const categoryFilter = document.getElementById('categoryFilter');
            const minPriceInput = document.getElementById('minPrice');
            const maxPriceInput = document.getElementById('maxPrice');
            const applyAllFilters = document.getElementById('applyAllFilters');
            const tableRows = document.querySelectorAll('#roomTable tbody tr');
            const emptyState = document.getElementById('emptyState');
            const roomTable = document.getElementById('roomTable');
            const clearFilters = document.getElementById('clearFilters');
            const exportData = document.getElementById('exportData');
            const printTable = document.getElementById('printTable');

            // Search functionality (real-time)
            searchInput.addEventListener('input', function() {
                applyFilters();
            });

            // Apply all filters button
            applyAllFilters.addEventListener('click', function() {
                applyFilters();
            });

            // Clear filters
            clearFilters.addEventListener('click', function() {
                // Reset all inputs
                searchInput.value = '';
                statusFilter.value = 'all';
                categoryFilter.value = 'all';
                minPriceInput.value = '';
                maxPriceInput.value = '';
                
                // Show all rows
                tableRows.forEach(row => {
                    row.style.display = '';
                });
                
                updateEmptyState();
            });

            // Export data
            exportData.addEventListener('click', function() {
                exportToCSV();
            });

            // Print table
            printTable.addEventListener('click', function() {
                window.print();
            });

            function applyFilters() {
                const searchTerm = searchInput.value.toLowerCase();
                const selectedStatus = statusFilter.value;
                const selectedCategory = categoryFilter.value;
                const minPrice = parseFloat(minPriceInput.value) || null;
                const maxPrice = parseFloat(maxPriceInput.value) || null;
                
                // Validate price range
                if (minPrice !== null && maxPrice !== null && minPrice > maxPrice) {
                    alert('Minimum price cannot be greater than maximum price');
                    return;
                }

                tableRows.forEach(row => {
                    const status = row.dataset.status;
                    const category = row.dataset.category.toLowerCase();
                    const text = row.textContent.toLowerCase();
                    const price = parseFloat(row.querySelector('.room-price').textContent.replace(/[^\d]/g, '')) || 0;

                    // Check status filter match
                    let matchesStatus = selectedStatus === 'all' || status === selectedStatus;

                    // Check category filter match
                    let matchesCategory = selectedCategory === 'all' || category === selectedCategory;

                    // Check search match
                    let matchesSearch = searchTerm === '' || text.includes(searchTerm);

                    // Check price range match
                    let matchesPrice = true;
                    if (minPrice !== null && price < minPrice) {
                        matchesPrice = false;
                    }
                    if (maxPrice !== null && price > maxPrice) {
                        matchesPrice = false;
                    }

                    if (matchesStatus && matchesCategory && matchesSearch && matchesPrice) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });

                updateEmptyState();
            }


            function updateEmptyState() {
                const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none');
                
                if (visibleRows.length === 0) {
                    roomTable.style.display = 'none';
                    emptyState.style.display = 'block';
                } else {
                    roomTable.style.display = 'table';
                    emptyState.style.display = 'none';
                }
            }

            function exportToCSV() {
                const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none');
                let csvContent = "Room Name,Category,Price(/Night),Capacity,Status,Description\n";
                
                visibleRows.forEach(row => {
                    const name = row.querySelector('.room-name').textContent.trim();
                    const category = row.querySelector('.category-badge').textContent.trim();
                    const price = row.querySelector('.room-price').textContent.trim();
                    const capacity = row.querySelector('.capacity-info').textContent.trim();
                    const status = row.querySelector('.status-badge').textContent.trim();
                    const description = row.querySelector('.room-description').textContent.trim();
                    
                    csvContent += `"${name}","${category}","${price}","${capacity}","${status}","${description}"\n`;
                });
                
                const blob = new Blob([csvContent], { type: 'text/csv' });
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'room-fees-export.csv';
                a.click();
                window.URL.revokeObjectURL(url);
            }

            // Animate stats cards on load
            const statsCards = document.querySelectorAll('.stats-card');
            statsCards.forEach((card, index) => {
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

            // Animate table rows on load
            setTimeout(() => {
                tableRows.forEach((row, index) => {
                    setTimeout(() => {
                        row.style.opacity = '0';
                        row.style.transform = 'translateX(-20px)';
                        row.style.transition = 'all 0.4s ease';

                        setTimeout(() => {
                            row.style.opacity = '1';
                            row.style.transform = 'translateX(0)';
                        }, 50);
                    }, index * 50);
                });
            }, 800);
        });

        // Print functionality
        function printReport() {
            window.print();
        }

        // Export functionality (placeholder)
        function exportToExcel() {
            alert('Export to Excel functionality would be implemented here');
        }

        function exportToPDF() {
            alert('Export to PDF functionality would be implemented here');
        }

        // Smooth scrolling for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>
