# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  attr_accessible :by_keyword, :str

  has_many :labels

  def self.sentiment_category
    Category.where(:str_en => 'sentiment').first
  end

  def self.labels_category
    Category.where(:str_en => 'labels').first
  end

  public
	  def getIdSymbol
	  	key_id = 'Category_'+id.to_s
	  	return key_id.to_sym
	  end
end
