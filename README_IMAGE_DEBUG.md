# Debug Image Display Issue

## Steps to Debug:

1. **Khởi động lại backend** trên IntelliJ
2. **Kiểm tra console log** để xem:

   - "Project Root: ..."
   - "Upload Path: ..."
   - "Registering uploads handler with path: ..."
   - "Product: [name], Image: [path]"

3. **Test image URL trong browser:**

   ```
   http://localhost:8080/uploads/1761352249339_anh1.jpg
   ```

   Nếu không truy cập được, kiểm tra:

   - Đường dẫn trong console có đúng không
   - File có tồn tại trong thư mục đó không

4. **Kiểm tra Network tab trong DevTools:**

   - Mở F12 -> Network tab
   - Reload trang sản phẩm
   - Xem request đến `/uploads/...`
   - Xem status code (200 = OK, 404 = Not Found, 403 = Forbidden)

5. **Kiểm tra giá trị `productImg` trong database:**
   - Mở database
   - Query: `SELECT id, productName, productImg FROM products`
   - Xem giá trị trong cột `productImg`

## Expected Image Path Format:

- Trong database: `1761352249339_anh1.jpg` hoặc `/uploads/1761352249339_anh1.jpg`
- URL truy cập: `http://localhost:8080/uploads/1761352249339_anh1.jpg`
