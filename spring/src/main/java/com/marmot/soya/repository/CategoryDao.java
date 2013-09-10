package com.marmot.soya.repository;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.marmot.soya.entity.Category;

public interface CategoryDao extends PagingAndSortingRepository<Category, Long>, JpaSpecificationExecutor<Category> {

}
