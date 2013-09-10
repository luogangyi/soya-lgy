package com.marmot.soya.entity;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


@Entity
@Table(name = "label_keywords")
public class LabelKeyword extends IdEntity {
    private Label label;
    private String str;
    
    @ManyToOne
    @JoinColumn(name = "label_id")
    public Label getLabel() {
        return label;
    }
    public void setLabel(Label label) {
        this.label = label;
    }
    public String getStr() {
        return str;
    }
    public void setStr(String str) {
        this.str = str;
    }
}