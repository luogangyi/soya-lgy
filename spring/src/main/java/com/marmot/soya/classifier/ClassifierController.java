package com.marmot.soya.classifier;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.marmot.soya.entity.Category;
import com.marmot.soya.entity.Label;
import com.marmot.soya.repository.CategoryDao;
import com.marmot.soya.repository.LabelDao;
import com.marmot.soya.repository.LabelKeywordDao;

@Controller
public class ClassifierController {
    @Autowired
    LabelDao labelDao;
    @Autowired
    CategoryDao categoryDao;
    @Autowired
    LabelKeywordDao labelKeywordDao;
    
    private static ArrayList<Classifier> classifiers;
    
    @PostConstruct
    public void init() {
        System.out.println("initialize classifiers...");
        classifiers = new ArrayList<Classifier>();
        List<Category> categories = (List<Category>) categoryDao.findAll();
        for (Category category : categories) {
            List<Label> labels = labelDao.findByCategory(category);
            if (labels.size() >= 2) {
                Classifier classifier;
                if(category.getByKeyword()) {
                    classifier = new KeywordClassifier(category, labels);
                } else {
                    classifier = new LangModelClassifier(category, labels);
                }
                classifier.init(labelKeywordDao);
                classifiers.add(classifier);
            }
        }
        System.out.println("initialize classifiers done!");
    }
    
    class Entity {
        private List<Long> labelIds;
        private Long categoryId;
        public Entity(List<Label> labels, Category category) {
            categoryId = category.getId();
            labelIds = new ArrayList<Long>();
            for(Label label : labels) {
                labelIds.add(label.getId());
            }
        }
        public List<Long> getLabelIds() {
            return labelIds;
        }
        public Long getCategoryId() {
            return categoryId;
        }
    }
    
    @RequestMapping(value = "classify", method = RequestMethod.GET)
    @ResponseBody
    public List<Entity> classify(@RequestParam String content) {
        //System.out.println("content: " + content);
        ArrayList<Entity> entities = new ArrayList<ClassifierController.Entity>();
        for (Classifier classifier : classifiers) {
            List<Label> labels = classifier.getLabel(content); 
            Entity entity = new Entity(labels, classifier.getMainCategory());
            entities.add(entity);
        }
       
        return entities;
    }
    
    @RequestMapping(value = "train", method = RequestMethod.GET)
    @ResponseBody
    public void train(@RequestParam String content, @RequestParam long label_id) {

        Label label = labelDao.findById(label_id);

        for (Classifier classifier : classifiers) {
            if(classifier.containsLabel(label)){
                classifier.train(content,label);
            }
        }

        


        //train2(content,label_id);
        //return label.getStr();
    }

    // @RequestMapping(value = "train_history", method = RequestMethod.GET)
    // @ResponseBody
    // public boolean train_history() {
        
    //     return true;
    // }
}
