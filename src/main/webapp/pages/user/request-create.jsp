<%--
    request-create.jsp
    Layout đồng bộ với my-requests
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>New Request | 36 Hotel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Giữ nguyên CSS cũ */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Lora', serif;
            min-height: 100vh;
        }
        .page-header {
            background: linear-gradient(135deg, rgba(223, 169, 116, 0.95), rgba(200, 150, 90, 0.95)),
            url('${pageContext.request.contextPath}/img/hero/hero-3.jpg') center/cover no-repeat;
            padding: 100px 0 80px;
            color: white;
            text-align: center;
            position: relative;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .page-header h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .page-header p {
            font-size: 18px;
            opacity: 0.95;
        }
        .create-request-section { padding: 60px 0; }
        .back-button {
            display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px;
            background: white; color: #19191a; text-decoration: none; border-radius: 25px;
            font-weight: 600; transition: all 0.3s ease; font-size: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 30px;
        }
        .back-button:hover {
            background: #f8f9fa; color: #dfa974; transform: translateX(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.12);
        }
        .form-card {
            background: white; border-radius: 15px; padding: 35px 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-left: 4px solid #dfa974;
        }
        .form-card-title {
            color: #19191a; font-weight: 700; font-size: 26px; margin-bottom: 10px;
            display: flex; align-items: center; gap: 12px;
        }
        .form-card-title i { color: #dfa974; font-size: 28px; }
        .form-card-subtitle {
            color: #666; font-size: 15px; margin-bottom: 30px; padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        .form-label {
            font-weight: 600; color: #19191a; margin-bottom: 8px; font-size: 15px;
            display: flex; align-items: center; gap: 8px;
        }
        .form-label i { color: #dfa974; width: 20px; text-align: center; }
        .form-label .required { color: #d63031; font-size: 16px; }
        .form-control, .form-select {
            border-radius: 10px; padding: 12px 18px; border: 2px solid #e5e5e5;
            transition: all 0.3s ease; font-size: 15px; background: #fafafa;
        }
        .form-control:focus, .form-select:focus {
            border-color: #dfa974; box-shadow: 0 0 0 4px rgba(223, 169, 116, 0.1); background: white;
        }
        .form-control::placeholder { color: #aaa; }
        .form-text {
            color: #888; font-size: 13px; margin-top: 6px; display: flex; align-items: center; gap: 6px;
        }
        .form-text i { color: #dfa974; }
        .alert {
            border-radius: 12px; padding: 16px 20px; margin-bottom: 25px; border: none;
            font-weight: 500; box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            display: flex; align-items: center; gap: 12px;
        }
        .alert i { font-size: 20px; }
        .alert-danger { background: linear-gradient(135deg, #ff7675, #fab1a0); color: #842029; }
        .alert-danger i { color: #d63031; }
        .alert-success { background: linear-gradient(135deg, #d1f2eb, #a8e6cf); color: #0f5132; }
        .alert-success i { color: #00b894; }
        .form-actions {
            margin-top: 35px; padding-top: 25px; border-top: 2px solid #f0f0f0;
            display: flex; gap: 15px; flex-wrap: wrap;
        }
        .primary-btn {
            display: inline-flex; align-items: center; gap: 10px; padding: 14px 32px;
            background: linear-gradient(135deg, #dfa974, #c8965a); color: white;
            text-decoration: none; border-radius: 25px; font-weight: 600;
            transition: all 0.3s ease; font-size: 14px; text-transform: uppercase;
            letter-spacing: 1px; border: none; box-shadow: 0 4px 15px rgba(223, 169, 116, 0.3); cursor: pointer;
        }
        .primary-btn:hover {
            background: linear-gradient(135deg, #c8965a, #b8855a); color: white;
            transform: translateY(-2px); box-shadow: 0 6px 20px rgba(223, 169, 116, 0.4);
        }
        .secondary-btn {
            display: inline-flex; align-items: center; gap: 10px; padding: 14px 32px;
            background: white; color: #6c757d; text-decoration: none; border-radius: 25px;
            font-weight: 600; transition: all 0.3s ease; font-size: 14px;
            text-transform: uppercase; letter-spacing: 1px; border: 2px solid #e5e5e5;
        }
        .secondary-btn:hover {
            background: #6c757d; color: white; border-color: #6c757d;
            transform: translateY(-2px); box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
        .mb-4 { margin-bottom: 25px; }
        textarea.form-control { resize: vertical; min-height: 140px; }
        @media (max-width: 768px) {
            .page-header h1 { font-size: 32px; }
            .form-card { padding: 25px 20px; }
            .form-actions { flex-direction: column; }
            .primary-btn, .secondary-btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp"/>

<section class="page-header">
    <h1><i class="fa fa-edit"></i> New Request</h1>
    <p>Submit a support request to the hotel</p>
</section>

<section class="create-request-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-9">

                <%-- Back Button --%>
                <a href="${pageContext.request.contextPath}/user/requests" class="back-button">
                    <i class="fa fa-arrow-left"></i> Back to My Requests
                </a>

                <%-- Thông báo lỗi --%>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fa fa-exclamation-triangle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <%-- Thông báo thành công --%>
                <c:if test="${not empty sessionScope.flash}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i>
                        <span>${sessionScope.flash}</span>
                    </div>
                    <c:remove var="flash" scope="session"/>
                </c:if>

                <%-- Form Card --%>
                <div class="form-card">
                    <h3 class="form-card-title">
                        <i class="fa fa-file-text"></i>
                        Request Information
                    </h3>
                    <p class="form-card-subtitle">
                        Please fill in full details so we can support you best.
                    </p>

                    <form method="post" action="${pageContext.request.contextPath}/user/requests/create">

                        <%-- Booking ID --%>
                        <div class="mb-4">
                            <label class="form-label">
                                <i class="fa fa-ticket"></i>
                                Booking ID
                                <span class="required">*</span>
                            </label>
                            <input type="text"
                                   class="form-control"
                                   name="bookingId"
                                   value="<c:out value='${param.bookingId != null ? param.bookingId : requestScope.bookingId}'/>"
                                   placeholder="Enter your booking ID (e.g., 8)"
                                   required/>
                            <small class="form-text">
                                <i class="fa fa-info-circle"></i>
                                You can find the Booking ID in your confirmation email or "My Bookings" page.
                            </small>
                        </div>

                        <%-- Request Type --%>
                        <div class="mb-4">
                            <label class="form-label">
                                <i class="fa fa-tag"></i>
                                Request Type
                                <span class="required">*</span>
                            </label>
                            <select class="form-select" name="requestType" required>
                                <option value="">-- Select request type --</option>
                                <option value="Room Service" ${requestScope.requestType == 'Room Service' ? 'selected' : ''}>
                                    🍽️ Room Service
                                </option>
                                <option value="Housekeeping" ${requestScope.requestType == 'Housekeeping' ? 'selected' : ''}>
                                    🧹 Housekeeping
                                </option>
                                <option value="Special Inquiry" ${requestScope.requestType == 'Special Inquiry' ? 'selected' : ''}>
                                    ❓ Special Inquiry
                                </option>
                                <option value="Maintenance" ${requestScope.requestType == 'Maintenance' ? 'selected' : ''}>
                                    🔧 Maintenance
                                </option>
                                <option value="Other" ${requestScope.requestType == 'Other' ? 'selected' : ''}>
                                    📋 Other
                                </option>
                            </select>
                            <small class="form-text">
                                <i class="fa fa-info-circle"></i>
                                Choose the appropriate request type for faster support.
                            </small>
                        </div>

                        <%-- Content --%>
                        <div class="mb-4">
                            <label class="form-label">
                                <i class="fa fa-comment"></i>
                                Request Content
                                <span class="required">*</span>
                            </label>
                            <textarea class="form-control"
                                      name="content"
                                      rows="6"
                                      required
                                      placeholder="Ex: Need 2 extra towels. Late check-in at 22:00 due to flight delay..."><c:out value='${requestScope.content}'/></textarea>
                            <small class="form-text">
                                <i class="fa fa-info-circle"></i>
                                Describe your request in detail.
                            </small>
                        </div>

                        <%-- Action Buttons --%>
                        <div class="form-actions">
                            <button type="submit" class="primary-btn">
                                <i class="fa fa-paper-plane"></i>
                                Submit Request
                            </button>
                            <a href="${pageContext.request.contextPath}/user/requests" class="secondary-btn">
                                <i class="fa fa-times"></i>
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</section>

<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>