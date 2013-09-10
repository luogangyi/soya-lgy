# -*- encoding : utf-8 -*-
class JobError < ActiveRecord::Base
  belongs_to :info_source
  attr_accessible :happened_at
end
