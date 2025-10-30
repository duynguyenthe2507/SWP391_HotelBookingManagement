<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Kết quả thanh toán</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f3f4f6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .card {
            background: #fff;
            padding: 40px 60px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        h2 {
            color: #16a34a;
        }
        .error {
            color: #dc2626;
        }
        a {
            display: inline-block;
            margin-top: 24px;
            text-decoration: none;
            color: #2563eb;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2 class="${message.contains('thành công') ? '' : 'error'}">
            ${message}
        </h2>
        <a href="${pageContext.request.contextPath}/home">⬅ Quay về trang chủ</a>
    </div>
</body>
</html>
