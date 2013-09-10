# -*- encoding : utf-8 -*-
# common InfoSource utilities
module InfoCommon 
  extend ActiveSupport::Concern

  # common fields
  included do
    belongs_to :keyword
    belongs_to :info_source

    has_many :analysis_categorizeds, :as => :analysable, :autosave => true, :dependent => :destroy
    has_one :operation, :as => :operatable, :autosave => true, :dependent => :destroy
  end

  # common methods
  def extract_meaningful_content
    raise NotImplementedError
  end


  def labels
      analysis_categorizeds.where(:category_id => Category.labels_category)
  end


  def sentiment_in_c
    analysis_categorizeds.where(:category_id => Category.sentiment_category).first
  end

  def sentiment_str
    if self.sentiment==0
      "未知"
    else 
      Label.find(self.sentiment).str
    end
  end


  def sentiment_enstr
    if self.sentiment==0
      "neutral"
    else 
      Label.find(self.sentiment).enstr
    end
  end


  def ignore_str
    self.operatable.ignored == 0 ? "ignore" : "unignore"
  end


  def messinfo
    messinfo = ""
    uname = ""
    if self.info_source.info_source_type.enstr == "weibo"
      uname += self.weibo_user.verified ? "v" : ''
      uname += self.weibo_user_screen_name 
    else 
      uname += "有一名网友"
    end
    info_content=""
    if self.info_source.info_source_type.enstr == "weibo"
      info_content +=  self.weibo_user_screen_name + ":" + self.text
      
    else
      info_content += self.title
    end

    source_name = ""
    site_name = SiteInfo.where(:key => "NAME").first.value
    source_name += self.info_source.info_source_type.enstr == "news" ? self.source_name : self.info_source.str
    messinfo += site_name+":"+ (self.created_at).strftime("%m月%d日 %H时%M分")+",“"+ uname 
    messinfo += "”在“" + source_name +"”上发布一条预警等级信息较高的信息\n\n"
    messinfo += info_content + "\n\n该信息被"
    if self.info_source.info_source_type.enstr == "weibo"
      messinfo += "转发"+ self.repost_count.to_s + "次，被评论" + self.comment_count.to_s + "次"
    elsif self.info_source.info_source_type.enstr == "news"
      messinfo += ""
    elsif self.info_source.info_source_type.enstr == "video_posts"
      messinfo += "观看"+self.watch_count.to_s + "次，被评论" + self.comment_count.to_s + "次"
    else
      messinfo += "阅读"+self.read_count.to_s + "次，被评论" + self.comment_count.to_s + "次"
    end
    if self.urgency == 1
      messinfo += "，一般级别"
    elsif self.urgency == 2
      messinfo += "，关注级别"
    elsif self.urgency == 3
      messinfo += "，干预级别"
    elsif self.urgency == 4
      messinfo += "，危机级别"
    else
      messinfo += "，重大危机级别"
    end


  end

  @@subclasses = nil
  def self.subclasses
    if @@subclasses.nil?
      WeiboStatus.name
      @@subclasses = []
      ObjectSpace.each_object(Module) do |klass|
        @@subclasses << klass if self > klass
      end
    end
    @@subclasses
  end
end
