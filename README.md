# Spring Boot E-commerce Application

A full-featured e-commerce web application built with Spring Boot, featuring user authentication, product management, shopping cart functionality, and administrative controls.

## 🚀 Features

- **User Authentication & Authorization**
  - JWT-based authentication
  - User registration and login
  - Role-based access control (Admin/User)
  - Secure password handling

- **Product Management**
  - Browse products catalog
  - Product search and filtering
  - Admin product CRUD operations
  - Product inventory management

- **Shopping Cart**
  - Add/remove items from cart
  - Update item quantities
  - Persistent cart for logged-in users
  - Cart total calculation

- **Admin Panel**
  - User management
  - Product management
  - Order monitoring
  - Administrative dashboard

## 🛠️ Technology Stack

- **Backend**: Spring Boot 3.4.4
- **Language**: Java 17
- **Framework**: Spring MVC
- **Security**: Spring Security with JWT
- **Database**: MySQL 8.0+
- **ORM**: Spring Data JPA / Hibernate
- **View Layer**: JSP (JavaServer Pages)
- **Build Tool**: Maven
- **Authentication**: JSON Web Tokens (JWT)

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

- **Java 17** or higher
- **Maven 3.6+**
- **MySQL 8.0+**
- **Git**

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/spring-boot-ecommerce-app.git
cd spring-boot-ecommerce-app
```

### 2. Database Setup

1. Install and start MySQL server
2. Create a database named `estore` (or the application will create it automatically)
3. Update database credentials in `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/estore?createDatabaseIfNotExist=true
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password
```

### 3. Configure Application Properties

Update the following properties in `src/main/resources/application.properties`:

```properties
# Database Configuration
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password

# JWT Configuration (Generate a new secret for production)
jwt.secret=your_jwt_secret_key
jwt.expiration=86400000
```

### 4. Build and Run

```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

Alternatively, you can run the generated JAR file:

```bash
java -jar target/app-0.0.1-SNAPSHOT.jar
```

### 5. Access the Application

- **Application URL**: http://localhost:9999
- **Login Page**: http://localhost:9999/login
- **Registration**: http://localhost:9999/register
- **Products**: http://localhost:9999/products
- **Admin Panel**: http://localhost:9999/admin (Admin role required)

## 📁 Project Structure

```
src/
├── main/
│   ├── java/com/app/app/
│   │   ├── config/           # Security and JWT configuration
│   │   ├── controllers/      # REST controllers
│   │   ├── dto/             # Data Transfer Objects
│   │   ├── entity/          # JPA entities
│   │   ├── repository/      # Data repositories
│   │   ├── services/        # Business logic services
│   │   └── AppApplication.java
│   ├── resources/
│   │   ├── application.properties
│   │   └── templates/
│   └── webapp/WEB-INF/jsp/  # JSP view templates
└── test/                    # Test classes
```

## 🔐 Default Users

The application may include default users for testing:

- **Admin User**: 
  - Username: `admin`
  - Password: `admin123`
  - Role: ADMIN

- **Regular User**:
  - Username: `user`
  - Password: `user123`
  - Role: USER

*Note: Change these credentials in production!*

## 🛡️ Security Features

- **JWT Authentication**: Stateless authentication using JSON Web Tokens
- **Password Encryption**: BCrypt password hashing
- **CORS Configuration**: Cross-origin resource sharing setup
- **Role-based Authorization**: Different access levels for users and admins
- **SQL Injection Protection**: JPA/Hibernate parameterized queries

## 🧪 Testing

Run the test suite:

```bash
mvn test
```

## 📝 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout

### Products
- `GET /api/products` - Get all products
- `GET /api/products/{id}` - Get product by ID
- `POST /api/products` - Create new product (Admin only)
- `PUT /api/products/{id}` - Update product (Admin only)
- `DELETE /api/products/{id}` - Delete product (Admin only)

### Cart
- `GET /api/cart` - Get user's cart
- `POST /api/cart/add` - Add item to cart
- `PUT /api/cart/update` - Update cart item
- `DELETE /api/cart/remove/{id}` - Remove item from cart

## 🔧 Configuration

### JWT Configuration
- Secret key is configurable in `application.properties`
- Token expiration time is set to 24 hours (86400000 ms)
- Tokens are included in Authorization header as Bearer tokens

### Database Configuration
- Uses MySQL with automatic schema creation/updates
- Connection pooling enabled by default
- SQL logging can be enabled for debugging

## 🚀 Deployment

### Production Considerations

1. **Environment Variables**: Use environment variables for sensitive configuration
2. **Database**: Use a production-grade database setup
3. **Security**: Generate strong JWT secrets
4. **Logging**: Configure appropriate logging levels
5. **SSL/TLS**: Enable HTTPS in production

### Docker Deployment

Create a `Dockerfile`:

```dockerfile
FROM openjdk:17-jdk-slim
COPY target/app-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 9999
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Build and run:

```bash
docker build -t spring-ecommerce .
docker run -p 9999:9999 spring-ecommerce
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you have any questions or need help, please:

1. Check the existing issues on GitHub
2. Create a new issue with detailed information
3. Provide logs and error messages when reporting bugs

## 🔗 Links

- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Security Documentation](https://docs.spring.io/spring-security/site/docs/current/reference/html5/)
- [JWT.io](https://jwt.io/) - JWT debugger and information

---

**Happy Coding! 🎉**
