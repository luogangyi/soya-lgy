# -*- encoding : utf-8 -*-
module ApplicationHelper
  def alert_num
    alert_num = 0
    InfoCommon.subclasses.each do |info|
      alert_num += info.joins(:operation).where(:operations => {:handled_alert => 0,:ignored_alert => 0, :ignored => false},:urgency => 3..5).count
    end
    alert_num
  end

  def message_num
    alert_num = 0
    InfoCommon.subclasses.each do |info|
      alert_num += info.joins(:operation).where(:operations => {:handled_alert => 0,:ignored_alert => 0, :ignored => false},:urgency => 3..5).count
    end
    alert_num    
  end

  def monitor_num
    monitor_num = MonitoringWeiboStatus.where("expiring_at >= :now", {:now => Time.now }).count 
  end


  def keywords
    keywords = ""
    tempkeywords=Keyword.where(:enable => true)
    tempkeywords.each_with_index do |keyword, index|
      if index == tempkeywords.size - 1
        keywords += keyword.str 
      else
        keywords += (keyword.str + ",")
      end 
    end
    keywords
  end

  def categories
    categories = ""
    tempcategories=Category.where("str_en<>'sentiment'")
    tempcategories.each_with_index do |category, index|
      if index == tempcategories.size - 1
        categories += category.str 
      else
        categories += (category.str + ",")
      end 
    end
    categories
  end

  def site_ip
    SiteInfo.where(:key => "IP").first.value
  end

  def site_port
    SiteInfo.where(:key => "PORT").first.value
  end

  def site_name
    SiteInfo.where(:key => "NAME").first.value
  end

  def has_opponent?
    SiteInfo.where(:key => "HASOPPONENT").first.value.to_i == 1
  end

  def has_setting?
    SiteInfo.where(:key => "HASSETTING").first.value.to_i == 1
  end

  def has_email_alert?
    SiteInfo.where(:key => "HASEMAILALERT").first.value.to_i == 1
  end

  def has_sms_alert?
    SiteInfo.where(:key => "HASSMSALERT").first.value.to_i == 1
  end

  def phpreporturl
    SiteInfo.where(:key => "PHPREPORTURL").first.value
  end

  def is_admin?
    current_admin.username == "Admin"
  end

  def is_HK?
    SiteInfo.where(:key => "ISHK").first != nil
  end


end
 
