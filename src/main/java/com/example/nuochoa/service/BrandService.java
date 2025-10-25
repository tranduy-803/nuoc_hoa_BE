package com.example.nuochoa.service;

import com.example.nuochoa.entity.BrandsEntity;
import com.example.nuochoa.repository.BrandRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BrandService {
    
    @Autowired
    private BrandRepository brandRepository;
    
    public List<BrandsEntity> getAllBrands() {
        System.out.println("BrandService: Đang lấy tất cả brands...");
        List<BrandsEntity> brands = brandRepository.findAll();
        System.out.println("BrandService: Tìm thấy " + brands.size() + " brands");
        return brands;
    }
    
    public BrandsEntity getBrandById(Integer id) {
        return brandRepository.findById(id).orElse(null);
    }
    
    public BrandsEntity saveBrand(BrandsEntity brand) {
        System.out.println("BrandService: Đang lưu brand...");
        System.out.println("BrandService: Thời gian hiện tại: " + java.time.LocalDateTime.now());
        System.out.println("BrandService: Timezone: " + java.util.TimeZone.getDefault().getID());
        
        BrandsEntity savedBrand = brandRepository.save(brand);
        
        System.out.println("BrandService: Brand đã lưu với createdAt: " + savedBrand.getCreatedAt());
        System.out.println("BrandService: Brand đã lưu với updatedAt: " + savedBrand.getUpdatedAt());
        
        return savedBrand;
    }
    
    public BrandsEntity updateBrand(Integer id, BrandsEntity brand) {
        System.out.println("BrandService: Đang cập nhật brand ID: " + id);
        System.out.println("BrandService: Thời gian hiện tại: " + java.time.LocalDateTime.now());
        
        brand.setId(id);
        BrandsEntity updatedBrand = brandRepository.save(brand);
        
        System.out.println("BrandService: Brand đã cập nhật với updatedAt: " + updatedBrand.getUpdatedAt());
        
        return updatedBrand;
    }
    
    public void deleteBrand(Integer id) {
        brandRepository.deleteById(id);
    }
}
