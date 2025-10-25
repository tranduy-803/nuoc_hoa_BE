# Database Schema - Dự án Bán Nước Hoa

## Tổng quan

Database được thiết kế cho hệ thống bán nước hoa trực tuyến với đầy đủ các chức năng quản lý sản phẩm, đơn hàng, khách hàng, thanh toán và khuyến mãi.

## Cấu trúc Database

### 1. Quản lý Người dùng

- **roles**: Vai trò người dùng (Admin, Manager, Staff, Customer)
- **users**: Thông tin người dùng hệ thống

### 2. Quản lý Sản phẩm

- **categories**: Danh mục sản phẩm (Nam, Nữ, Unisex, Trẻ em)
- **brands**: Thương hiệu nước hoa (Chanel, Dior, Gucci, Versace, Tom Ford)
- **products**: Thông tin sản phẩm nước hoa
- **inventories**: Quản lý kho hàng

### 3. Quản lý Khách hàng

- **customers**: Thông tin khách hàng
- **addresses**: Địa chỉ giao hàng

### 4. Quản lý Đơn hàng

- **orders**: Thông tin đơn hàng
- **order_details**: Chi tiết sản phẩm trong đơn hàng

### 5. Quản lý Thanh toán

- **payment_methods**: Phương thức thanh toán
- **payments**: Thông tin thanh toán

### 6. Quản lý Khuyến mãi

- **promotions**: Chương trình khuyến mãi
- **coupons**: Mã giảm giá

### 7. Quản lý Đánh giá

- **reviews**: Đánh giá sản phẩm từ khách hàng

## Cài đặt Database

### Yêu cầu

- SQL Server 2019 trở lên
- SQL Server Management Studio (SSMS)

### Các bước thực hiện

1. **Mở SQL Server Management Studio**
2. **Kết nối đến SQL Server**
3. **Chạy script tạo database**:
   ```sql
   -- Mở file create_database.sql và chạy toàn bộ script
   ```

### Cấu hình Application

Cập nhật file `application.properties`:

```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=nuoc_hoa;encrypt=true;trustServerCertificate=true;
spring.datasource.username=sa
spring.datasource.password=12345
spring.datasource.driverClassName=com.microsoft.sqlserver.jdbc.SQLServerDriver
```

## Dữ liệu Mẫu

Database đã bao gồm dữ liệu mẫu:

- 4 vai trò người dùng
- 4 danh mục sản phẩm
- 5 thương hiệu nước hoa
- 4 phương thức thanh toán

## Tính năng Database

### 1. Tối ưu hiệu suất

- **Indexes** trên các trường thường xuyên query
- **Foreign keys** đảm bảo tính toàn vẹn dữ liệu
- **Triggers** tự động cập nhật thời gian

### 2. Bảo mật

- **Unique constraints** cho email, username, phone
- **Check constraints** cho rating (1-5)
- **Default values** cho các trường quan trọng

### 3. Mở rộng

- **Soft delete** với is_active flag
- **Audit trail** với created_at, updated_at
- **Flexible schema** dễ dàng thêm trường mới

## Quan hệ giữa các bảng

```
users (1) -----> (n) orders
users (1) -----> (n) reviews
products (1) -----> (n) order_details
products (1) -----> (n) reviews
products (1) -----> (n) inventories
orders (1) -----> (n) order_details
orders (1) -----> (n) payments
customers (1) -----> (n) addresses
promotions (1) -----> (n) coupons
```

## Lưu ý quan trọng

1. **Backup database** thường xuyên
2. **Monitor performance** với các query phức tạp
3. **Update statistics** định kỳ
4. **Test constraints** trước khi deploy production

## Hỗ trợ

Nếu gặp vấn đề với database, vui lòng:

1. Kiểm tra log SQL Server
2. Verify connection string
3. Check permissions của user database
4. Review foreign key constraints
