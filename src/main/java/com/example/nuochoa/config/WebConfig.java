package com.example.nuochoa.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String projectRoot = System.getProperty("user.dir");
        
        // Sửa đường dẫn cho đúng
        String absolutePath = projectRoot + "/src/main/resources/static/uploads/";
        
        System.out.println("=== WEB CONFIG DEBUG ===");
        System.out.println("Project Root: " + projectRoot);
        System.out.println("Absolute Upload Path: " + absolutePath);
        
        // Cấu hình resource handler cho /uploads/**
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absolutePath)
                .setCachePeriod(0);
        
        System.out.println("Successfully registered /uploads/** handler");
        System.out.println("=========================");
    }
}
