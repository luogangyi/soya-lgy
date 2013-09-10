package com.marmot.soya.classifier;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.marmot.soya.entity.Category;
import com.marmot.soya.entity.Label;
import com.marmot.soya.entity.LabelKeyword;
import com.marmot.soya.repository.LabelKeywordDao;

public class Classifier {
    protected Category mainCategory;
    protected Map<String, Label> labelMap;
    
    public Classifier(Category category, List<Label> labels) {
        this.mainCategory = category;
        this.labelMap = new HashMap<String, Label>();
        for(Label label : labels) {
            labelMap.put(label.getStr(), label);
        }
    }
    
    public Category getMainCategory() {
        return mainCategory;
    }
    
    public void init(LabelKeywordDao labelKeywordDao) {
        // read warm-up data from database
        for(Label label : labelMap.values()) {
            List<LabelKeyword> list = labelKeywordDao.findByLabel(label);
            for(LabelKeyword labelKeyword : list) {
                warmup(labelKeyword.getStr(), label);
            }
        }
    }
    
    public void warmup(String word, Label label) {
        // to be override
    }
    
    /*
     * 取得分类
     */
    public List<Label> getLabel(String text) {
        // to be override
        return null;
    }

    public boolean containsLabel(Label label){
        System.out.println(labelMap.containsKey(label.getStr()));
        return labelMap.containsKey(label.getStr());
    }
    
    /*
     * 校正分类器
     */
    public void train(String text, Label label) { 
        // to be override
    }

}
