# -*- encoding : utf-8 -*-
class InfoSource < ActiveRecord::Base
  attr_accessible :period, :str ,:user_url

  has_many :weibo_statuses
  has_many :wiki_posts
  belongs_to :info_source_type

end
