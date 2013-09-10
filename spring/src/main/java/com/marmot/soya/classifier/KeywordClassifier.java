package com.marmot.soya.classifier;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.google.common.collect.HashMultimap;
import com.marmot.soya.entity.Category;
import com.marmot.soya.entity.Label;

public class KeywordClassifier extends Classifier {
HashMultimap<String, String> keywordMap = HashMultimap.create(); 
    
    public KeywordClassifier(Category category, List<Label> labels) {
        super(category, labels);
    }
    
    @Override
    public void warmup(String word, Label label) {
        keywordMap.put(label.getStr(), word);
    }
    
    @Override
    public List<Label> getLabel(String text) {
        ArrayList<Label> result = new ArrayList<Label>();
        
        for(Label label : labelMap.values()) {
            Set<String> set = keywordMap.get(label.getStr());
            for(String s : set) {
                if(text.indexOf(s) != -1) {
                    result.add(label);
                    break;
                }
            }
        }
        
        if(result.size() == 0) {
            if(labelMap.containsKey("其他产品")) {
                result.add(labelMap.get("其他产品"));
            }
        }else if(result.size() > 1) {
            for(Label label : result) {
                if(label.getStr().equals("产品泛称")) {
                    result.remove(label);
                    break;
                }
            }
        }
        
        return result;
    }
    
    @Override
    public void train(String text, Label label) { 
        // to be added
    }
}