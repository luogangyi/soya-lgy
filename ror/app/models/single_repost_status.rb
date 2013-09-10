# -*- encoding : utf-8 -*-
class SingleRepostStatus < ActiveRecord::Base
  attr_accessible :attitudes_count, :comments_count, :created_at, :direct_reposts_count, :origin_id, :parent_origin_id, :pic, :repost_depth, :reposts_count, :single_source_status, :single_weibo_user, :source_app, :text, :url
end
