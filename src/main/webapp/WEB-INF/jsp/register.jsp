<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - E-Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Register</div>
                    <div class="card-body">
                        <div id="message" class="alert d-none"></div>
                        <form id="registerForm">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="name" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Register</button>
                        </form>
                        <div class="mt-3">
                            <p>Already have an account? <a href="/login">Login here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();

            const userData = {
                username: document.getElementById('username').value,
                password: document.getElementById('password').value,
                email: document.getElementById('email').value,
                name: document.getElementById('name').value
            };

            fetch('/api/auth/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(userData)
            })
            .then(response => response.text())
            .then(data => {
                const messageDiv = document.getElementById('message');
                messageDiv.classList.remove('d-none', 'alert-danger', 'alert-success');

                if (data === 'User registered successfully') {
                    messageDiv.classList.add('alert-success');
                    messageDiv.textContent = data + '. Redirecting to login...';
                    setTimeout(() => window.location.href = '/login', 2000);
                } else {
                    messageDiv.classList.add('alert-danger');
                    messageDiv.textContent = data;
                }
            })
            .catch(error => {
                const messageDiv = document.getElementById('message');
                messageDiv.classList.remove('d-none');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'An error occurred. Please try again.';
            });
        });
    </script>
</body>
</html>