# -*- encoding : utf-8 -*-
class BlogPost < ActiveRecord::Base
  attr_accessible :blog_user_screen_name, :comment_count, :content, :read_count, :title, :urgency, :url ,:sentiment,:created_at

  include InfoCommon
  def extract_meaningful_content
    title + content

  end

  define_index do
    indexes content
    indexes title
    

    has sentiment
    has created_at
    has urgency
    #where "created_at > '#{3.days.ago}'"
  end

end
