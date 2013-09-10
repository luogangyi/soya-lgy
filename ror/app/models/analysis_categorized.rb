# -*- encoding : utf-8 -*-
class AnalysisCategorized < ActiveRecord::Base
  belongs_to :analysable
  belongs_to :category
  belongs_to :label
  # attr_accessible :title, :body

  # t1.analysable_type.constantize.find(t1.analysable_id)


  def theinfo
  	self.analysable_type.constantize.find(self.analysable_id)
  end

end
