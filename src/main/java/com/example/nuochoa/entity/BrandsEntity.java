package com.example.nuochoa.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "brands")
public class BrandsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name = "brand_name")
    private String brandName;
    @Column(name = "description")
    private String description;
    @Column(name = "logo_url")
    private String logoUrl;
    @Column(name = "website")
    private String website;
    @Column(name = "country")
    private String country;
    @Column(name = "is_active")
    private Boolean isActive;
    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        createdAt = now;
        updatedAt = now;
        System.out.println("PrePersist - createdAt: " + createdAt);
        System.out.println("PrePersist - updatedAt: " + updatedAt);
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        System.out.println("PreUpdate - updatedAt: " + updatedAt);
    }
    
}
