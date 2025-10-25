package com.example.nuochoa.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/api/upload")
@CrossOrigin(origins = "*")
public class FileUploadController {
    
    private static final String UPLOAD_DIR = "src/main/resources/static/uploads/";
    
    @PostMapping("/image")
    public ResponseEntity<String> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            System.out.println("=== UPLOAD DEBUG START ===");
            System.out.println("File received: " + file.getOriginalFilename());
            System.out.println("File size: " + file.getSize());
            System.out.println("Content type: " + file.getContentType());
            
            // Tạo thư mục uploads nếu chưa có
            File directory = new File(UPLOAD_DIR);
            System.out.println("Upload directory: " + directory.getAbsolutePath());
            if (!directory.exists()) {
                boolean created = directory.mkdirs();
                System.out.println("Directory created: " + created);
            }
            
            // Kiểm tra file có tồn tại không
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body("File không được để trống");
            }
            
            // Kiểm tra định dạng file
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body("Chỉ chấp nhận file ảnh");
            }
            
            // Kiểm tra kích thước file (max 5MB)
            if (file.getSize() > 5 * 1024 * 1024) {
                return ResponseEntity.badRequest().body("File quá lớn! Vui lòng chọn file nhỏ hơn 5MB");
            }
            
            // Tạo tên file unique
            String originalFileName = file.getOriginalFilename();
            String fileExtension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            String fileName = System.currentTimeMillis() + "_" + originalFileName;
            
            // Lưu file
            Path filePath = Paths.get(UPLOAD_DIR + fileName);
            System.out.println("Saving to: " + filePath.toAbsolutePath());
            Files.copy(file.getInputStream(), filePath);
            
            // Trả về URL
            String imageUrl = "/uploads/" + fileName;
            System.out.println("Returning URL: " + imageUrl);
            System.out.println("=== UPLOAD DEBUG END ===");
            return ResponseEntity.ok(imageUrl);
            
        } catch (IOException e) {
            System.out.println("=== UPLOAD ERROR ===");
            System.out.println("IOException: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body("Upload failed: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("=== UPLOAD ERROR ===");
            System.out.println("Exception: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body("Upload failed: " + e.getMessage());
        }
    }
    
    @DeleteMapping("/image")
    public ResponseEntity<String> deleteImage(@RequestParam("imageUrl") String imageUrl) {
        try {
            // Lấy tên file từ URL
            String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
            Path filePath = Paths.get(UPLOAD_DIR + fileName);
            
            // Xóa file
            if (Files.exists(filePath)) {
                Files.delete(filePath);
                return ResponseEntity.ok("File deleted successfully");
            } else {
                return ResponseEntity.notFound().build();
            }
            
        } catch (IOException e) {
            return ResponseEntity.status(500).body("Delete failed: " + e.getMessage());
        }
    }
}
