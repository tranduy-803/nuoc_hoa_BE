# Security Setup Guide

## 📋 Overview

System được cấu hình với Spring Security + JWT authentication với 2 roles:

- **ADMIN**: Full access
- **STAFF**: Limited access

## 🗄️ Database Setup

### 1. Run SQL Script

Execute file `insert_roles_and_users.sql` trong SQL Server:

```sql
-- Insert roles
INSERT INTO roles (role_name, description, is_active)
VALUES ('ADMIN', 'Administrator role with full access', 1);

INSERT INTO roles (role_name, description, is_active)
VALUES ('STAFF', 'Staff role with limited access', 1);
```

### 2. Default Users

**Admin User:**

- Username: `admin`
- Password: `admin123`
- Email: `admin@nuochoa.com`
- Role: ADMIN

**Staff User:**

- Username: `staff`
- Password: `staff123`
- Email: `staff@nuochoa.com`
- Role: STAFF

## 🔐 API Endpoints

### Public Endpoints (No Auth Required)

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login
- `GET /api/upload/**` - File upload

### Admin Only

- `POST /api/product/add`
- `PUT /api/product/update/{id}`
- `DELETE /api/product/remove/{id}`

### Admin + Staff

- `GET /api/product/getAll`
- `GET /api/product/detail/{id}`
- `GET /api/brands`
- `POST /api/brands`
- `PUT /api/brands/{id}`

## 📝 Usage

### 1. Login

```bash
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "admin",
  "email": "admin@nuochoa.com",
  "fullName": "Administrator",
  "role": "ADMIN"
}
```

### 2. Use Token in Requests

```bash
Authorization: Bearer <token>
```

### 3. Register New User

```bash
POST /api/auth/register
Content-Type: application/json

{
  "username": "newuser",
  "email": "newuser@example.com",
  "password": "password123",
  "fullName": "New User",
  "phone": "0123456789",
  "roleName": "STAFF"
}
```

## 🔧 Configuration Files

### SecurityConfig.java

- Cấu hình Spring Security
- JWT authentication filter
- CORS configuration
- Role-based access control

### JwtService.java

- Generate JWT tokens
- Validate tokens
- Extract claims

### CustomUserDetailsService.java

- Load users from database
- Map roles to authorities

## 🛡️ Role Permissions

### ADMIN Role

✅ View all products
✅ Add products
✅ Update products
✅ Delete products
✅ Manage brands
✅ All staff permissions

### STAFF Role

✅ View all products
✅ View product details
❌ Cannot add/update/delete products
✅ View brands
✅ Manage brands

## 🔄 Frontend Integration

### 1. Add Token to LocalStorage

```javascript
localStorage.setItem("token", response.data.token);
localStorage.setItem("user", JSON.stringify(response.data));
```

### 2. Add Authorization Header

```javascript
axios.defaults.headers.common["Authorization"] = `Bearer ${localStorage.getItem(
  "token"
)}`;
```

### 3. Handle Logout

```javascript
localStorage.removeItem("token");
localStorage.removeItem("user");
delete axios.defaults.headers.common["Authorization"];
```

## 🚀 Testing

### Test with Postman/Thunder Client

1. Login to get token
2. Copy token
3. Add to request headers: `Authorization: Bearer <token>`
4. Test endpoints based on role

## ⚠️ Security Notes

- All passwords are hashed with BCrypt
- JWT tokens expire after 24 hours
- Use HTTPS in production
- Change default passwords
- Implement refresh token mechanism for better security
