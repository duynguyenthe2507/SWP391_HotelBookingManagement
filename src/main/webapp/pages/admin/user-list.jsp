<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User List</title>
        <!-- Bootstrap CSS for styling -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS for additional styling -->
        <style>
            body {
                background-color: #f8f9fa;
            }
            .table th {
                background-color: #e9ecef;
            }
            .pagination .page-item.active .page-link {
                background-color: #0d6efd;
                border-color: #0d6efd;
            }
            .search-bar {
                border-radius: 5px;
            }
            .sidebar ul {
                margin-left: 80px;
            }
            .apply-button {
                margin-top: 30px;
            }
            .search-bar {
                margin-top: 30px;
            }
            /* Make the View column narrower */
        </style>
    </head>
    <body>
        <!-- Sidebar Menu and Table -->
        <div class="row">
            <!-- Sidebar begin (giống dashboard) -->
            <nav class="sidebar d-flex flex-column col-lg-2 col-md-3 col-3 p-0 min-vh-100" style="background-color: #0056b3;">                <div class="sidebar-sticky flex-grow-1 d-flex flex-column">
                    <div class="text-center mt-4 mb-4">
                        <div style="font-family: 'Lora', serif; font-style:italic; font-weight:bold; font-size:2em; color:#dfa974; letter-spacing:1px;">36</div>
                        <h5 class="font-weight-bold" style="color: #dfa974;">Admin</h5>
                    </div>
                    <ul class="nav flex-column flex-grow-1">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/viewuser" class="nav-link text-white"><i class="fa fa-sign-out mr-2"></i> User List</a></li>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/admin/black-list.jsp" class="nav-link text-white"><i class="fa fa-sign-out mr-2"></i> Black-List</a></li>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/login" class="nav-link text-white"><i class="fa fa-sign-out mr-2"></i> Logout</a></li>
                    </ul>
                    <div class="mt-auto mb-3"></div>
                </div>
            </nav>
            <!-- Sidebar end -->
            <div class="col-10">
                <!-- Filters Dropdowns -->
                <form method="get" action="${pageContext.request.contextPath}/viewuser" class="row mb-3">
                    <!-- Single dropdown for ID sort (Asc/Desc) -->
                    <div class="col-auto">
                        <label class="form-label d-block">ID: </label>
                        <select name="sort" class="form-select">
                            <option value="id_asc" ${currentOrder == 'asc' || empty currentOrder ? 'selected' : ''}>Low → High</option>
                            <option value="id_desc" ${currentOrder == 'desc' ? 'selected' : ''}>High → Low</option>
                        </select>
                    </div>
                    <!-- Role Filter (only user and receptionist) -->
                    <div class="col-auto">
                        <label class="form-label d-block">Role: </label>
                        <select name="role" class="form-select">
                            <option value="" ${empty currentRole ? 'selected' : ''}>All</option>
                            <c:forEach var="role" items="${distinctRoles}">
                                <option value="${role}" ${currentRole == role ? 'selected' : ''}>${role}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Status Filter -->
                    <div class="col-auto">
                        <label class="form-label d-block">Status: </label>
                        <select name="status" class="form-select">
                            <option value="" ${empty currentStatus ? 'selected' : ''}>All</option>
                            <c:forEach var="status" items="${distinctStatuses}">
                                <option value="${status}" ${currentStatus == status ? 'selected' : ''}>${status}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- First Name Initial (A–Z) -->
                    <div class="col-auto">
                        <label class="form-label d-block">First Name: </label>
                        <select name="firstName" class="form-select">
                            <option value="" ${empty currentFirstName ? 'selected' : ''}>All</option>
                            <option value="A" ${currentFirstName == 'A' ? 'selected' : ''}>A</option>
                            <option value="B" ${currentFirstName == 'B' ? 'selected' : ''}>B</option>
                            <option value="C" ${currentFirstName == 'C' ? 'selected' : ''}>C</option>
                            <option value="D" ${currentFirstName == 'D' ? 'selected' : ''}>D</option>
                            <option value="E" ${currentFirstName == 'E' ? 'selected' : ''}>E</option>
                            <option value="F" ${currentFirstName == 'F' ? 'selected' : ''}>F</option>
                            <option value="G" ${currentFirstName == 'G' ? 'selected' : ''}>G</option>
                            <option value="H" ${currentFirstName == 'H' ? 'selected' : ''}>H</option>
                            <option value="I" ${currentFirstName == 'I' ? 'selected' : ''}>I</option>
                            <option value="J" ${currentFirstName == 'J' ? 'selected' : ''}>J</option>
                            <option value="K" ${currentFirstName == 'K' ? 'selected' : ''}>K</option>
                            <option value="L" ${currentFirstName == 'L' ? 'selected' : ''}>L</option>
                            <option value="M" ${currentFirstName == 'M' ? 'selected' : ''}>M</option>
                            <option value="N" ${currentFirstName == 'N' ? 'selected' : ''}>N</option>
                            <option value="O" ${currentFirstName == 'O' ? 'selected' : ''}>O</option>
                            <option value="P" ${currentFirstName == 'P' ? 'selected' : ''}>P</option>
                            <option value="Q" ${currentFirstName == 'Q' ? 'selected' : ''}>Q</option>
                            <option value="R" ${currentFirstName == 'R' ? 'selected' : ''}>R</option>
                            <option value="S" ${currentFirstName == 'S' ? 'selected' : ''}>S</option>
                            <option value="T" ${currentFirstName == 'T' ? 'selected' : ''}>T</option>
                            <option value="U" ${currentFirstName == 'U' ? 'selected' : ''}>U</option>
                            <option value="V" ${currentFirstName == 'V' ? 'selected' : ''}>V</option>
                            <option value="W" ${currentFirstName == 'W' ? 'selected' : ''}>W</option>
                            <option value="X" ${currentFirstName == 'X' ? 'selected' : ''}>X</option>
                            <option value="Y" ${currentFirstName == 'Y' ? 'selected' : ''}>Y</option>
                            <option value="Z" ${currentFirstName == 'Z' ? 'selected' : ''}>Z</option>
                        </select>
                    </div>
                    <!-- Last Name Initial (A–Z) -->
                    <div class="col-auto">
                        <label class="form-label d-block">Last Name: </label>
                        <select name="lastName" class="form-select">
                            <option value="" ${empty currentLastName ? 'selected' : ''}>All</option>
                            <option value="A" ${currentLastName == 'A' ? 'selected' : ''}>A</option>
                            <option value="B" ${currentLastName == 'B' ? 'selected' : ''}>B</option>
                            <option value="C" ${currentLastName == 'C' ? 'selected' : ''}>C</option>
                            <option value="D" ${currentLastName == 'D' ? 'selected' : ''}>D</option>
                            <option value="E" ${currentLastName == 'E' ? 'selected' : ''}>E</option>
                            <option value="F" ${currentLastName == 'F' ? 'selected' : ''}>F</option>
                            <option value="G" ${currentLastName == 'G' ? 'selected' : ''}>G</option>
                            <option value="H" ${currentLastName == 'H' ? 'selected' : ''}>H</option>
                            <option value="I" ${currentLastName == 'I' ? 'selected' : ''}>I</option>
                            <option value="J" ${currentLastName == 'J' ? 'selected' : ''}>J</option>
                            <option value="K" ${currentLastName == 'K' ? 'selected' : ''}>K</option>
                            <option value="L" ${currentLastName == 'L' ? 'selected' : ''}>L</option>
                            <option value="M" ${currentLastName == 'M' ? 'selected' : ''}>M</option>
                            <option value="N" ${currentLastName == 'N' ? 'selected' : ''}>N</option>
                            <option value="O" ${currentLastName == 'O' ? 'selected' : ''}>O</option>
                            <option value="P" ${currentLastName == 'P' ? 'selected' : ''}>P</option>
                            <option value="Q" ${currentLastName == 'Q' ? 'selected' : ''}>Q</option>
                            <option value="R" ${currentLastName == 'R' ? 'selected' : ''}>R</option>
                            <option value="S" ${currentLastName == 'S' ? 'selected' : ''}>S</option>
                            <option value="T" ${currentLastName == 'T' ? 'selected' : ''}>T</option>
                            <option value="U" ${currentLastName == 'U' ? 'selected' : ''}>U</option>
                            <option value="V" ${currentLastName == 'V' ? 'selected' : ''}>V</option>
                            <option value="W" ${currentLastName == 'W' ? 'selected' : ''}>W</option>
                            <option value="X" ${currentLastName == 'X' ? 'selected' : ''}>X</option>
                            <option value="Y" ${currentLastName == 'Y' ? 'selected' : ''}>Y</option>
                            <option value="Z" ${currentLastName == 'Z' ? 'selected' : ''}>Z</option>
                        </select>
                    </div>
                    <div class="col-auto apply-button">
                        <button type="submit" class="btn btn-primary">Apply</button>
                    </div>
                    <!-- search bar -->
                    <div class="col-auto">
                        <input type="text" name="search" class="form-control search-bar" 
                               placeholder="Search by name..." 
                               value="${currentSearch}"
                               onkeyup="this.form.submit()">
                    </div>
                </form>

                <table class="table table-bordered table-sm">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Fullname</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>View</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">

                            <tr>
                                <td>${user.userId}</td>
                                <td>${user.firstName} ${user.middleName} ${user.lastName}</td>
                                <td>${user.role}</td>
                                <td>${user.active ? 'active' : 'inactive'}</td>
                                <td class="view-col"><a href="${pageContext.request.contextPath}/admin/user-details?id=${user.userId}" class="btn btn-secondary btn-sm px-2 py-0">View</a></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="5" class="text-center">No users found</td>
                            </tr>
                        </c:if>
                        <!-- Add more rows as needed -->
                    </tbody>
                </table>

                <!-- Pagination -->
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item"><a class="page-link" href="#"><</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">4</a></li>
                        <li class="page-item"><a class="page-link" href="#">5</a></li>
                        <li class="page-item"><a class="page-link" href="#">6</a></li>
                        <li class="page-item"><a class="page-link" href="#">7</a></li>
                        <li class="page-item"><a class="page-link" href="#">8</a></li>
                        <li class="page-item"><a class="page-link" href="#">9</a></li>
                        <li class="page-item"><a class="page-link" href="#">></a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>