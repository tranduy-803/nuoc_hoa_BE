package com.example.nuochoa.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
public class ProductResponseDTO {
    private Integer id;
    private String productName;
    private String productCode;
    private BigDecimal price;
    private BigDecimal discountPrice;
    private String description;
    private String productImg;
    private Integer quantity;
    private BigDecimal weight;
    private String volume;
    private String concentration;
    private String gender;
    private BrandDTO brand; // Simplified brand info
    private Boolean isActive;
    private Boolean isFeatured;
    private Integer viewCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Getter
    @Setter
    public static class BrandDTO {
        private Integer id;
        private String brandName;
        private String country;
        
        public BrandDTO(Integer id, String brandName, String country) {
            this.id = id;
            this.brandName = brandName;
            this.country = country;
        }
    }
}
