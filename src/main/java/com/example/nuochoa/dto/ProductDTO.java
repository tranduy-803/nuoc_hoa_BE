package com.example.nuochoa.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class ProductDTO {
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
    private Integer brandId; // Frontend gửi brandId
    private Boolean isFeatured;
}
