<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - E-Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Login</div>
                    <div class="card-body">
                        <div id="error-message" class="alert alert-danger d-none"></div>
                        <form id="loginForm">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Login</button>
                        </form>
                        <div class="mt-3">
                            <p>Don't have an account? <a href="/register">Register here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const userData = {
                username: document.getElementById('username').value,
                password: document.getElementById('password').value
            };

            fetch('/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            })
            .then(response => response.text())
            .then(data => {
                if (data.startsWith('Invalid')) {
                    document.getElementById('error-message').classList.remove('d-none');
                    document.getElementById('error-message').textContent = data;
                } else {
                    // Store token and redirect
                    localStorage.setItem('jwt', data);
                    window.location.href = '/products';
                }
            })
            .catch(error => {
                document.getElementById('error-message').classList.remove('d-none');
                document.getElementById('error-message').textContent = 'An error occurred. Please try again.';
            });
        });
    </script>
</body>
</html>