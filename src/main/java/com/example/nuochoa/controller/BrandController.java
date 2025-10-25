package com.example.nuochoa.controller;

import com.example.nuochoa.entity.BrandsEntity;
import com.example.nuochoa.service.BrandService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/brands")
@CrossOrigin(origins = "*")
public class BrandController {
    
    @Autowired
    private BrandService brandService;
    
    @GetMapping
    public ResponseEntity<List<BrandsEntity>> getAllBrands() {
        System.out.println("BrandController: Nhận request GET /api/brands");
        try {
            List<BrandsEntity> brands = brandService.getAllBrands();
            System.out.println("BrandController: Trả về " + brands.size() + " brands");
            return ResponseEntity.ok(brands);
        } catch (Exception e) {
            System.err.println("BrandController: Lỗi khi lấy brands: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(null);
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<BrandsEntity> getBrandById(@PathVariable Integer id) {
        return ResponseEntity.ok(brandService.getBrandById(id));
    }
    
    @PostMapping
    public ResponseEntity<BrandsEntity> createBrand(@RequestBody BrandsEntity brand) {
        return ResponseEntity.ok(brandService.saveBrand(brand));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<BrandsEntity> updateBrand(@PathVariable Integer id, @RequestBody BrandsEntity brand) {
        return ResponseEntity.ok(brandService.updateBrand(id, brand));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBrand(@PathVariable Integer id) {
        brandService.deleteBrand(id);
        return ResponseEntity.ok().build();
    }
}
