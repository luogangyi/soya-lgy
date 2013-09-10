package com.marmot.soya.entity;

import javax.persistence.Table;

import javax.persistence.Entity;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotBlank;

@Entity
@Table(name = "categories")
public class Category extends IdEntity {
    private String str;
    private boolean by_keyword;
    
    @NotBlank
    public String getStr() {
        return str;
    }
    public void setStr(String str){
        this.str = str;
    }
    
    @NotNull
    public boolean getByKeyword(){
        return by_keyword;
    }
    public void setByKeyword(boolean by_keyword) {
        this.by_keyword = by_keyword;
    }
}
