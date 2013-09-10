# -*- encoding : utf-8 -*-
class SingleWeiboUser < ActiveRecord::Base
  attr_accessible :bi_followers_count, :city, :created_at, :description, :followers_count, :friends_count, :gender, :origin_id, :profile_image_url, :province, :screen_name, :verified_type
end
