# -*- encoding : utf-8 -*-
class InfoSourceType < ActiveRecord::Base
  attr_accessible :enstr, :str,:enable
  has_many :info_sources
end
