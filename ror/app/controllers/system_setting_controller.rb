# -*- encoding : utf-8 -*-

class SystemSettingController < ApplicationController
  ItemPerPage = 5 

  def index
    if not has_setting?
        redirect_to  :action => 'overall_config'
    end 
  	@hots = Hot.all
    @categories = Category.all

    @categories.each do |category|
      category.labels = Label.find_by_sql("select labels.id,labels.str from
      labels,categories where labels.category_id = categories.id and categories.id ="+category.id.to_s) 
    end

    @info_source_types = InfoSourceType.all
  end

  def overall_config
    @hot = Hot.new
  end

  def show
    @query = get_query(params[:id])
    @hot = Hot.find(params[:id])
    @results = get_all_infos(params[:id])

  end



  def overall_create
  	hot_name = params[:name]
    hot_keywords = params[:keywords]
    
  	start_at = Time.parse(params[:start_at] + "　00:00:00")
  	end_at = Time.parse(params[:end_at] + "　23:59:59")

  	key_words = hot_keywords.split(",")

    #分割关键词
  	for key in key_words
  		keyword = Keyword.new
  		keyword.str = key
  		keyword.enable = 1
  		keyword.save
  	end

    hot = Hot.new
    hot.name = hot_name
    hot.start_at = start_at
    hot.end_at = end_at
    #保存到hot表中
    hot.save

    #处理label group
    #这里设定为最多处理50个
    label_name = 'label'
    label_type = 'myselct'
    for i in 1..50
      current_name = label_name+i.to_s
      current_select = label_type +i.to_s

      #如果有该项标签组
      if params[current_name] != nil
        category_str = params[current_name.to_sym]
        category_type_str = params[current_select.to_sym]
        puts category_str,category_type_str
        if category_type_str == 'Category 1'
          category_type = 1
        else
          category_type = 0
        end
        category= Category.new
        category.str = category_str
        category.by_keyword = category_type
        category.save

      end
    end

  	if hot.save 
  		redirect_to :action => "label_config"
  	end
  end


  def label_config
    @categories = Category.all
  end


  def label_create
    #处理label group
    group_name = 'Category_'
    params.each do |key, value|
      if (key.to_s[/Category_\d+/])
        category_id = key.to_s.split("_")[1]
        label_names = value.to_s.split(",")
          for label_name in label_names
            label= Label.new
            label.str = label_name
            label.category_id = category_id
            label.save
        end
      end
    end
    redirect_to :action => "label_keywords_config"
  end

  #配置每个标签包含的关键词
  def label_keywords_config
    @labels = Label.find_by_sql("select labels.id,labels.str,categories.str as label_type from
      labels,categories where labels.category_id = categories.id and categories.by_keyword = 1") 
    #@labels = Category.labels.where(by_keyword: 1 ) 
  end

  #为标签创建关键词
  def label_keywords_create
    label_name = 'Label_'
    params.each do |key, value|
      if (key.to_s[/Label_\d+/])
        label_id = key.to_s.split("_")[1]
        label_keywords = value.to_s.split(",")
          for label_keyword in label_keywords
            labelKeyword= LabelKeyword.new
            labelKeyword.str = label_keyword
            labelKeyword.label_id = label_id
            labelKeyword.save
        end
      end
    end
    redirect_to :action => "info_source_type_config"
  end

  #配置信息来源
  def info_source_type_config
    @info_source_types = InfoSourceType.all
  end

  def info_source_type_update
    InfoSourceType.update_all(enable: 0)
    InfoSourceType.update_all(['enable=?','1'],:id =>params[:info_source_type_ids])
    setSettingStatus(true)
    redirect_to :action => "index"
  end


  def get_all_infos(hotid)
      hot = Hot.find(hotid)

      query1=""
      hot.has_keywords.split(",").each do |k|
          query1 = query1 + k + "+"
      end
      query1 = query1[0,query1.length-1]

      results2=[]
      hot.any_keywords.split(",").each do |k|
        tempresults2 = ThinkingSphinx.search k , 
                      :match_mode => :phrase,
                      :classes => InfoCommon.subclasses,
                      :limit => 100000
        results2 = results2.compact.to_ary | tempresults2.compact.to_ary
      end
      

      query3=""
      hot.without_keywords.split(",").each do |k|
          query3 = query3 + k + "+"
      end
      query3 = query3[0,query3.length-1]


      
      results1=[]
      unless query1.blank?
        results1 = ThinkingSphinx.search query1 , 
                    :match_mode => :phrase,
                    :classes => InfoCommon.subclasses,
                    :limit => 100000
      end
      
      results3=[]
      unless query3.blank?
        results3 = ThinkingSphinx.search query3 , 
                    :match_mode => :phrase,
                    :classes => InfoCommon.subclasses,
                    :limit => 100000
      end
      results = (results1.compact.to_ary | results2.compact.to_ary)-results3.compact.to_ary
    end

  private
    def setSettingStatus(status)
      if status
        SiteInfo.update_all(['value=?',1],:key =>'HASSETTING')
      end
    end

  def has_setting?
    SiteInfo.where(:key => "HASSETTING").first.value.to_i == 1
  end
end
