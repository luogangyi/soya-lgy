# -*- encoding : utf-8 -*-
class WeiboUser < ActiveRecord::Base
  attr_accessible :follower_count, :following_count, :gender, :geo_info_city, :geo_info_province, :profile_image_url, :screen_name, :status_count, :user_origin_id, :verified

  belongs_to :info_source
  has_many :weibo_statuses
end
