# -*- encoding : utf-8 -*-
#encoding : utf-8
module OverviewHelper

  def overview_info_nums
  	overview_infonums=""
  	for i in 0..24 do  
  		total_count_hour=0
  		InfoCommon.subclasses.each do |info|
      		total_count_hour += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => ((Time.now - (24-i).hour).strftime("%Y-%m-%d %H:00:00")..(Time.now - (23-i).hour).strftime("%Y-%m-%d %H:00:00"))})
      	end
      	overview_infonums+=(Time.now - (24-i).hour).strftime("%m-%d %H:00,")+total_count_hour.to_s+";"
  	end
  	overview_infonums=overview_infonums[0,overview_infonums.length-1]+""   
  end


  def overview_info_nagtive_nums
  	overview_info_nagtive_nums=""
  	for i in 0..24 do  
  		total_count_hour=0
  		InfoCommon.subclasses.each do |info|
      		total_count_hour += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => ((Time.now - (24-i).hour).strftime("%Y-%m-%d %H:00:00")..(Time.now - (23-i).hour).strftime("%Y-%m-%d %H:00:00")),:sentiment => 2})
      	end
      	overview_info_nagtive_nums+=(Time.now - (24-i).hour).strftime("%m-%d %H:00,")+total_count_hour.to_s+";"
  	end
  	overview_info_nagtive_nums=overview_info_nagtive_nums[0,overview_info_nagtive_nums.length-1]+""   
  end


  def weibo_count
    weibo_count = WeiboStatus.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour})
  end

  def new_count
    new_count = News.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour})
  end

  def bbs_count
    bbs_count = BbsPost.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour})
  end


#航空公司 中间四个数字
  def n1
    n1 = WeiboStatus.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour})
  end

  def n2
    n2 = WeiboStatus.joins(:operation).joins(:analysis_categorizeds).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour,:analysis_categorizeds=>{:label_id => 2}})
  end

  def n3
    n3 = WeiboStatus.joins(:operation).joins(:analysis_categorizeds).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour,:analysis_categorizeds=>{:label_id => 10}})
  end

  def n4
    n4 = n1 - n2 - n3
  end

  def n1_c
    n1_b = WeiboStatus.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour})
    n1_c = n1 > n1_b ? "up" : "down"
  end

  def n2_c
    n2_b = WeiboStatus.joins(:operation).joins(:analysis_categorizeds).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour,:analysis_categorizeds=>{:label_id => 2}})
    n2_c = n2 > n2_b ? "up" : "down"
  end

  def n3_c
    n3_b = WeiboStatus.joins(:operation).joins(:analysis_categorizeds).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour,:analysis_categorizeds=>{:label_id => 10}})
    n3_c = n3 > n3_b ? "up" : "down"
  end

  def n4_c
    n4_b = n1_b - n2_b - n3_b
    n4_c = n4 > n4_b ? "up" : "down"
  end






  def info_total_count
    total_count = 0
    InfoCommon.subclasses.each do |info|
      total_count += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour})
    end
    total_count
  end

  def weibo_count_c
    weibo_count2 = WeiboStatus.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour})
    weibo_count_c = weibo_count > weibo_count2 ? "up" : "down"
  end

  def new_count_c
    new_count2 = News.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour})
    new_count_c = new_count > new_count2 ? "up" : "down"
  end

  def bbs_count_c
    bbs_count2 = BbsPost.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour})
    bbs_count_c = bbs_count > bbs_count2 ? "up" : "down"
  end

  def info_total_count_c
    total_count2 = 0
    InfoCommon.subclasses.each do |info|
      total_count2 += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 2.day).end_of_hour..(Time.now - 1.day).end_of_hour})
    end

    info_total_count_c = info_total_count > total_count2 ? "up" : "down"
  end

  def info_positive_num
    info_positive_num = 0
    InfoCommon.subclasses.each do |info|
      info_positive_num += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour,:sentiment => 1})
    end
    info_positive_num  
  end

  def info_neutral_num
     info_neutral_num = 0
    InfoCommon.subclasses.each do |info|
      info_neutral_num += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour,:sentiment => 3})
    end
    info_neutral_num 
  end

  def info_negative_num
    info_negative_num = 0
    InfoCommon.subclasses.each do |info|
      info_negative_num += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour,:sentiment => 2})
    end
    info_negative_num 
  end

  def dataStatus
    geoProvince=["香港","海南","云南","北京","天津","新疆","西藏","青海",
                      "甘肃","内蒙古","宁夏","山西","辽宁","吉林","黑龙江","河北",
                      "山东","河南","陕西","四川","重庆","湖北","安徽","江苏","上海",
                      "浙江","福建","台湾","江西","湖南","贵州","广西 ","广东"]
    geoProvincePY=["HKG","HAI","YUN","BEJ","TAJ","XIN","TIB","QIH","GAN",
                        "NMG","NXA","SHX","LIA","JIL","HLJ","HEB","SHD","HEN",
                        "SHA","SCH","CHQ","HUB","ANH","JSU","SHH","ZHJ","FUJ",
                        "TAI","JXI","HUN","GUI","GXI ","GUD"]

    geoinfonum = []
    
    geoProvince.each_with_index do |geo , index|
      geoinfonum.push(WeiboStatus.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour, :geo_info_province => geo}))
    end

    geoInfo="[{"
    geoInfo += "cha: 'OTHER', name: '其他', des: '<br/>无舆情信息' }"
    geoProvince.each_with_index do |geo , index|
      geoInfo= geoInfo + ",{cha: '"+geoProvincePY[index]+"', name: '"+geoProvince[index]+"', des: '<br/>"+(geoinfonum[index]>0 ? geoinfonum[index].to_s+"条" : "无相关")+"舆情信息' }"
    end
    geoInfo +="]"
    geoInfo.html_safe
  end


  def tagcloud
    tagcloud = URI::encode "<tags>"
    keyword_ids = WeiboStatus.select(:keyword_id).joins(:operation).where(:operations => {:ignored => 0},:created_at => (Time.now - 1.day).end_of_hour..Time.now.end_of_hour).uniq
    keyword_strs=[]
    keyword_ids.each do |keyword_id|
      keyword_strs.push(Keyword.find(keyword_id.keyword_id))
    end

    keyword_strs.each do |keyword_str|
      tempstr = "<a href='#' class='tag-link-26' title='" + keyword_str.str + "' style='font-size:11pt;'>" + keyword_str.str + "</a>"
      tagcloud += URI::encode tempstr
    end
    
    tagcloud+=URI::encode "</tags>"
  end
end
