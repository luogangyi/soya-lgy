# -*- encoding : utf-8 -*-
class WikiPost < ActiveRecord::Base
  attr_accessible :sentiment,:urgency, :title,:content,:created_at

  include InfoCommon
  def extract_meaningful_content
    title + content
  end


  define_index do
    indexes content
    indexes title
    

    has sentiment
    has urgency
    has created_at
  end
end
