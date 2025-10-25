package com.example.nuochoa.repository;

import com.example.nuochoa.entity.BrandsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BrandRepository extends JpaRepository<BrandsEntity,Integer> {
}
