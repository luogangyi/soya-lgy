# -*- encoding : utf-8 -*-
module DashboardHelper

	def get_infos_count_by_time(d1,d2)
		tempcount = 0 
		InfoCommon.subclasses.each do |info|
			tempcount += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => d1..d2})
	    end
	    tempcount
	end

	def get_infos_count_by_time_and_label(d1,d2,label)
		tempcount = 0 
		InfoCommon.subclasses.each do |info|
			tempcount += info.joins(:analysis_categorizeds).joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => d1..d2,:analysis_categorizeds=>{:label_id => label.id}})
	    end
	    tempcount
	end

	def get_infos_count_by_time_and_label_and_sentiment(d1,d2,label,sentiment)
		tempcount = 0 
		InfoCommon.subclasses.each do |info|
			tempcount += info.joins(:analysis_categorizeds).joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => d1..d2,:sentiment=> sentiment,:analysis_categorizeds=>{:label_id => label.id}})
	    end
	    tempcount
	end
	

	def get_infos_count_by_time_and_sentiment(d1,d2,sentiment)
		tempcount = 0 
		InfoCommon.subclasses.each do |info|
			tempcount += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => d1..d2,:sentiment=> sentiment})
	    end
	    tempcount
	end

	def get_infos_count_by_time_and_urgency(d1,d2,urgency)
		tempcount = 0 
		InfoCommon.subclasses.each do |info|
			tempcount += info.joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => d1..d2,:urgency=> urgency})
	    end
	    tempcount
	end

	def get_infos_count_by_time_and_label_and_urgency(d1,d2,label,urgency)
		tempcount = 0 
		InfoCommon.subclasses.each do |info|
			tempcount += info.joins(:analysis_categorizeds).joins(:operation).count(:conditions=>{:operations => {:ignored => 0},:created_at => d1..d2,:urgency=> urgency,:analysis_categorizeds=>{:label_id => label.id}})
	    end
	    tempcount
	end

	def dashboard_info_nums

		dashboard_info_nums=""
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime= time.at_beginning_of_month
			endtime =  time.at_end_of_month
			days_num = Time.days_in_month(time.month)-1
		else
			starttime= Time.now.at_beginning_of_month
			endtime =  Time.now.end_of_day
			days_num = Time.now.day
		end

		for i in 0..days_num-1 do  
	  		total_count_hour =  get_infos_count_by_time(starttime+i.day,starttime+(i+1).day) #infos.find_all{|info| info.created_at > (endtime-(days_num-i).day).to_s(:db) && info.created_at < (endtime - (days_num-1-i).day).to_s(:db)}.count
	  		dashboard_info_nums+=total_count_hour.to_s+","
	  	end
	  	dashboard_info_nums=dashboard_info_nums[0,dashboard_info_nums.length-1]+""   
	end





	def dashboard_info_nums_labels_array
		dashboard_info_nums_labels_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime= time.at_beginning_of_month
			endtime =  time.at_end_of_month
			days_num = Time.days_in_month(time.month)-1
		else
			starttime= Time.now.at_beginning_of_month
			endtime =  Time.now.end_of_day
			days_num = Time.now.day
		end
		Label.where(:category_id => 2).each do |label|

			dashboard_info_nums_labels=""
			for i in 0..days_num-1 do  
		  		total_count_hour =  get_infos_count_by_time_and_label(starttime+i.day,starttime+(i+1).day,label) #  infos.find_all{|info| info.created_at > (endtime-(days_num-i).day).to_s(:db) && info.created_at < (endtime - (days_num-1-i).day).to_s(:db)}.count

		  		dashboard_info_nums_labels+=total_count_hour.to_s+","
		  	end
		  	dashboard_info_nums_labels_array.push(dashboard_info_nums_labels[0,dashboard_info_nums_labels.length-1]+"")
		end 
		dashboard_info_nums_labels_array
	end


	def dashboard_info_nums_labels_positive_array
		dashboard_info_nums_labels_positive_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime= time.at_beginning_of_month
			endtime =  time.at_end_of_month
			days_num = Time.days_in_month(time.month)-1
		else
			starttime= Time.now.at_beginning_of_month
			endtime =  Time.now.end_of_day
			days_num = Time.now.day
		end
		Label.where(:category_id => 2).each do |label|
			dashboard_info_nums_labels=""

			for i in 0..days_num-1 do  
		  		total_count_hour = get_infos_count_by_time_and_label_and_sentiment(starttime+i.day,starttime+(i+1).day,label,1)#infos.find_all{|info| info.created_at > (endtime-(days_num-i).day).to_s(:db) && info.created_at < (endtime - (days_num-1-i).day).to_s(:db) && info.sentiment == 2}.count

		  		dashboard_info_nums_labels+=total_count_hour.to_s+","
		  	end
		  	dashboard_info_nums_labels_positive_array.push(dashboard_info_nums_labels[0,dashboard_info_nums_labels.length-1]+"")
		end 
		dashboard_info_nums_labels_positive_array
	end


	def dashboard_info_nums_labels_negative_array
		dashboard_info_nums_labels_negative_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime= time.at_beginning_of_month
			endtime =  time.at_end_of_month
			days_num = Time.days_in_month(time.month)-1
		else
			starttime= Time.now.at_beginning_of_month
			endtime =  Time.now.end_of_day
			days_num = Time.now.day
		end
		Label.where(:category_id => 2).each do |label|
			dashboard_info_nums_labels=""

			for i in 0..days_num-1 do  
		  		total_count_hour = get_infos_count_by_time_and_label_and_sentiment(starttime+i.day,starttime+(i+1).day,label,2)#infos.find_all{|info| info.created_at > (endtime-(days_num-i).day).to_s(:db) && info.created_at < (endtime - (days_num-1-i).day).to_s(:db) && info.sentiment == 2}.count

		  		dashboard_info_nums_labels+=total_count_hour.to_s+","
		  	end
		  	dashboard_info_nums_labels_negative_array.push(dashboard_info_nums_labels[0,dashboard_info_nums_labels.length-1]+"")
		end 
		dashboard_info_nums_labels_negative_array
	end

    def dashboard_info_nums_labels_positive_T
    	dashboard_info_nums_labels_positive_T=""

		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime= time.at_beginning_of_month
			endtime =  time.at_end_of_month
			days_num = Time.days_in_month(time.month)-1
		else
			starttime= Time.now.at_beginning_of_month
			endtime =  Time.now.end_of_day
			days_num = Time.now.day
		end

		for i in 0..days_num-1 do  
	  		total_count_hour = get_infos_count_by_time_and_sentiment(starttime+i.day,starttime+(i+1).day,1)#infos.find_all{|info| info.created_at > (endtime-(days_num-i).day).to_s(:db) && info.created_at < (endtime - (days_num-1-i).day).to_s(:db) && info.sentiment == 1}.count
	  		dashboard_info_nums_labels_positive_T+=total_count_hour.to_s+","
	  	end
		dashboard_info_nums_labels_positive_T=dashboard_info_nums_labels_positive_T[0,dashboard_info_nums_labels_positive_T.length-1]
    end


    def dashboard_info_nums_labels_negative_T
		dashboard_info_nums_labels_negative_T=""
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime= time.at_beginning_of_month
			endtime =  time.at_end_of_month
			days_num = Time.days_in_month(time.month)-1
		else
			starttime= Time.now.at_beginning_of_month
			endtime =  Time.now.end_of_day
			days_num = Time.now.day
		end

		for i in 0..days_num-1 do  
	  		total_count_hour = get_infos_count_by_time_and_sentiment(starttime+i.day,starttime+(i+1).day,2)# infos.find_all{|info| info.created_at > (endtime-(days_num-i).day).to_s(:db) && info.created_at < (endtime - (days_num-1-i).day).to_s(:db) && info.sentiment == 2}.count
	  		dashboard_info_nums_labels_negative_T+=total_count_hour.to_s+","
	  	end
		dashboard_info_nums_labels_negative_T=dashboard_info_nums_labels_negative_T[0,dashboard_info_nums_labels_negative_T.length-1]
    end

	


	def labels_info_nums_total_sentiment
		labels_info_nums_total_sentiment=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end
		for i in 1..3 do  
	  		total_count_hour=0
	  		InfoCommon.subclasses.each do |info|
	      		total_count_hour += get_infos_count_by_time_and_sentiment(starttime,endtime,i)#info.joins(:operation).where(:operations => {:ignored => 0},:created_at => starttime..endtime ,:sentiment=> i).count
	      	end
	      	labels_info_nums_total_sentiment.push(total_count_hour)
		end
		labels_info_nums_total_sentiment
	end


	def labels_info_nums_positive_array
		labels_info_nums_positive_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end
		Label.where(:category_id => 2).each do |label|
	  		total_count_hour=get_infos_count_by_time_and_label_and_sentiment(starttime,endtime,label,1)

	 
	      	labels_info_nums_positive_array.push(total_count_hour)
		end
		labels_info_nums_positive_array
	end

	def labels_info_nums_negative_array
		labels_info_nums_negative_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end
		Label.where(:category_id => 2).each do |label|
	  		total_count_hour=get_infos_count_by_time_and_label_and_sentiment(starttime,endtime,label,2)

	      	labels_info_nums_negative_array.push(total_count_hour)
		end
		labels_info_nums_negative_array

	end

	def labels_info_nums_neutral_array
		labels_info_nums_neutral_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end
		Label.where(:category_id => 2).each do |label|
	  		total_count_hour=get_infos_count_by_time_and_label_and_sentiment(starttime,endtime,label,3)

	      	labels_info_nums_neutral_array.push(total_count_hour)
		end
		labels_info_nums_neutral_array
	end


	def myxAxis
		myxAxis=""
		labels_info_nums_neutral_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			days_num = Time.days_in_month(time.month)-1
			endtime =  time.at_end_of_month
		else
			days_num = Time.now.day-1
			endtime = Time.now
		end

		for i in 0..days_num do  
	      	myxAxis+= (endtime - (days_num-i).day).strftime("'%m-%d',")
	  	end
	  	myxAxis=myxAxis[0,myxAxis.length-1]
	end


	def urgencys_day_num_array
		urgencys_day_num_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			days_num = Time.days_in_month(time.month)-1
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			days_num = Time.now.day-1
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end
		for u in 1..5 do
			tempstr=""
		  	for i in 0..days_num do  
		  		total_count_hour=get_infos_count_by_time_and_urgency(starttime+i.day,starttime+(i+1).day,u)
		      	tempstr+=total_count_hour.to_s+","
		  	end
		  	tempstr=tempstr[0,tempstr.length-1]
		  	urgencys_day_num_array.push(tempstr)
		end
	  	urgencys_day_num_array
	end

	def urgencys_mounth_num_array
		urgencys_mounth_num_array=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end
		for u in 1..5 do
	  		total_count_hour=get_infos_count_by_time_and_urgency(starttime,endtime,u)
		  	urgencys_mounth_num_array.push(total_count_hour)
		end
	  	urgencys_mounth_num_array
	end

	def urgencys_mounth_num_array_labels
		urgencys_mounth_num_array_labels=[]
		month = params["month"] ? params["month"].to_i : Time.now.month
		year = 	params["year"] ? params["year"].to_i : Time.now.year
		time = Time.now.change(:month =>month, :year =>year)
		if time.month < Time.now.month
			starttime = time.at_beginning_of_month
			endtime =  time.at_end_of_month
		else
			starttime = time.at_beginning_of_month
			endtime = Time.now
		end

		Label.where(:category_id => 2).each do |label|
			tempstr=[]
			for u in 1..5 do
		  		total_count_hour=get_infos_count_by_time_and_label_and_urgency(starttime,endtime,label,u)
		      	tempstr.push(total_count_hour)
			end
			urgencys_mounth_num_array_labels.push(tempstr)
		end
	  	urgencys_mounth_num_array_labels
	end

end
