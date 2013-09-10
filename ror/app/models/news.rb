# -*- encoding : utf-8 -*-
class News < ActiveRecord::Base
  attr_accessible :sourceName, :url ,:sentiment,:urgency,:created_at

  include InfoCommon
  def extract_meaningful_content
    content
  end

  define_index do
    indexes content
    indexes title
    

    has sentiment
    has created_at
    has urgency
  end
end
