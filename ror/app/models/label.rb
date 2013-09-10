# -*- encoding : utf-8 -*-
class Label < ActiveRecord::Base
  attr_accessible :str
  
  belongs_to :category
  has_many :analysis_categorizeds, :dependent => :destroy
  public 
	def getIdSymbol
	  	key_id = 'Label_'+id.to_s
	  	return key_id.to_sym
	end

end
