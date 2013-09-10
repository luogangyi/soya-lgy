package com.marmot.soya.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.marmot.soya.entity.Category;
import com.marmot.soya.entity.Label;


public interface LabelDao extends PagingAndSortingRepository<Label, Long>, JpaSpecificationExecutor<Label> {
    List<Label> findByCategory(Category category);
    Label findById(Long id);
}
