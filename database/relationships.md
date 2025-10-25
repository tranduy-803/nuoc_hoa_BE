# Database Relationships - Dự án Bán Nước Hoa

## 🔗 Các Mối Quan Hệ Đã Được Sửa

### 1. **Quản lý Người dùng**

```
roles (1) -----> (n) users
- Một role có thể có nhiều users
- Một user thuộc về một role
```

### 2. **Quản lý Sản phẩm**

```
categories (1) -----> (n) products
brands (1) -----> (n) products
- Một category có thể có nhiều products
- Một brand có thể có nhiều products
- Một product thuộc về một category và một brand
```

### 3. **Quản lý Khách hàng**

```
users (1) -----> (0..1) customers
customers (1) -----> (n) addresses
- Một user có thể có hoặc không có customer record
- Một customer có thể có nhiều addresses
```

### 4. **Quản lý Đơn hàng (ĐÃ SỬA)**

```
users (1) -----> (n) orders (n) <----- (1) customers
order_details (n) -----> (1) orders
order_details (n) -----> (1) products
- Một đơn hàng có thể thuộc về user (có tài khoản) HOẶC customer (không có tài khoản)
- Một đơn hàng có nhiều order_details
- Một order_detail thuộc về một order và một product
```

### 5. **Quản lý Thanh toán**

```
orders (1) -----> (n) payments
payment_methods (1) -----> (n) payments
- Một order có thể có nhiều payments
- Một payment thuộc về một order và một payment_method
```

### 6. **Quản lý Khuyến mãi**

```
promotions (1) -----> (n) coupons
- Một promotion có thể có nhiều coupons
- Một coupon thuộc về một promotion (có thể NULL)
```

### 7. **Quản lý Đánh giá**

```
users (1) -----> (n) reviews
products (1) -----> (n) reviews
- Một user có thể viết nhiều reviews
- Một product có thể có nhiều reviews
- Một review thuộc về một user và một product
```

### 8. **Quản lý Kho**

```
products (1) -----> (n) inventories
- Một product có thể có nhiều inventory records
- Một inventory thuộc về một product
```

## ✅ **Các Cải Tiến Đã Thực Hiện**

### 🔧 **Sửa lỗi Orders Table**

- **Trước**: Chỉ có `user_id` (bắt buộc)
- **Sau**: Có cả `user_id` và `customer_id` (tùy chọn)
- **Constraint**: Mỗi đơn hàng phải có ít nhất một trong hai

### 🔗 **Thêm Foreign Key**

- `customers.user_id` -> `users.id` (optional)
- `orders.customer_id` -> `customers.id` (optional)

### 📊 **Dữ liệu mẫu đã cập nhật**

- Orders 1-3: Thuộc về users (có tài khoản)
- Order 4: Thuộc về customer (không có tài khoản)

## 🎯 **Lợi ích của cấu trúc mới**

### 1. **Linh hoạt**

- Hỗ trợ khách hàng có tài khoản và không có tài khoản
- Có thể theo dõi lịch sử mua hàng của cả hai loại

### 2. **Tính toàn vẹn**

- Constraint đảm bảo mỗi đơn hàng có chủ sở hữu
- Foreign keys đảm bảo tính nhất quán dữ liệu

### 3. **Mở rộng**

- Dễ dàng thêm tính năng mới
- Có thể tích hợp với hệ thống CRM

## 📋 **Checklist Mối Quan Hệ**

- ✅ **One-to-Many**: roles -> users
- ✅ **One-to-Many**: categories -> products
- ✅ **One-to-Many**: brands -> products
- ✅ **One-to-One**: users -> customers (optional)
- ✅ **One-to-Many**: customers -> addresses
- ✅ **One-to-Many**: users -> orders
- ✅ **One-to-Many**: customers -> orders
- ✅ **One-to-Many**: orders -> order_details
- ✅ **One-to-Many**: products -> order_details
- ✅ **One-to-Many**: orders -> payments
- ✅ **One-to-Many**: payment_methods -> payments
- ✅ **One-to-Many**: promotions -> coupons
- ✅ **One-to-Many**: users -> reviews
- ✅ **One-to-Many**: products -> reviews
- ✅ **One-to-Many**: products -> inventories

## 🚀 **Kết luận**

Tất cả các mối quan hệ đã được sửa và hoàn thiện. Database giờ đây có cấu trúc linh hoạt, đảm bảo tính toàn vẹn dữ liệu và hỗ trợ đầy đủ các tính năng của hệ thống bán nước hoa.
