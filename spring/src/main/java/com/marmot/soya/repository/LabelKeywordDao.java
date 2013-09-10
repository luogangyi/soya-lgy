package com.marmot.soya.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;

import com.marmot.soya.entity.Label;
import com.marmot.soya.entity.LabelKeyword;

public interface LabelKeywordDao extends PagingAndSortingRepository<LabelKeyword, Long>, 
    JpaSpecificationExecutor<LabelKeyword>{
    public List<LabelKeyword> findByLabel(Label label);
}
