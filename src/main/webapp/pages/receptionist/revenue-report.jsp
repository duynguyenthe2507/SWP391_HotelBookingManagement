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
    <title>Revenue Report - 36 Hotel</title>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist-revenue-report.css" type="text/css">
</head>

<body>
<c:set var="pageActive" value="revenue-report"/>
<div class="dashboard-wrapper">
    <jsp:include page="/common/sidebar.jsp"/>
    <div class="dashboard-content">
    <!-- Page Preloder -->
    <div id="preloder">
        <div class="loader"></div>
    </div>

    <!-- Main Content Section -->
    <section class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fa fa-line-chart"></i> Revenue Report</h2>
                <p>View and analyze revenue data</p>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success-pastel">
                    <i class="fa fa-check-circle"></i> ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fa fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <!-- Summary Cards -->
            <c:if test="${not empty summary}">
                <div class="summary-cards">
                    <div class="summary-card">
                        <div class="card-icon">
                            <i class="fa fa-file-text-o"></i>
                        </div>
                        <div class="card-content">
                            <h3>Total Invoices</h3>
                            <p class="card-value">${summary.totalInvoices}</p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="card-icon">
                            <i class="fa fa-money"></i>
                        </div>
                        <div class="card-content">
                            <h3>Total Revenue</h3>
                            <p class="card-value">
                                <fmt:formatNumber value="${summary.totalRevenue}" type="currency" currencySymbol="đ"/>
                            </p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="card-icon">
                            <i class="fa fa-bed"></i>
                        </div>
                        <div class="card-content">
                            <h3>Room Revenue</h3>
                            <p class="card-value">
                                <fmt:formatNumber value="${summary.totalRoomRevenue}" type="currency" currencySymbol="đ"/>
                            </p>
                        </div>
                    </div>
                    <div class="summary-card">
                        <div class="card-icon">
                            <i class="fa fa-cutlery"></i>
                        </div>
                        <div class="card-content">
                            <h3>Service Revenue</h3>
                            <p class="card-value">
                                <fmt:formatNumber value="${summary.totalServiceRevenue}" type="currency" currencySymbol="đ"/>
                            </p>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/receptionist/revenue-report" method="get" class="filter-form">
                    <div class="filter-group">
                        <label for="period">View By:</label>
                        <select name="period" id="period" class="form-control" onchange="updateFilterForm()">
                            <option value="day" ${period == 'day' ? 'selected' : ''}>By Day</option>
                            <option value="month" ${period == 'month' ? 'selected' : ''}>By Month</option>
                            <option value="year" ${period == 'year' ? 'selected' : ''}>By Year</option>
                        </select>
                    </div>

                    <!-- Day filter -->
                    <div class="filter-group" id="dayFilter" style="display: ${period == 'day' ? 'block' : 'none'};">
                        <label for="startDate">Start Date:</label>
                        <input type="date" name="startDate" id="startDate" class="form-control"
                               value="${startDate != null ? startDate : ''}">
                    </div>
                    <div class="filter-group" id="dayFilterEnd" style="display: ${period == 'day' ? 'block' : 'none'};">
                        <label for="endDate">End Date:</label>
                        <input type="date" name="endDate" id="endDate" class="form-control"
                               value="${endDate != null ? endDate : ''}">
                    </div>

                    <!-- Month filter -->
                    <div class="filter-group" id="monthFilter" style="display: ${period == 'month' ? 'block' : 'none'};">
                        <label for="year">Year:</label>
                        <select name="year" id="year" class="form-control">
                            <c:forEach var="y" begin="${currentYear - 5}" end="${currentYear + 1}">
                                <option value="${y}" ${selectedYear == y ? 'selected' : ''}>${y}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-search"></i> Apply Filter
                        </button>
                    </div>
                </form>
            </div>

            <!-- Chart Section -->
            <div class="chart-section">
                <div class="chart-card">
                    <div class="card-header">
                        <h4><i class="fa fa-bar-chart"></i> Revenue Chart</h4>
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Revenue Table -->
            <div class="revenue-table-section">
                <div class="table-card">
                    <div class="card-header">
                        <h4><i class="fa fa-table"></i> Revenue Details</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty revenueData}">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <c:choose>
                                                <c:when test="${periodType == 'day'}">
                                                    <th>Date</th>
                                                </c:when>
                                                <c:when test="${periodType == 'month'}">
                                                    <th>Month</th>
                                                </c:when>
                                                <c:otherwise>
                                                    <th>Year</th>
                                                </c:otherwise>
                                            </c:choose>
                                            <th>Invoices</th>
                                            <th>Room Revenue</th>
                                            <th>Service Revenue</th>
                                            <th>Tax</th>
                                            <th>Total Revenue</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="data" items="${revenueData}">
                                            <tr>
                                                <c:choose>
                                                    <c:when test="${periodType == 'day'}">
                                                        <td>
                                                            <fmt:formatDate value="${data.date}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                    </c:when>
                                                    <c:when test="${periodType == 'month'}">
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${data.month == 1}">January</c:when>
                                                                <c:when test="${data.month == 2}">February</c:when>
                                                                <c:when test="${data.month == 3}">March</c:when>
                                                                <c:when test="${data.month == 4}">April</c:when>
                                                                <c:when test="${data.month == 5}">May</c:when>
                                                                <c:when test="${data.month == 6}">June</c:when>
                                                                <c:when test="${data.month == 7}">July</c:when>
                                                                <c:when test="${data.month == 8}">August</c:when>
                                                                <c:when test="${data.month == 9}">September</c:when>
                                                                <c:when test="${data.month == 10}">October</c:when>
                                                                <c:when test="${data.month == 11}">November</c:when>
                                                                <c:when test="${data.month == 12}">December</c:when>
                                                            </c:choose>
                                                        </td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td>${data.year}</td>
                                                    </c:otherwise>
                                                </c:choose>
                                                <td>${data.invoiceCount}</td>
                                                <td>
                                                    <fmt:formatNumber value="${data.roomRevenue}" type="currency" currencySymbol="đ"/>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${data.serviceRevenue}" type="currency" currencySymbol="đ"/>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${data.taxRevenue}" type="currency" currencySymbol="đ"/>
                                                </td>
                                                <td>
                                                    <strong>
                                                        <fmt:formatNumber value="${data.totalRevenue}" type="currency" currencySymbol="đ"/>
                                                    </strong>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fa fa-line-chart"></i>
                                    <h4>No Revenue Data</h4>
                                    <p>No revenue data available for the selected period.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Detailed Invoice List (for day view) -->
            <c:if test="${period == 'day' && not empty revenueDetails}">
                <div class="details-table-section">
                    <div class="table-card">
                        <div class="card-header">
                            <h4><i class="fa fa-list"></i> Invoice Details</h4>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Invoice ID</th>
                                        <th>Booking ID</th>
                                        <th>Customer</th>
                                        <th>Issue Date</th>
                                        <th>Room Cost</th>
                                        <th>Service Cost</th>
                                        <th>Tax</th>
                                        <th>Total Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="detail" items="${revenueDetails}">
                                        <tr>
                                            <td>#${detail.invoiceId}</td>
                                            <td>#${detail.bookingId}</td>
                                            <td>
                                                <div>${detail.customerName}</div>
                                                <small>${detail.customerPhone}</small>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${detail.issuedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${detail.totalRoomCost}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${detail.totalServiceCost}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${detail.taxAmount}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td>
                                                <strong>
                                                    <fmt:formatNumber value="${detail.totalAmount}" type="currency" currencySymbol="đ"/>
                                                </strong>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </section>

    <!-- Footer removed to match booking-list.jsp layout -->
  </div>
</div>

    <!-- Js Plugins -->
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
    <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

    <script>
        // Update filter form based on period selection
        function updateFilterForm() {
            const period = document.getElementById('period').value;
            const dayFilter = document.getElementById('dayFilter');
            const dayFilterEnd = document.getElementById('dayFilterEnd');
            const monthFilter = document.getElementById('monthFilter');
            
            if (period === 'day') {
                dayFilter.style.display = 'block';
                dayFilterEnd.style.display = 'block';
                monthFilter.style.display = 'none';
            } else if (period === 'month') {
                dayFilter.style.display = 'none';
                dayFilterEnd.style.display = 'none';
                monthFilter.style.display = 'block';
            } else {
                dayFilter.style.display = 'none';
                dayFilterEnd.style.display = 'none';
                monthFilter.style.display = 'none';
            }
        }
        
        // Wait for Chart.js to be fully loaded
        window.addEventListener('load', function() {

        // Initialize chart when DOM is ready and Chart.js is loaded
        function initializeChart() {
            const chartCanvas = document.getElementById('revenueChart');
            if (!chartCanvas) {
                console.error('Chart canvas not found');
                return;
            }
            
            // Check if Chart.js is loaded
            if (typeof Chart === 'undefined') {
                console.log('Chart.js not loaded yet, retrying...');
                setTimeout(initializeChart, 200);
                return;
            }
            
            <c:choose>
            <c:when test="${not empty revenueData}">
            const ctx = chartCanvas.getContext('2d');
            
            // Build revenue data array safely
            const revenueDataArray = [];
            <c:forEach var="data" items="${revenueData}" varStatus="status">
                <c:set var="labelValue" value=""/>
                <c:choose>
                    <c:when test="${periodType == 'day'}">
                        <fmt:formatDate value="${data.date}" pattern="dd/MM" var="formattedDate"/>
                        <c:set var="labelValue" value="${formattedDate}"/>
                    </c:when>
                    <c:when test="${periodType == 'month'}">
                        <c:choose>
                            <c:when test="${data.month == 1}"><c:set var="labelValue" value="Jan"/></c:when>
                            <c:when test="${data.month == 2}"><c:set var="labelValue" value="Feb"/></c:when>
                            <c:when test="${data.month == 3}"><c:set var="labelValue" value="Mar"/></c:when>
                            <c:when test="${data.month == 4}"><c:set var="labelValue" value="Apr"/></c:when>
                            <c:when test="${data.month == 5}"><c:set var="labelValue" value="May"/></c:when>
                            <c:when test="${data.month == 6}"><c:set var="labelValue" value="Jun"/></c:when>
                            <c:when test="${data.month == 7}"><c:set var="labelValue" value="Jul"/></c:when>
                            <c:when test="${data.month == 8}"><c:set var="labelValue" value="Aug"/></c:when>
                            <c:when test="${data.month == 9}"><c:set var="labelValue" value="Sep"/></c:when>
                            <c:when test="${data.month == 10}"><c:set var="labelValue" value="Oct"/></c:when>
                            <c:when test="${data.month == 11}"><c:set var="labelValue" value="Nov"/></c:when>
                            <c:when test="${data.month == 12}"><c:set var="labelValue" value="Dec"/></c:when>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:set var="labelValue" value="${data.year}"/>
                    </c:otherwise>
                </c:choose>
                revenueDataArray.push({
                    label: "${labelValue}",
                    totalRevenue: ${data.totalRevenue != null ? data.totalRevenue : 0},
                    roomRevenue: ${data.roomRevenue != null ? data.roomRevenue : 0},
                    serviceRevenue: ${data.serviceRevenue != null ? data.serviceRevenue : 0},
                    taxRevenue: ${data.taxRevenue != null ? data.taxRevenue : 0}
                });
            </c:forEach>

            if (!revenueDataArray || revenueDataArray.length === 0) {
                console.warn('No revenue data available for chart');
                chartCanvas.parentElement.innerHTML = '<p style="text-align: center; padding: 40px; color: #6b6b6b;">No data available for the selected period.</p>';
                return;
            }
            
            const labels = revenueDataArray.map(item => item.label);
            const totalRevenueData = revenueDataArray.map(item => item.totalRevenue || 0);
            const roomRevenueData = revenueDataArray.map(item => item.roomRevenue || 0);
            const serviceRevenueData = revenueDataArray.map(item => item.serviceRevenue || 0);

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Total Revenue',
                            data: totalRevenueData,
                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Room Revenue',
                            data: roomRevenueData,
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Service Revenue',
                            data: serviceRevenueData,
                            backgroundColor: 'rgba(255, 159, 64, 0.6)',
                            borderColor: 'rgba(255, 159, 64, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    aspectRatio: 2,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND'
                                    }).format(value);
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    label += new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND'
                                    }).format(context.parsed.y);
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
            </c:when>
            <c:otherwise>
            // No data available
            chartCanvas.parentElement.innerHTML = '<p style="text-align: center; padding: 40px; color: #6b6b6b;">No data available for the selected period.</p>';
            </c:otherwise>
            </c:choose>
        }
        
            // Start initialization after page is fully loaded
            setTimeout(function() {
                if (typeof Chart !== 'undefined') {
                    initializeChart();
                } else {
                    console.error('Chart.js is not available');
                    const chartCanvas = document.getElementById('revenueChart');
                    if (chartCanvas) {
                        chartCanvas.parentElement.innerHTML = '<p style="text-align: center; padding: 40px; color: #dc3545;">Error: Chart.js library failed to load. Please refresh the page.</p>';
                    }
                }
            }, 500);
        });
    </script>

</body>
</html>

