-- Tạo database cho dự án bán nước hoa
USE master;
GO

    CREATE DATABASE nuocHoaChanel;

GO

USE nuocHoaChanel;
GO

-- Tạo bảng roles
CREATE TABLE roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255),
    is_active BIT DEFAULT 1
);

-- Tạo bảng users
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    phone NVARCHAR(20),
    avatar NVARCHAR(255),
    is_active BIT DEFAULT 1,
    is_verified BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    last_login DATETIME2,
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- Tạo bảng categories
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    image_url NVARCHAR(255),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    parent_id INT, -- Để tạo danh mục con
    FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- Tạo bảng brands
CREATE TABLE brands (
    id INT IDENTITY(1,1) PRIMARY KEY,
    brand_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    logo_url NVARCHAR(255),
    website NVARCHAR(255),
    country NVARCHAR(100),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2
);

-- Tạo bảng products
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    product_code NVARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(20,2) NOT NULL,
    discount_price DECIMAL(20,2),
    description NVARCHAR(1000),
    product_img NVARCHAR(255),
    quantity INT NOT NULL DEFAULT 0,
    weight DECIMAL(10,2),
    volume NVARCHAR(50),
    concentration NVARCHAR(50),
    gender NVARCHAR(20),
    is_active BIT DEFAULT 1,
    is_featured BIT DEFAULT 0,
    view_count INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Tạo bảng customers (khách hàng không có tài khoản)
CREATE TABLE customers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    phone NVARCHAR(20) NOT NULL UNIQUE,
    address NVARCHAR(500),
    date_of_birth DATETIME2,
    gender NVARCHAR(10),
    is_vip BIT DEFAULT 0,
    total_orders INT DEFAULT 0,
    total_spent DECIMAL(20,2) DEFAULT 0,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    user_id INT, -- Liên kết với users nếu khách hàng có tài khoản
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tạo bảng addresses
CREATE TABLE addresses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    address_line NVARCHAR(500) NOT NULL,
    ward NVARCHAR(100),
    district NVARCHAR(100),
    city NVARCHAR(100),
    postal_code NVARCHAR(20),
    is_default BIT DEFAULT 0,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Tạo bảng orders
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_number NVARCHAR(50) NOT NULL UNIQUE,
    user_id INT, -- Có thể NULL nếu khách hàng không có tài khoản
    customer_id INT, -- Khách hàng không có tài khoản
    total_amount DECIMAL(20,2) NOT NULL,
    discount_amount DECIMAL(20,2) DEFAULT 0,
    shipping_fee DECIMAL(20,2) DEFAULT 0,
    final_amount DECIMAL(20,2) NOT NULL,
    status NVARCHAR(50) DEFAULT 'PENDING',
    shipping_address NVARCHAR(500) NOT NULL,
    shipping_phone NVARCHAR(20),
    notes NVARCHAR(1000),
    shipped_at DATETIME2,
    delivered_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    -- Constraint: Mỗi đơn hàng phải có ít nhất user_id hoặc customer_id
    CONSTRAINT CK_orders_user_or_customer CHECK (
        (user_id IS NOT NULL AND customer_id IS NULL) OR 
        (user_id IS NULL AND customer_id IS NOT NULL)
    )
);

