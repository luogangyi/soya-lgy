# -*- encoding : utf-8 -*-
class WeiboStatus < ActiveRecord::Base
  attr_accessible :info_source, :text ,:sentiment ,:urgency,:created_at

  belongs_to :weibo_user

  has_one :monitoring_weibo_status

  include InfoCommon
  
  def extract_meaningful_content
    text
  end

  define_index do
    indexes text
    
    has sentiment
    has created_at
    has urgency
  end


  def calc_urgency
      user = self.weibo_user
      ugc = 0;

      #Step 1
        
    
      #Step 2

        
        
      #Step 3
      if user.verified 
        ugc = ugc + 1;
      end

      if user.follower_count > 1000000 
        ugc = ugc + 5
      elsif user.follower_count > 100000
        ugc = ugc + 4
      elsif user.follower_count > 10000
        ugc = ugc + 3
      elsif user.follower_count > 1000
        ugc = ugc + 2
      else
        ugc = ugc + 1
      end    

      if ugc >5
        ugc=5
      end  
      
      #Step 4


      sumugc = 0
      sum = self.repost_count + self.comment_count;
      if sum < 30 
        sumugc = 1
      elsif sum < 50
        sumugc = 2
      elsif sum < 100
        sumugc = 3
      elsif sum < 300
        sumugc = 4
      else
        sumugc = 5
      end
      

      calc_urgency = (ugc > sumugc) ? ugc : sumugc
  end

  def being_monitored?
    self.monitoring_weibo_status != nil
  end

end
