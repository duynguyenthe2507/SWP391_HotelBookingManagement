<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .user-details-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 30px;
        }
        .info-label {
            font-weight: bold;
            color: #495057;
            margin-bottom: 5px;
        }
        .info-value {
            color: #212529;
            margin-bottom: 20px;
        }
        .back-button {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="back-button">
            <a href="${pageContext.request.contextPath}/viewuser" class="btn btn-secondary">← Back to User List</a>
        </div>
       
        <div class="user-details-card">
            <h2 class="mb-4">User Details</h2>
           
            <!-- Error/Success Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success" role="alert">
                    ${success}
                </div>
            </c:if>
           
            <c:if test="${not empty user}">
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-label">Full Name</div>
                        <div class="info-value">${user.firstName} ${user.middleName} ${user.lastName}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">Mobile Phone</div>
                        <div class="info-value">${user.mobilePhone}</div>
                    </div>
                </div>
               
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-label">Email</div>
                        <div class="info-value">${user.email}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">Birthday</div>
                        <div class="info-value">${user.birthday != null ? user.birthday : 'N/A'}</div>
                    </div>
                </div>
               
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-label">Role</div>
                        <div class="info-value">
                            <span class="badge bg-primary">${user.role == 'customer' ? 'customer' : user.role}</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">Rank</div>
                        <div class="info-value">${rankName}</div>
                    </div>
                </div>
               
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-label">Status</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${user.active}">
                                    <span class="badge bg-success">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
               
                <hr class="my-4">
               
                <!-- Update Role Form -->
                <h5 class="mb-3">Change Role</h5>
                <form method="post" action="${pageContext.request.contextPath}/admin/user-details" class="mb-4">
                    <input type="hidden" name="userId" value="${user.userId}">
                    <input type="hidden" name="action" value="updateRole">
                    <div class="row">
                        <div class="col-md-6">
                            <select name="role" class="form-select" required>
                                <option value="">Select Role</option>
                                <option value="receptionist" ${user.role == 'receptionist' ? 'selected' : ''}>Receptionist</option>
                                <option value="user" ${user.role == 'customer' || user.role == 'customer' ? 'selected' : ''}>Customer</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-primary">Update Role</button>
                        </div>
                    </div>
                </form>
               
                <!-- Toggle Status Form - Only for Receptionist -->
                <c:if test="${user.role == 'receptionist'}">
                    <h5 class="mb-3">Change Status</h5>
                    <form method="post" action="${pageContext.request.contextPath}/admin/user-details">
                        <input type="hidden" name="userId" value="${user.userId}">
                        <input type="hidden" name="action" value="toggleStatus">
                        <div class="row">
                            <div class="col-md-6">
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <button type="submit" class="btn btn-danger">Deactivate Account</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn btn-success">Activate Account</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </form>
                </c:if>
            </c:if>
           
            <c:if test="${empty user}">
                <div class="alert alert-warning" role="alert">
                    User not found.
                </div>
            </c:if>
        </div>
    </div>
   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>