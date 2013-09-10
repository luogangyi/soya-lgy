# -*- encoding : utf-8 -*-
class VideoPost < ActiveRecord::Base
  attr_accessible :comment_count, :down_count, :repost_count, :title, :up_count, :urgency, :video_user_screen_name, :watch_count ,:sentiment,:created_at,:source_name

  include InfoCommon
  def extract_meaningful_content
    title
  end

  define_index do
    indexes content
    indexes title

    
    has sentiment
    has created_at
    has urgency
  end

end
