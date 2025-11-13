<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>36 Hotel - Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css" type="text/css">

    <style>
        .cart-table table { width: 100%; }
        .quantity-spinner { display: flex; align-items: center; justify-content: start; }
        .quantity-spinner input { width: 60px; text-align: center; border: 1px solid #ebebeb; height: 40px; }
        .quantity-spinner .btn-qty { width: 40px; height: 40px; border: 1px solid #ebebeb; background: #f3f3f3; cursor: pointer; }
        .cart-table .product-name a { font-weight: 500; color: #19191a; }
        .cart-table .product-name a:hover { color: #dfa974; }
        .proceed-checkout h4 { font-weight: 700; margin-bottom: 20px; }
        .proceed-checkout ul li { font-size: 16px; font-weight: 500; list-style: none; overflow: hidden; line-height: 2; }
        .proceed-checkout ul li span { float: right; }
        .remove-item { font-size: 24px; color: #19191a; }
        .remove-item:hover { color: red; text-decoration: none; }
    </style>
</head>

<body>
<div id="preloder"><div class="loader"></div></div>

<jsp:include page="/common/header.jsp"/>
<jsp:include page="/common/breadcrumb.jsp"/>

<section class="shopping-cart spad">
    <div class="container">

        <%-- Display Messages --%>
        <c:if test="${not empty sessionScope.cartMessage}">
            <div class="alert ${sessionScope.cartMessageType == 'ERROR' ? 'alert-danger' : (sessionScope.cartMessageType == 'WARNING' ? 'alert-warning' : 'alert-success')}" role="alert">
                <c:out value="${sessionScope.cartMessage}"/>
            </div>
            <% session.removeAttribute("cartMessage"); %>
            <% session.removeAttribute("cartMessageType"); %>
        </c:if>

        <c:if test="${empty cartItems}">
            <div class="text-center">
                <h3>Your cart is empty!</h3>
                <a href="${pageContext.request.contextPath}/rooms" class="primary-btn mt-5">Explore rooms now</a>
            </div>
        </c:if>

        <c:if test="${not empty cartItems}">
            <%-- FIXED: Change to POST and correct action --%>
            <form action="${pageContext.request.contextPath}/cart/checkout" method="POST">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="cart-table">
                            <table>
                                <thead>
                                <tr>
                                    <th><input type="checkbox" id="select-all"></th>
                                    <th>Room</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                    <th style="text-align: center">Remove</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr class="cart-item" data-price="${item.price}">
                                            <%-- IMPORTANT: Use cartId as value --%>
                                        <td><input type="checkbox" class="item-checkbox" name="selectedItems" value="${item.cartId}" checked></td>
                                        <td class="product-name">
                                            <a href="room-details?roomId=${item.roomId}">${item.roomName}</a>
                                        </td>
                                        <td class="price">
                                            <fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND"/>
                                        </td>
                                        <td>
                                            <div class="quantity-spinner">
                                                <button type="button" class="btn-qty btn-dec">-</button>
                                                    <%-- IMPORTANT: Name format matches controller expectation --%>
                                                <input type="number" class="quantity-input" name="quantity_${item.cartId}" value="${item.quantity}" min="1">
                                                <button type="button" class="btn-qty btn-inc">+</button>
                                            </div>
                                        </td>
                                        <td class="total-item-price">
                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" currencyCode="VND"/>
                                        </td>
                                        <td style="text-align: center; vertical-align: middle;">
                                            <a href="cart?action=remove&cartId=${item.cartId}" class="remove-item">×</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="proceed-checkout" style="background: #f3f3f3; padding: 30px;">
                            <h4>CART TOTALS</h4>
                            <ul>
                                <li class="subtotal">Provisional <span>0 VND</span></li>
                                <li class="cart-total">Total <span>0 VND</span></li>
                            </ul>

                            <div class="check-date" style="margin-top: 20px;">
                                <label for="date-in" style="font-weight: 600;">Check In:</label>
                                <input type="text" class="date-input form-control" name="checkInDate" id="date-in" required autocomplete="off">
                                <i class="icon_calendar" style="position: absolute; right: 20px; top: 40px; color: #dfa974;"></i>
                            </div>
                            <div class="check-date" style="margin-top: 15px;">
                                <label for="date-out" style="font-weight: 600;">Check Out:</label>
                                <input type="text" class="date-input form-control" name="checkOutDate" id="date-out" required autocomplete="off">
                                <i class="icon_calendar" style="position: absolute; right: 20px; top: 40px; color: #dfa974;"></i>
                            </div>
                            <button type="submit" class="proceed-btn" style="width: 100%; border: none; padding: 15px;
                            text-transform: uppercase; font-weight: 700; background-color: #dfa974; color: #ffffff; margin-top: 20px;">
                                PROCEED TO CHECKOUT
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </c:if>
    </div>
</section>

<jsp:include page="/common/footer.jsp"/>

<script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const cartTable = document.querySelector('.cart-table');
        if (!cartTable) return;

        const provisionalTotalEl = document.querySelector('.proceed-checkout .subtotal span');
        const finalTotalEl = document.querySelector('.proceed-checkout .cart-total span');
        const selectAllCheckbox = document.getElementById('select-all');

        function formatCurrencyVND(value) {
            return value.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
        }

        function updateTotals() {
            let total = 0;
            cartTable.querySelectorAll('.cart-item').forEach(item => {
                const checkbox = item.querySelector('.item-checkbox');
                if (checkbox.checked) {
                    const price = parseFloat(item.dataset.price);
                    const quantity = parseInt(item.querySelector('.quantity-input').value);
                    const itemTotal = price * quantity;

                    item.querySelector('.total-item-price').textContent = formatCurrencyVND(itemTotal);
                    total += itemTotal;
                }
            });

            provisionalTotalEl.textContent = formatCurrencyVND(total);
            finalTotalEl.textContent = formatCurrencyVND(total);
        }

        function handleQuantityChange(target) {
            const row = target.closest('.cart-item');
            const checkbox = row.querySelector('.item-checkbox');

            if (!checkbox.checked) {
                checkbox.checked = true;
            }

            updateTotals();
        }

        cartTable.addEventListener('click', function(e) {
            const target = e.target;
            let input;

            if (target.classList.contains('btn-dec')) {
                input = target.nextElementSibling;
                let value = parseInt(input.value);
                if (value > 1) {
                    input.value = value - 1;
                    handleQuantityChange(target);
                }
            }

            if (target.classList.contains('btn-inc')) {
                input = target.previousElementSibling;
                input.value = parseInt(input.value) + 1;
                handleQuantityChange(target);
            }

            if (target.classList.contains('item-checkbox')) {
                updateTotals();
            }
        });

        cartTable.addEventListener('input', function(e){
            if(e.target.classList.contains('quantity-input')){
                if(parseInt(e.target.value) < 1 || isNaN(parseInt(e.target.value))){
                    e.target.value = 1;
                }
                handleQuantityChange(e.target);
            }
        });

        selectAllCheckbox.addEventListener('change', function () {
            document.querySelectorAll('.item-checkbox').forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            updateTotals();
        });

        updateTotals();
    });

    $(document).ready(function() {
        $(".date-input").datepicker({
            dateFormat: 'dd/mm/yy',
            minDate: 0,
            onSelect: function(selectedDate) {
                var option = this.id === "date-in" ? "minDate" : "maxDate";
                var date = $(this).datepicker('getDate');
                if (option === "minDate" && date) {
                    date.setDate(date.getDate() + 1);
                    $("#date-out").datepicker("option", "minDate", date);
                }
            }
        });
    });
</script>
</body>
</html>