    package com.example.nuochoa.entity;

    import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
    import jakarta.persistence.*;
    import lombok.AllArgsConstructor;
    import lombok.Getter;
    import lombok.NoArgsConstructor;
    import lombok.Setter;
    import org.hibernate.annotations.ColumnDefault;
    import org.hibernate.annotations.Nationalized;

    import java.math.BigDecimal;
    import java.time.LocalDateTime;

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    @Entity
    @Table(name = "products")
    public class Product {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id", nullable = false)
        private Integer id;

        @Nationalized
        @Column(name = "product_name", length = 100, nullable = false)
        private String productName;

        @Nationalized
        @Column(name = "product_code", length = 50, unique = true, nullable = false)
        private String productCode;

        @Column(name = "price", precision = 20, scale = 2, nullable = false)
        private BigDecimal price;

        @Column(name = "discount_price", precision = 20, scale = 2)
        private BigDecimal discountPrice;

        @Nationalized
        @Column(name = "description", length = 1000)
        private String description;

        @Column(name = "product_img", length = 255)
        private String productImg;

        @Column(name = "quantity", nullable = false)
        @ColumnDefault("0")
        private Integer quantity;

        @Column(name = "weight", precision = 10, scale = 2)
        private BigDecimal weight;

        @Column(name = "volume", length = 50)
        private String volume;

        @Column(name = "concentration", length = 50)
        private String concentration;

        @Column(name = "gender", length = 20)
        private String gender; // Male, Female, Unisex

        @Column(name = "is_active")
        @ColumnDefault("true")
        private Boolean isActive;

        @Column(name = "is_featured")
        @ColumnDefault("false")
        private Boolean isFeatured;

        @Column(name = "view_count")
        @ColumnDefault("0")
        private Integer viewCount;

        @Column(name = "created_at")
        private LocalDateTime createdAt;

        @Column(name = "updated_at")
        private LocalDateTime updatedAt;

        @ManyToOne(fetch = FetchType.EAGER)
        @JoinColumn(name = "brand_id", referencedColumnName = "id")
        private BrandsEntity brand;

        // Getter để serialize brand cho frontend
        public BrandsEntity getBrand() {
            return brand;
        }

        // Setter để deserialize brand từ frontend
        public void setBrand(BrandsEntity brand) {
            this.brand = brand;
        }

    }