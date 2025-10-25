package com.example.nuochoa.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import jakarta.annotation.PostConstruct;
import java.util.TimeZone;

@Configuration
public class TimezoneConfig implements WebMvcConfigurer {
    
    @PostConstruct
    public void init() {
        // Set default timezone cho toàn bộ ứng dụng
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        System.out.println("Timezone đã được set thành: " + TimeZone.getDefault().getID());
    }
}
