-- Insert roles
INSERT INTO roles (role_name, description, is_active) 
VALUES ('ADMIN', 'Administrator role with full access', 1);

INSERT INTO roles (role_name, description, is_active) 
VALUES ('STAFF', 'Staff role with limited access', 1);

-- Insert admin user (password: admin123)
INSERT INTO users (username, email, password, full_name, phone, avatar, is_active, is_verified, created_at, role_id)
VALUES ('admin', 'admin@nuochoa.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOslb5LhPHhpLG', 'Administrator', '0123456789', NULL, 1, 1, GETDATE(), 1);

-- Insert staff user (password: staff123)
INSERT INTO users (username, email, password, full_name, phone, avatar, is_active, is_verified, created_at, role_id)
VALUES ('staff', 'staff@nuochoa.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOslb5LhPHhpLG', 'Staff Member', '0987654321', NULL, 1, 1, GETDATE(), 2);
