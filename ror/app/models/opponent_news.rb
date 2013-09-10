# -*- encoding : utf-8 -*-
class OpponentNews < ActiveRecord::Base
  belongs_to :info_source
  belongs_to :opponent_keyword
  attr_accessible :content, :source_name, :title
end
