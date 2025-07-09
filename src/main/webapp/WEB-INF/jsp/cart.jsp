<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - E-Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="/">E-Store</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/products">Products</a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="/cart">
                        Cart <span id="cartCount" class="badge bg-primary">${cartCount}</span>
                    </a>
                </li>

                <c:if test="${not empty user and user.role eq 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="/admin">Admin</a>
                    </li>
                </c:if>

                <c:if test="${empty user}">
                    <li class="nav-item">
                        <a class="nav-link" href="/login">Login</a>
                    </li>
                </c:if>
                <c:if test="${not empty user}">
                    <li class="nav-item">
                        <a class="nav-link" href="/logout">Logout</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h2>Your Shopping Cart</h2>

    <c:choose>
        <c:when test="${empty cart.items}">
            <p>Your cart is empty. <a href="/products">Continue shopping</a></p>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="subtotal" value="0"/>
                    <c:forEach var="item" items="${cart.items}">
                        <c:set var="itemTotal" value="${item.product.price * item.quantity}"/>
                        <c:set var="subtotal" value="${subtotal + itemTotal}"/>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="${item.product.imageUrl}" alt="${item.product.name}" style="width: 50px; margin-right: 10px;">
                                        ${item.product.name}
                                </div>
                            </td>
                            <td>$${item.product.price}</td>
                            <td>${item.quantity}</td>
                            <td>$${itemTotal}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:set var="tax" value="${subtotal * 0.1}" />
            <c:set var="total" value="${subtotal + tax}" />

            <div class="row mt-4" id="checkoutSection">
                <div class="col-md-4 ms-auto">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Order Summary</h5>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span>$${subtotal}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <span>Tax (10%):</span>
                                <span>$${tax}</span>
                            </div>
                            <div class="d-flex justify-content-between fw-bold">
                                <span>Total:</span>
                                <span>$${total}</span>
                            </div>
                            <form method="post" action="/checkout">
                                <button class="btn btn-success w-100 mt-3" type="submit">Proceed to Checkout</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
