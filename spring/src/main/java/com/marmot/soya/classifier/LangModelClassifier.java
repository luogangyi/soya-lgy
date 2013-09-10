package com.marmot.soya.classifier;

import java.util.ArrayList;
import java.util.List;

import com.aliasi.classify.Classification;
import com.aliasi.classify.Classified;
import com.aliasi.classify.DynamicLMClassifier;
import com.aliasi.classify.JointClassification;
import com.aliasi.lm.NGramProcessLM;
import com.google.common.base.Joiner;
import com.marmot.soya.entity.Category;
import com.marmot.soya.entity.Label;
import com.marmot.soya.repository.LabelDao;

public class LangModelClassifier extends Classifier {

    private final static int NGRAM_SIZE = 5;        
    private DynamicLMClassifier<NGramProcessLM> classifier; 
    
    public LangModelClassifier(Category category, List<Label> labels) {
        super(category, labels);
        classifier = DynamicLMClassifier.createNGramProcess(
                labelMap.keySet().toArray(new String[labels.size()]), NGRAM_SIZE);
    }
    
    @Override
    public void warmup(String word, Label label) {
        train(word, label);
    }

    @Override
    public List<Label> getLabel(String text) {
        ArrayList<String> words = ChineseTokenizer.tokenize(text);
        text = Joiner.on("").join(words);
        
        JointClassification jc = classifier.classify(text);
        Label label = labelMap.get(jc.bestCategory());
        
        ArrayList<Label> result = new ArrayList<Label>();
        result.add(label);
        
        return result;
    }
    
    private void trainHelper(String word, Label label) {
        Classification classification = new Classification(label.getStr());
        Classified<CharSequence> classified = new Classified<CharSequence>(word, classification);            
        classifier.handle(classified);
    }
    
    @Override
    public void train(String text, Label label) {
        ArrayList<String> words = ChineseTokenizer.tokenize(text);
        for(String word : words) {
            trainHelper(word, label);
        }
    }
 }
