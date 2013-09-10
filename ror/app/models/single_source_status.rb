# -*- encoding : utf-8 -*-
class SingleSourceStatus < ActiveRecord::Base
  attr_accessible :attitudes_count, :comments_count, :created_at, :origin_id, :pic, :reposts_count, :single_weibo_user, :source_app, :text, :url
end
