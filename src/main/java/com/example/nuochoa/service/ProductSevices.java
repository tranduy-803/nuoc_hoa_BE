package com.example.nuochoa.service;

import com.example.nuochoa.entity.Product;
import com.example.nuochoa.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductSevices {
    @Autowired
    private ProductRepository productRepository;


    public List<Product> getAllProducts(){
        return productRepository.findAll();
    }

    public void deleteProduct(Integer id){
        productRepository.deleteById(id);
    }
    public Product saveProduct(Product product){
        return productRepository.save(product);
    }
    public Product getProduct(Integer id){
        return productRepository.findById(id).orElse(null);
    }
}
