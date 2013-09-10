# -*- encoding : utf-8 -*-
class BbsPost < ActiveRecord::Base
  attr_accessible :comment_count, :content, :read_count, :title, :urgency, :url ,:sentiment,:created_at
  
  define_index do
    indexes content
    indexes title
    #where "created_at > '#{3.days.ago}'"
    

    has sentiment
    has created_at
    has urgency
  end

  include InfoCommon
  def extract_meaningful_content
    title + content
  end

end
