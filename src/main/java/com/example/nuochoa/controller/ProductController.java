package com.example.nuochoa.controller;

import com.example.nuochoa.entity.Product;
import com.example.nuochoa.entity.BrandsEntity;
import com.example.nuochoa.dto.ProductDTO;
import com.example.nuochoa.dto.ProductResponseDTO;
import com.example.nuochoa.repository.ProductRepository;
import com.example.nuochoa.repository.BrandRepository;
import com.example.nuochoa.service.ProductSevices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/product")
@CrossOrigin(origins = "*")
public class ProductController {
    @Autowired
    private ProductSevices productSevices;

    @Autowired
    private BrandRepository brandRepository;

    @GetMapping("/getAll")
    public List<ProductResponseDTO> getAll(){
        List<Product> products = productSevices.getAllProducts();
        System.out.println("Number of products: " + products.size());
        
        // Convert to DTO
        return products.stream().map(p -> {
            ProductResponseDTO dto = new ProductResponseDTO();
            dto.setId(p.getId());
            dto.setProductName(p.getProductName());
            dto.setProductCode(p.getProductCode());
            dto.setPrice(p.getPrice());
            dto.setDiscountPrice(p.getDiscountPrice());
            dto.setDescription(p.getDescription());
            dto.setProductImg(p.getProductImg());
            // Debug: log image path
            System.out.println("Product: " + p.getProductName() + ", Image: " + p.getProductImg());
            dto.setQuantity(p.getQuantity());
            dto.setWeight(p.getWeight());
            dto.setVolume(p.getVolume());
            dto.setConcentration(p.getConcentration());
            dto.setGender(p.getGender());
            dto.setIsActive(p.getIsActive());
            dto.setIsFeatured(p.getIsFeatured());
            dto.setViewCount(p.getViewCount());
            dto.setCreatedAt(p.getCreatedAt());
            dto.setUpdatedAt(p.getUpdatedAt());
            
            // Convert brand
            if (p.getBrand() != null) {
                ProductResponseDTO.BrandDTO brandDTO = new ProductResponseDTO.BrandDTO(
                    p.getBrand().getId(),
                    p.getBrand().getBrandName(),
                    p.getBrand().getCountry()
                );
                dto.setBrand(brandDTO);
            }
            
            return dto;
        }).collect(Collectors.toList());
    }
    
    @GetMapping("/detail/{id}")
    public ProductResponseDTO getProduct(@PathVariable("id") Integer id){
        Product p = productSevices.getProduct(id);
        if (p == null) return null;
        
        ProductResponseDTO dto = new ProductResponseDTO();
        dto.setId(p.getId());
        dto.setProductName(p.getProductName());
        dto.setProductCode(p.getProductCode());
        dto.setPrice(p.getPrice());
        dto.setDiscountPrice(p.getDiscountPrice());
        dto.setDescription(p.getDescription());
        dto.setProductImg(p.getProductImg());
        dto.setQuantity(p.getQuantity());
        dto.setWeight(p.getWeight());
        dto.setVolume(p.getVolume());
        dto.setConcentration(p.getConcentration());
        dto.setGender(p.getGender());
        dto.setIsActive(p.getIsActive());
        dto.setIsFeatured(p.getIsFeatured());
        dto.setViewCount(p.getViewCount());
        dto.setCreatedAt(p.getCreatedAt());
        dto.setUpdatedAt(p.getUpdatedAt());
        
        // Convert brand
        if (p.getBrand() != null) {
            ProductResponseDTO.BrandDTO brandDTO = new ProductResponseDTO.BrandDTO(
                p.getBrand().getId(),
                p.getBrand().getBrandName(),
                p.getBrand().getCountry()
            );
            dto.setBrand(brandDTO);
        }
        
        return dto;
    }

    @PostMapping("/add")
    public Product addProduct(@RequestBody ProductDTO productDTO){
        Product product = new Product();
        product.setProductName(productDTO.getProductName());
        product.setProductCode(productDTO.getProductCode());
        product.setPrice(productDTO.getPrice());
        product.setDiscountPrice(productDTO.getDiscountPrice());
        product.setDescription(productDTO.getDescription());
        product.setProductImg(productDTO.getProductImg());
        product.setQuantity(productDTO.getQuantity());
        product.setWeight(productDTO.getWeight());
        product.setVolume(productDTO.getVolume());
        product.setConcentration(productDTO.getConcentration());
        product.setGender(productDTO.getGender());
        product.setIsFeatured(productDTO.getIsFeatured());
        product.setCreatedAt(LocalDateTime.now());
        
        // Set brand relationship
        if (productDTO.getBrandId() != null) {
            BrandsEntity brand = brandRepository.findById(productDTO.getBrandId()).orElse(null);
            product.setBrand(brand);
        }
        
        return productSevices.saveProduct(product);
    }

    @PutMapping("/update/{id}")
    public Product update(@PathVariable Integer id, @RequestBody ProductDTO productDTO) {
        Product product = new Product();
        product.setId(id);
        product.setProductName(productDTO.getProductName());
        product.setProductCode(productDTO.getProductCode());
        product.setPrice(productDTO.getPrice());
        product.setDiscountPrice(productDTO.getDiscountPrice());
        product.setDescription(productDTO.getDescription());
        product.setProductImg(productDTO.getProductImg());
        product.setQuantity(productDTO.getQuantity());
        product.setWeight(productDTO.getWeight());
        product.setVolume(productDTO.getVolume());
        product.setConcentration(productDTO.getConcentration());
        product.setGender(productDTO.getGender());
        product.setIsFeatured(productDTO.getIsFeatured());
        product.setUpdatedAt(LocalDateTime.now());
        
        // Set brand relationship
        if (productDTO.getBrandId() != null) {
            BrandsEntity brand = brandRepository.findById(productDTO.getBrandId()).orElse(null);
            product.setBrand(brand);
        }
        
        return productSevices.saveProduct(product);
    }

    @DeleteMapping("/remove/{id}")
    public void deleteProduct(@PathVariable("id") Integer id){
        productSevices.deleteProduct(id);
    }

}
