<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hotel Rules | 36 Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body {
            background-color: #f9f9f9;
            font-family: 'Lora', serif;
        }
        .page-header {
            background: url('${pageContext.request.contextPath}/img/hero/hero-3.jpg') center/cover no-repeat;
            padding: 120px 0;
            color: white;
            text-align: center;
            position: relative;
        }
        .page-header::after {
            content: "";
            position: absolute;
            inset: 0;
            background-color: rgba(0,0,0,0.55);
        }
        .page-header h1 {
            position: relative;
            z-index: 2;
            font-size: 48px;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .rules-section {
            padding: 60px 0;
        }
        .rule-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 25px;
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }
        .rule-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 14px rgba(0,0,0,0.12);
        }
        .rule-title {
            color: #dfa974;
            font-weight: 700;
            font-size: 22px;
        }
        .rule-desc {
            margin-top: 10px;
            color: #555;
            white-space: pre-line;
        }
        .rule-date {
            font-size: 14px;
            color: #888;
            margin-top: 15px;
        }
        .status-active {
            background: #28a745;
            color: white;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 13px;
        }
        .status-inactive {
            background: #dc3545;
            color: white;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 13px;
        }
    </style>
</head>

<body>


<jsp:include page="/common/header.jsp"/>


<section class="page-header">
    <h1>Hotel Policies & Rules</h1>
</section>


<section class="rules-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <c:if test="${empty rules}">
                    <div class="text-center">
                        <p class="text-muted">No rules or policies available at this time.</p>
                    </div>
                </c:if>

                <c:forEach var="r" items="${rules}">
                    <div class="rule-card">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="rule-title">${r.title}</h3>
                            <span class="${r.status ? 'status-active' : 'status-inactive'}">
                                    ${r.status ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                        <p class="rule-desc">${r.description}</p>
                        <p class="rule-date">
                            Created: ${r.createdAt} |
                            Updated: ${r.updatedAt}
                        </p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</section>

<!-- ✅ Footer -->
<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
