# -*- encoding : utf-8 -*-
class LabelKeyword < ActiveRecord::Base
  belongs_to :label
  attr_accessible :str
end
