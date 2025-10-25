package com.example.nuochoa.controller;

import com.example.nuochoa.entity.Product;
import com.example.nuochoa.repository.ProductRepository;
import com.example.nuochoa.service.ProductSevices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/product/")
@CrossOrigin(origins = "*")
public class ProductController {
    @Autowired
    private ProductSevices productSevices;

    @GetMapping("getAll")
    public List<Product> getAll(){
        return productSevices.getAllProducts();
    }
    @GetMapping("detail/{id}")
    public Product getProduct(@PathVariable("id") Integer id){
        return productSevices.getProduct(id);
    }

    @PostMapping("add")
    public void addProduct(@RequestBody Product product){
        product.setCreatedAt(LocalDateTime.now());
        productSevices.saveProduct(product);
    }

    @PutMapping("update/{id}")
    public void update(@PathVariable Integer id, @RequestBody Product product) {
        product.setId(id);
        product.setUpdatedAt(LocalDateTime.now());
        productSevices.saveProduct(product);
    }

    @DeleteMapping("remove/{id}")
    public void deleteProduct(@PathVariable("id") Integer id){
        productSevices.deleteProduct(id);
    }

}
