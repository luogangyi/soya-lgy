# -*- encoding : utf-8 -*-
class Keyword < ActiveRecord::Base
  attr_accessible :str,:enable

  has_many :weibo_statuses
  has_many :wiki_posts
  has_many :bbs_posts
  has_many :blog_posts
  has_many :video_posts
  has_many :news
end
