<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - E-Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/">E-Store Admin</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/products">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="/admin">Admin</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="#" id="logoutLink">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Product Management</h2>
            <button class="btn btn-primary" onclick="openProductModal()">Add New Product</button>
        </div>

        <div class="table-responsive">
            <table class="table table-striped" id="productsTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Products will be loaded here -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- Product Modal -->
    <div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalLabel">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="productForm">
                        <input type="hidden" id="productId">
                        <div class="mb-3">
                            <label for="name" class="form-label">Product Name</label>
                            <input type="text" class="form-control" id="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="price" class="form-label">Price ($)</label>
                            <input type="number" class="form-control" id="price" min="0.01" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="stock" class="form-label">Stock Quantity</label>
                            <input type="number" class="form-control" id="stock" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="imageUrl" class="form-label">Image URL</label>
                            <input type="url" class="form-control" id="imageUrl">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="saveProductBtn">Save Product</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this product? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Check if user is logged in and is admin
        const token = localStorage.getItem('jwt');
        if (!token) {
            window.location.href = '/login?redirect=admin';
            }

                    // Verify user is admin by parsing the JWT
                    try {
                        const payload = JSON.parse(atob(token.split('.')[1]));
                        if (!payload.roles || !payload.roles.includes('ADMIN')) {
                            alert('You do not have permission to access this page');
                            window.location.href = '/';
                        }
                    } catch (e) {
                        console.error('Error parsing JWT token', e);
                        window.location.href = '/login?redirect=admin';
                    }

                    // Bootstrap Modal instances
                    const productModal = new bootstrap.Modal(document.getElementById('productModal'));
                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));

                    let currentProductId = null;

                    // Load all products
                    function loadProducts() {
                        fetch('/api/admin/products', {
                            headers: {
                                'Authorization': `Bearer ${token}`
                            }
                        })
                        .then(response => {
                            if (!response.ok) throw new Error('Failed to fetch products');
                            return response.json();
                        })
                        .then(products => {
                            const tableBody = document.querySelector('#productsTable tbody');
                            tableBody.innerHTML = '';

                            products.forEach(product => {
                                const row = document.createElement('tr');
                                row.innerHTML = `
                                    <td>${product.id}</td>
                                    <td><img src="${product.imageUrl || 'https://placeholder.pics/svg/50x50'}"
                                         alt="${product.name}" style="width: 50px; height: 50px;"></td>
                                    <td>${product.name}</td>
                                    <td>${product.description.substring(0, 50)}${product.description.length > 50 ? '...' : ''}</td>
                                    <td>$${product.price.toFixed(2)}</td>
                                    <td>${product.stock}</td>
                                    <td>
                                        <button class="btn btn-sm btn-primary me-1" onclick="editProduct(${product.id})">Edit</button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteProduct(${product.id})">Delete</button>
                                    </td>
                                `;
                                tableBody.appendChild(row);
                            });
                        })
                        .catch(error => {
                            console.error('Error loading products:', error);
                            alert('Failed to load products');
                        });
                    }

                    // Open modal for adding a new product
                    function openProductModal() {
                        document.getElementById('productModalLabel').textContent = 'Add New Product';
                        document.getElementById('productForm').reset();
                        document.getElementById('productId').value = '';
                        currentProductId = null;
                        productModal.show();
                    }

                    // Edit existing product
                    function editProduct(id) {
                        currentProductId = id;
                        fetch(`/api/admin/products/${id}`, {
                            headers: { 'Authorization': `Bearer ${token}` }
                        })
                        .then(response => response.json())
                        .then(product => {
                            document.getElementById('productModalLabel').textContent = 'Edit Product';
                            document.getElementById('productId').value = product.id;
                            document.getElementById('name').value = product.name;
                            document.getElementById('description').value = product.description;
                            document.getElementById('price').value = product.price;
                            document.getElementById('stock').value = product.stock;
                            document.getElementById('imageUrl').value = product.imageUrl || '';
                            productModal.show();
                        })
                        .catch(error => alert('Failed to load product details'));
                    }

                    // Delete product
                    function deleteProduct(id) {
                        currentProductId = id;
                        deleteModal.show();
                    }

                    // Save product (create or update)
                    document.getElementById('saveProductBtn').addEventListener('click', function() {
                        const productForm = document.getElementById('productForm');
                        if (!productForm.checkValidity()) {
                            productForm.reportValidity();
                            return;
                        }

                        const productData = {
                            name: document.getElementById('name').value,
                            description: document.getElementById('description').value,
                            price: parseFloat(document.getElementById('price').value),
                            stock: parseInt(document.getElementById('stock').value),
                            imageUrl: document.getElementById('imageUrl').value || null
                        };

                        const url = currentProductId ? `/api/admin/products/${currentProductId}` : '/api/admin/products';
                        const method = currentProductId ? 'PUT' : 'POST';

                        fetch(url, {
                            method: method,
                            headers: {
                                'Authorization': `Bearer ${token}`,
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(productData)
                        })
                        .then(response => {
                            if (!response.ok) throw new Error('Failed to save product');
                            productModal.hide();
                            loadProducts();
                        })
                        .catch(error => alert('Failed to save product'));
                    });

                    // Confirm delete
                    document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
                        fetch(`/api/admin/products/${currentProductId}`, {
                            method: 'DELETE',
                            headers: { 'Authorization': `Bearer ${token}` }
                        })
                        .then(response => {
                            if (!response.ok) throw new Error('Failed to delete');
                            deleteModal.hide();
                            loadProducts();
                        })
                        .catch(error => alert('Failed to delete product'));
                    });

                    // Logout functionality
                    document.getElementById('logoutLink').addEventListener('click', function(e) {
                        e.preventDefault();
                        localStorage.removeItem('jwt');
                        window.location.href = '/login';
                    });

                    // Load products when page loads
                    document.addEventListener('DOMContentLoaded', loadProducts);
                </script>
            </body>
            </html>