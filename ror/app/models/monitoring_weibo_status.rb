# -*- encoding : utf-8 -*-
class MonitoringWeiboStatus < ActiveRecord::Base
  belongs_to :weibo_status
  
  # attr_accessible :title, :body
end
