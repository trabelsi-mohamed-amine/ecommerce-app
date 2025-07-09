<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.app.app.entity.Product" %>
<%@ page import="com.app.app.entity.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - E-Store</title>
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
                    <a class="nav-link active" href="/products">Products</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <!-- User Info (client-side only) -->
                <li class="nav-item" id="userDisplay"></li>
                <!-- Cart -->
                <li class="nav-item">
                    <a class="nav-link" href="/cart">
                        Cart <span id="cartCount" class="badge bg-primary">0</span>
                    </a>
                </li>
                <!-- Admin Link (client-side only) -->
                <li class="nav-item" id="adminLink" style="display: none;">
                    <a class="nav-link" href="/admin">Admin</a>
                </li>
                <!-- Login / Logout (client-side only) -->
                <li class="nav-item" id="loginLogoutItem">
                    <a class="nav-link" href="/login">Login</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h1 class="mb-4">Welcome to E-Store</h1>
    <h2>Products</h2>
    <div class="row" id="productsContainer">
        <c:if test="${empty products}">
            <div class="col-12"><p>No products available.</p></div>
        </c:if>
        <c:forEach var="product" items="${products}">
            <div class="col-md-4 mb-4">
                <div class="card">
                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://placeholder.pics/svg/300x200'}"
                         class="card-img-top" alt="${product.name}">
                    <div class="card-body">
                        <h5 class="card-title">${product.name}</h5>
                        <p class="card-text">${product.description}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="h5">$${product.price}</span>
                            <button type="button" class="btn btn-primary add-to-cart-btn"
                                    data-product-id="${product.id}">Add to Cart</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function updateNavbarFromJWT() {
        const token = localStorage.getItem('jwt');
        const userDisplay = document.getElementById('userDisplay');
        const adminLink = document.getElementById('adminLink');
        const loginLogoutItem = document.getElementById('loginLogoutItem');
        if (!token) {
            userDisplay.innerHTML = '';
            adminLink.style.display = 'none';
            loginLogoutItem.innerHTML = '<a class="nav-link" href="/login">Login</a>';
            return;
        }
        try {
            const payload = JSON.parse(atob(token.split('.')[1]));
            const username = payload.sub;
            const roles = payload.roles || [];
            userDisplay.innerHTML = `<span class="nav-link text-light">Logged in as: <strong>${username}</strong></span>`;
            if (roles.includes('ADMIN')) {
                adminLink.style.display = 'block';
            } else {
                adminLink.style.display = 'none';
            }
            loginLogoutItem.innerHTML = '<a class="nav-link" href="#" onclick="logout()">Logout</a>';
        } catch (e) {
            userDisplay.innerHTML = '';
            adminLink.style.display = 'none';
            loginLogoutItem.innerHTML = '<a class="nav-link" href="/login">Login</a>';
        }
    }

    function updateCartCount() {
        const token = localStorage.getItem('jwt');
        if (!token) {
            document.getElementById('cartCount').textContent = '0';
            return;
        }
        fetch('/api/cart/count', {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        })
            .then(response => response.json())
            .then(data => {
                document.getElementById('cartCount').textContent = data.count;
            })
            .catch(() => {
                document.getElementById('cartCount').textContent = '0';
            });
    }

    function logout() {
        localStorage.removeItem('jwt');
        window.location.href = '/login';
    }

    document.addEventListener('DOMContentLoaded', function () {
        updateNavbarFromJWT();
        updateCartCount();

        document.querySelectorAll('.add-to-cart-btn').forEach(button => {
            button.addEventListener('click', function () {
                const productId = this.getAttribute('data-product-id');
                const quantity = 1;
                const token = localStorage.getItem('jwt');
                if (!token) {
                    window.location.href = '/login';
                    return;
                }
                fetch(`/api/cart/add?productId=${productId}&quantity=${quantity}`, {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                })
                    .then(response => {
                        if (response.ok) {
                            alert('Product added to cart!');
                            updateCartCount();
                        } else if (response.status === 401) {
                            alert('Session expired. Please log in again.');
                            logout();
                        } else {
                            alert('Failed to add product to cart.');
                        }
                    })
                    .catch(() => {
                        alert('An error occurred. Please try again.');
                    });
            });
        });
    });
</script>

</body>
</html>
