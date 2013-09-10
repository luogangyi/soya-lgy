package com.marmot.soya.entity;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.validator.constraints.NotBlank;


@Entity
@Table(name = "labels")
public class Label extends IdEntity {
    private Category category;
    private String str;
    
    @ManyToOne
    @JoinColumn(name="category_id")
    public Category getCategory() {
        return category;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
    
    @NotBlank
    public String getStr() {
        return str;
    }
    public void setStr(String str) {
        this.str = str;
    }
}