-- Tạo bảng order_details
CREATE TABLE order_details (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(20,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0,
    total_price DECIMAL(20,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Tạo bảng inventories
CREATE TABLE inventories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    quantity_in INT DEFAULT 0,
    quantity_out INT DEFAULT 0,
    current_stock INT DEFAULT 0,
    min_stock_level INT DEFAULT 10,
    max_stock_level INT,
    location NVARCHAR(100),
    notes NVARCHAR(500),
    last_updated DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Tạo bảng payment_methods
CREATE TABLE payment_methods (
    id INT IDENTITY(1,1) PRIMARY KEY,
    method_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    is_active BIT DEFAULT 1,
    processing_fee_percent DECIMAL(5,2)
);

-- Tạo bảng payments
CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    payment_number NVARCHAR(50) NOT NULL UNIQUE,
    amount DECIMAL(20,2) NOT NULL,
    payment_method_id INT NOT NULL,
    status NVARCHAR(50) DEFAULT 'PENDING',
    transaction_id NVARCHAR(100),
    gateway_response NVARCHAR(1000),
    paid_at DATETIME2,
    refunded_at DATETIME2,
    notes NVARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- Tạo bảng promotions
CREATE TABLE promotions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    promotion_name NVARCHAR(200) NOT NULL,
    description NVARCHAR(1000),
    promotion_type NVARCHAR(50) NOT NULL,
    discount_value DECIMAL(10,2),
    min_order_amount DECIMAL(20,2),
    max_discount_amount DECIMAL(20,2),
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date DATETIME2 NOT NULL,
    end_date DATETIME2 NOT NULL,
    is_active BIT DEFAULT 1,
    is_featured BIT DEFAULT 0,
    image_url NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    category_id INT, -- Áp dụng cho danh mục cụ thể
    brand_id INT, -- Áp dụng cho thương hiệu cụ thể
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Tạo bảng coupons
CREATE TABLE coupons (
    id INT IDENTITY(1,1) PRIMARY KEY,
    promotion_id INT,
    coupon_code NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(500),
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date DATETIME2,
    end_date DATETIME2,
    is_active BIT DEFAULT 1,
    is_single_use BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (promotion_id) REFERENCES promotions(id)
);

-- Tạo bảng reviews
CREATE TABLE reviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title NVARCHAR(200),
    content NVARCHAR(2000),
    is_verified_purchase BIT DEFAULT 0,
    is_approved BIT DEFAULT 0,
    helpful_count INT DEFAULT 0,
    images NVARCHAR(1000),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Tạo bảng promotion_usage để theo dõi việc sử dụng khuyến mãi
CREATE TABLE promotion_usage (
    id INT IDENTITY(1,1) PRIMARY KEY,
    promotion_id INT NOT NULL,
    customer_id INT,
    user_id INT,
    order_id INT NOT NULL,
    discount_amount DECIMAL(20,2) NOT NULL,
    used_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (promotion_id) REFERENCES promotions(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Tạo indexes để tối ưu hiệu suất
CREATE INDEX IX_products_category_id ON products(category_id);
CREATE INDEX IX_products_brand_id ON products(brand_id);
CREATE INDEX IX_products_is_active ON products(is_active);
CREATE INDEX IX_products_is_featured ON products(is_featured);
CREATE INDEX IX_orders_user_id ON orders(user_id);
CREATE INDEX IX_orders_status ON orders(status);
CREATE INDEX IX_orders_created_at ON orders(created_at);
CREATE INDEX IX_order_details_order_id ON order_details(order_id);
CREATE INDEX IX_order_details_product_id ON order_details(product_id);
CREATE INDEX IX_reviews_product_id ON reviews(product_id);
CREATE INDEX IX_reviews_user_id ON reviews(user_id);
CREATE INDEX IX_reviews_rating ON reviews(rating);

-- Insert dữ liệu mẫu
INSERT INTO roles (role_name, description) VALUES 
('ADMIN', 'Quản trị viên hệ thống'),
('MANAGER', 'Quản lý'),
('STAFF', 'Nhân viên'),
('CUSTOMER', 'Khách hàng');

INSERT INTO categories (category_name, description, image_url, parent_id) VALUES 
('Nước hoa nam', 'Nước hoa dành cho nam giới', 'https://example.com/men-perfume.jpg', NULL),
('Nước hoa nữ', 'Nước hoa dành cho nữ giới', 'https://example.com/women-perfume.jpg', NULL),
('Nước hoa unisex', 'Nước hoa dành cho cả nam và nữ', 'https://example.com/unisex-perfume.jpg', NULL),
('Nước hoa trẻ em', 'Nước hoa dành cho trẻ em', 'https://example.com/kids-perfume.jpg', NULL),
('Nước hoa nam cao cấp', 'Nước hoa nam cao cấp', 'https://example.com/men-luxury.jpg', 1),
('Nước hoa nữ cao cấp', 'Nước hoa nữ cao cấp', 'https://example.com/women-luxury.jpg', 2);

INSERT INTO brands (brand_name, description, logo_url, website, country) VALUES 
('Chanel', 'Thương hiệu nước hoa cao cấp từ Pháp', 'https://example.com/chanel-logo.png', 'https://www.chanel.com', 'France'),
('Dior', 'Thương hiệu nước hoa sang trọng', 'https://example.com/dior-logo.png', 'https://www.dior.com', 'France'),
('Gucci', 'Thương hiệu nước hoa Ý', 'https://example.com/gucci-logo.png', 'https://www.gucci.com', 'Italy'),
('Versace', 'Thương hiệu nước hoa Ý', 'https://example.com/versace-logo.png', 'https://www.versace.com', 'Italy'),
('Tom Ford', 'Thương hiệu nước hoa cao cấp', 'https://example.com/tomford-logo.png', 'https://www.tomford.com', 'USA');

INSERT INTO payment_methods (method_name, description, is_active, processing_fee_percent) VALUES 
('Tiền mặt', 'Thanh toán khi nhận hàng', 1, 0.00),
('Chuyển khoản', 'Chuyển khoản ngân hàng', 1, 0.50),
('Thẻ tín dụng', 'Thanh toán bằng thẻ tín dụng', 1, 2.50),
('Ví điện tử', 'Thanh toán qua ví điện tử', 1, 1.00);

-- Insert users
INSERT INTO users (username, email, password, full_name, phone, avatar, is_active, is_verified, role_id) VALUES 
('admin', 'admin@nuochoa.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Nguyễn Văn Admin', '0123456789', 'https://example.com/admin-avatar.jpg', 1, 1, 1),
('manager', 'manager@nuochoa.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Trần Thị Manager', '0987654321', 'https://example.com/manager-avatar.jpg', 1, 1, 2),
('staff1', 'staff1@nuochoa.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Lê Văn Staff', '0369852147', 'https://example.com/staff-avatar.jpg', 1, 1, 3),
('customer1', 'customer1@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Phạm Thị Khách', '0521478963', 'https://example.com/customer-avatar.jpg', 1, 1, 4),
('customer2', 'customer2@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Hoàng Văn Mua', '0741258963', 'https://example.com/customer2-avatar.jpg', 1, 1, 4);

-- Insert customers
INSERT INTO customers (full_name, email, phone, address, date_of_birth, gender, is_vip, total_orders, total_spent, is_active) VALUES 
('Nguyễn Thị Lan', 'lan.nguyen@gmail.com', '0123456789', '123 Đường ABC, Quận 1, TP.HCM', '1990-05-15', 'Female', 1, 5, 2500000.00, 1),
('Trần Văn Nam', 'nam.tran@gmail.com', '0987654321', '456 Đường XYZ, Quận 2, TP.HCM', '1985-08-20', 'Male', 0, 2, 800000.00, 1),
('Lê Thị Hoa', 'hoa.le@gmail.com', '0369852147', '789 Đường DEF, Quận 3, TP.HCM', '1992-12-10', 'Female', 0, 1, 300000.00, 1),
('Phạm Văn Đức', 'duc.pham@gmail.com', '0521478963', '321 Đường GHI, Quận 4, TP.HCM', '1988-03-25', 'Male', 0, 3, 1200000.00, 1);

-- Insert addresses
INSERT INTO addresses (customer_id, full_name, phone, address_line, ward, district, city, postal_code, is_default, is_active) VALUES 
(1, 'Nguyễn Thị Lan', '0123456789', '123 Đường ABC', 'Phường Bến Nghé', 'Quận 1', 'TP.HCM', '700000', 1, 1),
(1, 'Nguyễn Thị Lan', '0123456789', '456 Đường XYZ', 'Phường Cầu Kho', 'Quận 1', 'TP.HCM', '700000', 0, 1),
(2, 'Trần Văn Nam', '0987654321', '789 Đường DEF', 'Phường Thạnh Mỹ Lợi', 'Quận 2', 'TP.HCM', '700000', 1, 1),
(3, 'Lê Thị Hoa', '0369852147', '321 Đường GHI', 'Phường Võ Thị Sáu', 'Quận 3', 'TP.HCM', '700000', 1, 1);

-- Insert products
INSERT INTO products (product_name, product_code, price, discount_price, description, product_img, quantity, weight, volume, concentration, gender, is_active, is_featured, view_count, category_id, brand_id) VALUES 
('Chanel No.5 Eau de Parfum', 'CHANEL-001', 2500000.00, 2000000.00, 'Nước hoa nữ kinh điển với hương hoa hồng và hoa nhài', 'https://example.com/chanel-no5.jpg', 50, 100.00, '100ml', 'Eau de Parfum', 'Female', 1, 1, 150, 2, 1),
('Dior Sauvage Eau de Toilette', 'DIOR-001', 1800000.00, 1500000.00, 'Nước hoa nam mạnh mẽ với hương bergamot và ambroxan', 'https://example.com/dior-sauvage.jpg', 30, 100.00, '100ml', 'Eau de Toilette', 'Male', 1, 1, 200, 1, 2),
('Gucci Bloom Eau de Parfum', 'GUCCI-001', 2200000.00, 1800000.00, 'Nước hoa nữ tươi mới với hương hoa nhài và hoa huệ', 'https://example.com/gucci-bloom.jpg', 40, 100.00, '100ml', 'Eau de Parfum', 'Female', 1, 0, 120, 2, 3),
('Versace Eros Eau de Toilette', 'VERSACE-001', 1600000.00, 1300000.00, 'Nước hoa nam quyến rũ với hương bạc hà và táo', 'https://example.com/versace-eros.jpg', 35, 100.00, '100ml', 'Eau de Toilette', 'Male', 1, 0, 180, 1, 4),
('Tom Ford Black Orchid', 'TOMFORD-001', 3500000.00, 2800000.00, 'Nước hoa unisex sang trọng với hương đen tối', 'https://example.com/tomford-blackorchid.jpg', 20, 100.00, '100ml', 'Eau de Parfum', 'Unisex', 1, 1, 80, 3, 5),
('Chanel Coco Mademoiselle', 'CHANEL-002', 2300000.00, 1900000.00, 'Nước hoa nữ thanh lịch với hương cam và hoa hồng', 'https://example.com/chanel-coco.jpg', 45, 100.00, '100ml', 'Eau de Parfum', 'Female', 1, 0, 100, 2, 1),
('Dior Homme Intense', 'DIOR-002', 2000000.00, 1700000.00, 'Nước hoa nam tinh tế với hương iris và gỗ', 'https://example.com/dior-homme.jpg', 25, 100.00, '100ml', 'Eau de Parfum', 'Male', 1, 0, 90, 1, 2);

-- Insert inventories
INSERT INTO inventories (product_id, quantity_in, quantity_out, current_stock, min_stock_level, max_stock_level, location, notes, last_updated) VALUES 
(1, 100, 50, 50, 10, 200, 'Kho A - Kệ 1', 'Sản phẩm bán chạy', GETDATE()),
(2, 80, 50, 30, 10, 150, 'Kho A - Kệ 2', 'Cần nhập thêm', GETDATE()),
(3, 60, 20, 40, 10, 100, 'Kho B - Kệ 1', 'Tồn kho ổn định', GETDATE()),
(4, 70, 35, 35, 10, 120, 'Kho B - Kệ 2', 'Sản phẩm mới', GETDATE()),
(5, 40, 20, 20, 5, 80, 'Kho C - Kệ 1', 'Sản phẩm cao cấp', GETDATE()),
(6, 90, 45, 45, 10, 180, 'Kho A - Kệ 3', 'Sản phẩm phổ biến', GETDATE()),
(7, 50, 25, 25, 10, 100, 'Kho C - Kệ 2', 'Cần theo dõi', GETDATE());

-- Insert orders
INSERT INTO orders (order_number, user_id, customer_id, total_amount, discount_amount, shipping_fee, final_amount, status, shipping_address, shipping_phone, notes, created_at) VALUES 
('ORD-001', 4, NULL, 2000000.00, 200000.00, 50000.00, 1850000.00, 'DELIVERED', '123 Đường ABC, Quận 1, TP.HCM', '0123456789', 'Giao hàng vào buổi chiều', '2024-01-15 10:30:00'),
('ORD-002', 4, NULL, 1500000.00, 0.00, 50000.00, 1550000.00, 'SHIPPING', '123 Đường ABC, Quận 1, TP.HCM', '0123456789', 'Giao hàng nhanh', '2024-01-20 14:20:00'),
('ORD-003', 5, NULL, 2800000.00, 300000.00, 50000.00, 2550000.00, 'CONFIRMED', '456 Đường XYZ, Quận 2, TP.HCM', '0987654321', 'Kiểm tra hàng cẩn thận', '2024-01-25 09:15:00'),
('ORD-004', NULL, 1, 800000.00, 0.00, 50000.00, 850000.00, 'PENDING', '123 Đường ABC, Quận 1, TP.HCM', '0123456789', 'Đơn hàng mới', '2024-01-30 16:45:00');

-- Insert order_details
INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount_percent, total_price) VALUES 
(1, 1, 1, 2000000.00, 20.00, 2000000.00),
(2, 2, 1, 1500000.00, 0.00, 1500000.00),
(3, 5, 1, 2800000.00, 20.00, 2800000.00),
(4, 3, 1, 1800000.00, 0.00, 1800000.00);

-- Insert payments
INSERT INTO payments (order_id, payment_number, amount, payment_method_id, status, transaction_id, paid_at, created_at) VALUES 
(1, 'PAY-001', 1850000.00, 1, 'COMPLETED', 'TXN-001', '2024-01-15 10:35:00', '2024-01-15 10:30:00'),
(2, 'PAY-002', 1550000.00, 2, 'COMPLETED', 'TXN-002', '2024-01-20 14:25:00', '2024-01-20 14:20:00'),
(3, 'PAY-003', 2550000.00, 3, 'PENDING', NULL, NULL, '2024-01-25 09:15:00'),
(4, 'PAY-004', 850000.00, 1, 'PENDING', NULL, NULL, '2024-01-30 16:45:00');

-- Insert promotions
INSERT INTO promotions (promotion_name, description, promotion_type, discount_value, min_order_amount, max_discount_amount, usage_limit, used_count, start_date, end_date, is_active, is_featured, image_url, category_id, brand_id) VALUES 
('Giảm giá 20% cho đơn hàng trên 2 triệu', 'Áp dụng cho tất cả sản phẩm', 'PERCENTAGE', 20.00, 2000000.00, 500000.00, 100, 15, '2024-01-01', '2024-12-31', 1, 1, 'https://example.com/promo-20percent.jpg', NULL, NULL),
('Giảm 500k cho đơn hàng trên 3 triệu', 'Khuyến mãi đặc biệt', 'FIXED_AMOUNT', 500000.00, 3000000.00, 500000.00, 50, 8, '2024-01-01', '2024-06-30', 1, 0, 'https://example.com/promo-500k.jpg', NULL, NULL),
('Mua 2 tặng 1', 'Áp dụng cho nước hoa Chanel', 'BUY_X_GET_Y', 0.00, 0.00, 0.00, 30, 5, '2024-02-01', '2024-02-29', 1, 1, 'https://example.com/promo-buy2get1.jpg', NULL, 1),
('Giảm giá nước hoa nam', 'Áp dụng cho danh mục nước hoa nam', 'PERCENTAGE', 15.00, 1000000.00, 300000.00, 200, 25, '2024-01-01', '2024-12-31', 1, 0, 'https://example.com/promo-men.jpg', 1, NULL),
('Khuyến mãi Dior', 'Áp dụng cho thương hiệu Dior', 'FIXED_AMOUNT', 300000.00, 1500000.00, 300000.00, 100, 12, '2024-01-01', '2024-12-31', 1, 0, 'https://example.com/promo-dior.jpg', NULL, 2);

-- Insert coupons
INSERT INTO coupons (promotion_id, coupon_code, description, usage_limit, used_count, start_date, end_date, is_active, is_single_use) VALUES 
(1, 'SAVE20', 'Giảm 20% cho đơn hàng trên 2 triệu', 100, 15, '2024-01-01', '2024-12-31', 1, 0),
(1, 'WELCOME20', 'Mã giảm giá chào mừng khách hàng mới', 50, 8, '2024-01-01', '2024-12-31', 1, 1),
(2, 'SAVE500K', 'Giảm 500k cho đơn hàng trên 3 triệu', 50, 8, '2024-01-01', '2024-06-30', 1, 0),
(3, 'BUY2GET1', 'Mua 2 tặng 1 sản phẩm Chanel', 30, 5, '2024-02-01', '2024-02-29', 1, 0);

-- Insert reviews
INSERT INTO reviews (user_id, product_id, rating, title, content, is_verified_purchase, is_approved, helpful_count, images, created_at) VALUES 
(4, 1, 5, 'Nước hoa tuyệt vời!', 'Chất lượng rất tốt, hương thơm lâu, đóng gói đẹp. Sẽ mua lại!', 1, 1, 12, '["https://example.com/review1-1.jpg", "https://example.com/review1-2.jpg"]', '2024-01-16 15:30:00'),
(4, 2, 4, 'Hương thơm nam tính', 'Nước hoa nam rất đẹp, phù hợp cho công việc và đi chơi', 1, 1, 8, '["https://example.com/review2-1.jpg"]', '2024-01-21 10:15:00'),
(5, 5, 5, 'Sản phẩm cao cấp', 'Tom Ford luôn là lựa chọn tốt nhất, chất lượng tuyệt vời', 1, 1, 15, '["https://example.com/review3-1.jpg", "https://example.com/review3-2.jpg"]', '2024-01-26 14:20:00'),
(4, 3, 3, 'Tạm ổn', 'Hương thơm ổn nhưng không đặc biệt lắm', 0, 1, 3, NULL, '2024-01-18 09:45:00'),
(5, 6, 4, 'Chanel chất lượng', 'Sản phẩm Chanel luôn đáng tin cậy, hương thơm sang trọng', 0, 1, 6, '["https://example.com/review5-1.jpg"]', '2024-01-22 16:10:00');

-- Insert promotion_usage
INSERT INTO promotion_usage (promotion_id, customer_id, user_id, order_id, discount_amount, used_at) VALUES 
(1, NULL, 4, 1, 200000.00, '2024-01-15 10:30:00'),
(1, NULL, 4, 2, 0.00, '2024-01-20 14:20:00'),
(3, NULL, 5, 3, 300000.00, '2024-01-25 09:15:00'),
(4, 1, NULL, 4, 0.00, '2024-01-30 16:45:00');

-- Tạo trigger để tự động cập nhật updated_at
GO

CREATE TRIGGER TR_products_updated_at
ON products
AFTER UPDATE
AS
BEGIN
    UPDATE products 
    SET updated_at = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE TRIGGER TR_orders_updated_at
ON orders
AFTER UPDATE
AS
BEGIN
    UPDATE orders 
    SET updated_at = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

PRINT 'Database đã được tạo thành công!';
