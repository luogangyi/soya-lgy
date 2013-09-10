# -*- encoding : utf-8 -*-
class Job < ActiveRecord::Base
  belongs_to :info_source
  attr_accessible :fetched_info_count, :previous_executed, :real_fetched_info_count
end
