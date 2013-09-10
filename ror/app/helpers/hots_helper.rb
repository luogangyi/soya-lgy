# -*- encoding : utf-8 -*-
module HotsHelper
	def hots_num
		hots_num = Hot.all.count
	end

	def hot_today_num(theid)
		hot_results = get_all_infos(theid)
  		starttime = Time.now.at_beginning_of_day-8.hour
  		endtime = Time.now-8.hour
  		hot_today_num = hot_results.find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db)}.count
	end

	def hot_total_num(theid)
		hot = Hot.find(theid)
		
  		starttime = hot.start_at-8.hour
  		endtime = Time.now-8.hour
  		
		hot_results = get_all_infos(theid)

  		hot_today_num = hot_results.find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db)}.count
	end




	def total_num_each_day
		total_num_each_day=""
		hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])

		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000) - 8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000) - 8.hour : hot.end_at


  		days_num = ((endtime - starttime)/1.day).to_i + 1 



  		if days_num > 4
  			for i in 0..days_num-1 do
  				total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.day).to_s(:db) && info.created_at < (starttime+(i+1).day).to_s(:db)}.count
  				total_num_each_day+=total_count_day.to_s+","
		  	end
	  	else
			for i in 0..days_num*24-1 do
		      	total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.hour).to_s(:db) && info.created_at < (starttime+(i+1).hour).to_s(:db)}.count
  				total_num_each_day+=total_count_day.to_s+","
		  	end

	  	end
		total_num_each_day = total_num_each_day[0,total_num_each_day.length-1] 		
	end

	def total_num_each_day_negative
		total_num_each_day_negative=""
		hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])

  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)- 8.hour  : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)- 8.hour  :  hot.end_at
  		days_num = ((endtime - starttime)/1.day).to_i+1


  		if days_num > 4
  			for i in 0..days_num-1 do
		  		total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.day).to_s(:db) && info.created_at < (starttime+(i+1).day).to_s(:db) && info.sentiment == 2}.count
  				total_num_each_day_negative+=total_count_day.to_s+","
		  	end
	  	else
			for i in 0..days_num*24-1 do
		  		total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.hour).to_s(:db) && info.created_at < (starttime+(i+1).hour).to_s(:db) && info.sentiment == 2}.count
		  		total_num_each_day_negative+=total_count_day.to_s+","	
		  	end

	  	end
		total_num_each_day_negative = total_num_each_day_negative[0,total_num_each_day_negative.length-1] 		
	end

	def total_num_each_day_weibo
		total_num_each_day_weibo=""
		hot = Hot.find(params[:id])

		hot_results = get_all_infos(params[:id])


		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)- 8.hour  : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)- 8.hour  : Time.now
  		days_num = ((endtime - starttime)/1.day).to_i+1


  		if days_num > 4
  			for i in 0..days_num-1 do
	      		total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.day).to_s(:db) && info.created_at < (starttime+(i+1).day).to_s(:db) && info.class.name=="WeiboStatus"}.count
	      		
	      		total_num_each_day_weibo+=total_count_day.to_s+","
		  	end
	  	else
			for i in 0..days_num*24-1 do
	      		total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.hour).to_s(:db) && info.created_at < (starttime+(i+1).hour).to_s(:db) && info.class.name=="WeiboStatus"}.count
	      		
	      		total_num_each_day_weibo+=total_count_day.to_s+","
		  	end

	  	end

		total_num_each_day_weibo = total_num_each_day_weibo[0,total_num_each_day_weibo.length-1] 		
	end

	def total_num_each_day_negative_weibo
		total_num_each_day_negative_weibo=""
		hot = Hot.find(params[:id])

		hot_results = get_all_infos(params[:id])


		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour  : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)- 8.hour  : Time.now
  		days_num = ((endtime - starttime)/1.day).to_i+1


  		if days_num > 4
  			for i in 0..days_num-1 do
	      		total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.day).to_s(:db) && info.created_at < (starttime+(i+1).day).to_s(:db) && info.class.name=="WeiboStatus" && info.sentiment == 2}.count
	      		
	      		total_num_each_day_negative_weibo+=total_count_day.to_s+","
		  	end
	  	else
			for i in 0..days_num*24-1 do
	      		total_count_day = hot_results.find_all{|info| info.created_at > (starttime+i.hour).to_s(:db) && info.created_at < (starttime+(i+1).hour).to_s(:db) && info.class.name=="WeiboStatus" && info.sentiment == 2}.count
	      		
	      		total_num_each_day_negative_weibo+=total_count_day.to_s+","
		  	end

	  	end


		total_num_each_day_negative_weibo = total_num_each_day_negative_weibo[0,total_num_each_day_negative_weibo.length-1] 		
	end




	def total_sentiment_array
		total_sentiment_array=[]
		hot = Hot.find(params[:id])
		
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour  : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour  : Time.now

		for i in 1..3 do
	  		
	      	temp_c = hot_results.find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.sentiment == i}.count

	  		total_sentiment_array.push(temp_c)

	  	end
  		
		total_sentiment_array	
	end

	def total_sentiment_weibo_array
		total_sentiment_weibo_array=[]
		hot = Hot.find(params[:id])
		
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now

		for i in 1..3 do
	  		
	      	temp_c = hot_results.find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.sentiment == i && info.class.name=="WeiboStatus"}.count

	  		total_sentiment_weibo_array.push(temp_c)

	  	end
  		
		total_sentiment_weibo_array	
	end


	def total_sex_weibo_array
		total_sex_weibo_array=[]
		hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now
		starttime = starttime - 8.hour
		endtime = endtime - 8.hour


	  	fnum = hot_results.find_all{|info|info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.class.name=="WeiboStatus" && info.weibo_user.gender == "f"}.count
	  	mnum = hot_results.find_all{|info|info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.class.name=="WeiboStatus" && info.weibo_user.gender == "m"}.count

		total_sex_weibo_array.push(fnum)
	  	total_sex_weibo_array.push(mnum)
  		
		total_sex_weibo_array	
	end

	def weibo_v_array
		weibo_v_array=[]
		hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now

		vnum = hot_results.find_all{|info|info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.class.name=="WeiboStatus" && info.weibo_user.verified == true }.count
	  	novnum = hot_results.find_all{|info|info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.class.name=="WeiboStatus" && info.weibo_user.verified == false }.count

		weibo_v_array.push(vnum)
	  	weibo_v_array.push(novnum)
  		
		weibo_v_array	
	end

	def weibo_v_array_sentiment
		weibo_v_array_sentiment=[]
		hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now


	  	weibo_v_array_sentiment.push(hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" && r.weibo_user.verified == true && r.sentiment == 1}.count)
	  	weibo_v_array_sentiment.push(hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" && r.weibo_user.verified == true && r.sentiment == 2}.count)
	  	weibo_v_array_sentiment.push(hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" && r.weibo_user.verified == true && r.sentiment == 3}.count)
  		
		weibo_v_array_sentiment	
	end


	def weibo_follows_array_str
		weibo_follows_array_str=''

		hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now

  		weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i <50 }.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 50 && r.weibo_user.follower_count.to_i < 100}.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 100 && r.weibo_user.follower_count.to_i < 200 }.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 200 && r.weibo_user.follower_count.to_i < 500 }.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 500 && r.weibo_user.follower_count.to_i < 1000 }.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 1000 && r.weibo_user.follower_count.to_i < 10000 }.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 10000 && r.weibo_user.follower_count.to_i < 50000 }.count.to_s+","
	  	weibo_follows_array_str += hot_results.find_all{|r|r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.class.name=="WeiboStatus" &&  r.weibo_user.follower_count.to_i >= 50000}.count.to_s
  		
		weibo_follows_array_str	
	end





	def total_region_num_str
	    geoProvince=["香港","海南","云南","北京","天津","新疆","西藏","青海",
	                      "甘肃","内蒙古","宁夏","山西","辽宁","吉林","黑龙江","河北",
	                      "山东","河南","陕西","四川","重庆","湖北","安徽","江苏","上海",
	                      "浙江","福建","台湾","江西","湖南","贵州","广西 ","广东"]
	    geoProvincePY=["HKG","HAI","YUN","BEJ","TAJ","XIN","TIB","QIH","GAN",
	                        "NMG","NXA","SHX","LIA","JIL","HLJ","HEB","SHD","HEN",
	                        "SHA","SCH","CHQ","HUB","ANH","JSU","SHH","ZHJ","FUJ",
	                        "TAI","JXI","HUN","GUI","GXI ","GUD"]

	    geoinfonum = []

	    hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now

	    
	    geoProvince.each_with_index do |geo , index|
	      geoinfonum.push(hot_results.find_all{|r|r.class.name=="WeiboStatus" && r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) &&  r.geo_info_province == geo}.count)
	    end
	    geoInfo="[{"
	    geoInfo += "cha: 'OTHER', name: '其他', des: '<br/>无' }"
	    geoProvince.each_with_index do |geo , index|
	      geoInfo= geoInfo + ",{cha: '"+geoProvincePY[index]+"', name: '"+geoProvince[index]+"', des: '<br/>"+(geoinfonum[index]>0 ? geoinfonum[index].to_s+"条" : "无")+"' }"
	    end
	    geoInfo +="]"
	    geoInfo.html_safe
	end



	def total_region_num_str_positive
	    geoProvince=["香港","海南","云南","北京","天津","新疆","西藏","青海",
	                      "甘肃","内蒙古","宁夏","山西","辽宁","吉林","黑龙江","河北",
	                      "山东","河南","陕西","四川","重庆","湖北","安徽","江苏","上海",
	                      "浙江","福建","台湾","江西","湖南","贵州","广西 ","广东"]
	    geoProvincePY=["HKG","HAI","YUN","BEJ","TAJ","XIN","TIB","QIH","GAN",
	                        "NMG","NXA","SHX","LIA","JIL","HLJ","HEB","SHD","HEN",
	                        "SHA","SCH","CHQ","HUB","ANH","JSU","SHH","ZHJ","FUJ",
	                        "TAI","JXI","HUN","GUI","GXI ","GUD"]

	    geoinfonum = []

	    hot = Hot.find(params[:id])

		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now
	    
	    geoProvince.each_with_index do |geo , index|
	      	geoinfonum.push(hot_results.find_all{|r|r.class.name=="WeiboStatus" && r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.geo_info_province == geo && r.sentiment ==1 }.count)
	    end

	    geoInfo="[{"
	    geoInfo += "cha: 'OTHER', name: '其他', des: '<br/>无' }"
	    geoProvince.each_with_index do |geo , index|
	      geoInfo= geoInfo + ",{cha: '"+geoProvincePY[index]+"', name: '"+geoProvince[index]+"', des: '<br/>"+(geoinfonum[index]>0 ? geoinfonum[index].to_s+"条" : "无")+"' }"
	    end
	    geoInfo +="]"
	    geoInfo.html_safe
	end


	def total_region_num_str_negative
	    geoProvince=["香港","海南","云南","北京","天津","新疆","西藏","青海",
	                      "甘肃","内蒙古","宁夏","山西","辽宁","吉林","黑龙江","河北",
	                      "山东","河南","陕西","四川","重庆","湖北","安徽","江苏","上海",
	                      "浙江","福建","台湾","江西","湖南","贵州","广西 ","广东"]
	    geoProvincePY=["HKG","HAI","YUN","BEJ","TAJ","XIN","TIB","QIH","GAN",
	                        "NMG","NXA","SHX","LIA","JIL","HLJ","HEB","SHD","HEN",
	                        "SHA","SCH","CHQ","HUB","ANH","JSU","SHH","ZHJ","FUJ",
	                        "TAI","JXI","HUN","GUI","GXI ","GUD"]

	    geoinfonum = []

	    hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : Time.now
	    
	    geoProvince.each_with_index do |geo , index|
	      	geoinfonum.push(hot_results.find_all{|r|r.class.name=="WeiboStatus" && r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.geo_info_province == geo && r.sentiment ==2 }.count)
	    end


	    geoInfo="[{"
	    geoInfo += "cha: 'OTHER', name: '其他', des: '<br/>无' }"
	    geoProvince.each_with_index do |geo , index|
	      geoInfo= geoInfo + ",{cha: '"+geoProvincePY[index]+"', name: '"+geoProvince[index]+"', des: '<br/>"+(geoinfonum[index]>0 ? geoinfonum[index].to_s+"条" : "无")+"' }"
	    end
	    geoInfo +="]"
	    geoInfo.html_safe
	end

	def total_region_num_str_neutral
	    geoProvince=["香港","海南","云南","北京","天津","新疆","西藏","青海",
	                      "甘肃","内蒙古","宁夏","山西","辽宁","吉林","黑龙江","河北",
	                      "山东","河南","陕西","四川","重庆","湖北","安徽","江苏","上海",
	                      "浙江","福建","台湾","江西","湖南","贵州","广西 ","广东"]
	    geoProvincePY=["HKG","HAI","YUN","BEJ","TAJ","XIN","TIB","QIH","GAN",
	                        "NMG","NXA","SHX","LIA","JIL","HLJ","HEB","SHD","HEN",
	                        "SHA","SCH","CHQ","HUB","ANH","JSU","SHH","ZHJ","FUJ",
	                        "TAI","JXI","HUN","GUI","GXI ","GUD"]

	    geoinfonum = []

	    hot = Hot.find(params[:id])
		hot_results = get_all_infos(params[:id])


  		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000) -8.hour : Time.now
	    
	    geoProvince.each_with_index do |geo , index|
	      	geoinfonum.push(hot_results.find_all{|r|r.class.name=="WeiboStatus" && r.created_at > starttime.to_s(:db) && r.created_at < endtime.to_s(:db) && r.geo_info_province == geo && r.sentiment ==3 }.count)
	    end


	    geoInfo="[{"
	    geoInfo += "cha: 'OTHER', name: '其他', des: '<br/>无' }"
	    geoProvince.each_with_index do |geo , index|
	      geoInfo= geoInfo + ",{cha: '"+geoProvincePY[index]+"', name: '"+geoProvince[index]+"', des: '<br/>"+(geoinfonum[index]>0 ? geoinfonum[index].to_s+"条" : "无")+"' }"
	    end
	    geoInfo +="]"
	    geoInfo.html_safe
	end




	def myxAxis1
		hot = Hot.find(params[:id])
		myxAxis1=""
		starttime = params["starttime"] ? Time.at(params["starttime"].to_i/1000)-8.hour : hot.start_at
		endtime = params["endtime"] ? Time.at(params["endtime"].to_i/1000)-8.hour : hot.end_at

  		days_num = ((endtime - starttime)/1.day).to_i+1


  		if days_num > 4
			for i in 0..days_num-1 do  
	      		myxAxis1 += (starttime + i.day).strftime("'%m-%d',")
	  		end
	  	else
	  		for i in 0..(days_num*24-1) do  
	      		myxAxis1 += (starttime + i.hour).strftime("'%m-%d %H:00',")
	  		end
	  	end
	  	myxAxis1=myxAxis1[0,myxAxis1.length-1]
	end


	def hot_time
		hot = Hot.find(params[:id])
		if params["starttime"]
			hot_time = Time.at(params["starttime"].to_i/1000).to_s(:db)[0..9] + "~" +Time.at(params["endtime"].to_i/1000).to_s(:db)[0..9]
		else 
			hot_time = hot.start_at.localtime.to_s(:db)[0..9] + "~" + Time.now.localtime.to_s(:db)[0..9]
		end
		hot_time
	end

	def hot_time_s
		hot = Hot.find(params[:id])
		if params["starttime"]
			hot_time_s = Time.at(params["starttime"].to_i/1000).to_s(:db)[0..9]
		else 
			hot_time_s = hot.start_at.localtime.to_s(:db)[0..9]
		end
		hot_time_s
	end

	def hot_time_e
		hot = Hot.find(params[:id])
		if params["starttime"]
			hot_time_e = Time.at(params["endtime"].to_i/1000).to_s(:db)[0..9]
		else 
			hot_time_e = hot.end_at.localtime.to_s(:db)[0..9]
		end
		hot_time_e
	end


	def get_all_infos(hotid)
	    hot = Hot.find(hotid)

	    query1=""
	    hot.has_keywords.split(",").each do |k|
	        query1 = query1 + k + "+"
	    end
	    query1 = query1[0,query1.length-1]

	    results2=[]
	    hot.any_keywords.split(",").each do |k|
 			tempresults2 = ThinkingSphinx.search k , 
	                  :classes => InfoCommon.subclasses,
                      :match_mode => :phrase,
	                  :limit => 100000
	        results2 = results2.compact.to_ary | tempresults2.compact.to_ary
	    end
	    

	    query3=""
	    hot.without_keywords.split(",").each do |k|
	        query3 = query3 + k + "+"
	    end
	    query3 = query3[0,query3.length-1]


	    
	    results1=[]
	    unless query1.blank?
	      results1 = ThinkingSphinx.search query1 , 
	                  :classes => InfoCommon.subclasses,
                      :match_mode => :phrase,
	                  :limit => 100000
	    end
	    
	    results3=[]
	    unless query3.blank?
	      results3 = ThinkingSphinx.search query3 , 
	                  :classes => InfoCommon.subclasses,
                      :match_mode => :phrase,
	                  :limit => 100000
	    end
	    results = (results1.compact.to_ary | results2.compact.to_ary)-results3.compact.to_ary
  	end



end
