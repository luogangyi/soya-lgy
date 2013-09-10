# -*- encoding : utf-8 -*-
class SingleComment < ActiveRecord::Base
  belongs_to :single_source_status
  belongs_to :single_weibo_user
  attr_accessible :created_at, :origin_id, :source_app, :text
end
