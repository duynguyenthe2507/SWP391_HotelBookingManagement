<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Service Guidelines | 36 Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Style cơ bản */
        body { background-color: #f9f9f9; font-family: 'Lora', serif; }
        .page-header {
            background: url('${pageContext.request.contextPath}/img/hero/hero-2.jpg') center/cover no-repeat;
            padding: 120px 0;
            color: white; text-align: center; position: relative;
        }
        .page-header::after { content: ""; position: absolute; inset: 0; background-color: rgba(0,0,0,0.55); }
        .page-header h1 { position: relative; z-index: 2; font-size: 48px; font-weight: 700; }
        .guideline-section { padding: 60px 0; }

        /* STYLE CHO CARD */
        .guideline-card {
            display: flex;
            gap: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .guideline-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 14px rgba(0,0,0,0.12);
        }
        .guideline-img {
            width: 220px;
            height: 180px;
            object-fit: cover;
        }
        .guideline-content {
            padding: 20px;
            flex: 1;
        }
        /* Khi không có ảnh */
        .guideline-card.no-image .guideline-content {
            padding-left: 20px;
        }

        .guideline-title {
            color: #dfa974;
            font-weight: 700;
            font-size: 22px;
            margin: 0 0 8px;
        }
        .guideline-desc {
            white-space: pre-wrap;
            margin: 0;
            color: #555;
            font-family: inherit;
        }
        .guideline-meta {
            font-size: 13px;
            color: #888;
            margin-top: 15px;
        }
    </style>
</head>
<body>

<%@ include file="/common/header.jsp" %>

<section class="page-header">
    <h1>Service Guidelines</h1>
</section>

<section class="guideline-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">

                <c:if test="${empty guidelines}">
                    <div class="text-center">
                        <p class="text-muted">No guidelines available at the moment.</p>
                    </div>
                </c:if>

                <c:forEach var="g" items="${guidelines}">
                    <div class="guideline-card ${empty g.imageUrl ? 'no-image' : ''}">

                        <c:if test="${not empty g.imageUrl}">
                            <img src="${g.imageUrl}" alt="${fn:escapeXml(g.title)}" class="guideline-img"/>
                        </c:if>

                        <div class="guideline-content">
                            <h3 class="guideline-title">${fn:escapeXml(g.title)}</h3>
                            <p class="guideline-desc">${fn:escapeXml(g.content)}</p>
                            <div class="guideline-meta">
                                <span>Updated: <fmt:formatDate value="${g.updatedAt}" pattern="dd/MM/yyyy"/></span>
                            </div>
                        </div>

                    </div>
                </c:forEach>

            </div>
        </div>
    </div>
</section>

<%@ include file="/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
</body>
</html>