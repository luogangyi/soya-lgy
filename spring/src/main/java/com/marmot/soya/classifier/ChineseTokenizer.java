package com.marmot.soya.classifier;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.regex.Pattern;

import org.wltea.analyzer.core.IKSegmenter;
import org.wltea.analyzer.core.Lexeme;

public class ChineseTokenizer {   //分词器
    public static ArrayList<String> tokenize(String content) {
        ArrayList<String> list = new ArrayList<String>();
        try {
            StringReader sr = new StringReader(content);  
            IKSegmenter ik = new IKSegmenter(sr, true);  
            Lexeme lex=null;  
            while((lex=ik.next())!=null){  
                String word = lex.getLexemeText();
                if(!Pattern.matches(".*[a-zA-Z0-9]+.*", word)) { //过滤掉含字母或数字的短语
                    list.add(word);
                    //System.out.println(word+"|");
                }
            }           
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static void main(String[] args) {
        String text = "有质量问题就应该给消费者解决！//@蓝精灵佳佳伊米哒: @CCTV315 西门子的冰箱有问题热水器也一样！ //@蓝精灵佳佳伊米哒:回复@romonachueng花音:其实我是六月才开始用 九月份就坏了 这半年又坏了[怒]能说不是质量问题吗[怒]连维修人员自己都说这批产品就是这个毛病[怒]所以绝对不是个案！@央视新闻";
        // 过滤转发
        String content = text.replaceAll("//@[^@]+:\\s?", "");
        System.out.println(content);
        // 过滤回复
        content = content.replaceAll("回复@[^:]+:", "");
        // 过滤@
        content = content.replaceAll("@[^\\s]+\\s?", "");
        System.out.println(content);
    }
}
