# -*- encoding : utf-8 -*-
module AlertHelper
	STRING_TO_INFO_MAPPER = {
	    'weibo' => 'WeiboStatus',
	    'wiki' => 'WikiPost',
	    'bbs' => 'BbsPost',
	    'blog' => 'BlogPost',
	    'video' => 'VideoPost',
	    'news' => 'News'
  	}

	def unhandle_alert_num
		unhandle_alert_num=0
		InfoCommon.subclasses.each do |info|
      		unhandle_alert_num += info.joins(:operation).where(:operations => {:ignored => false ,:handled_alert => false,:ignored_alert => false},:urgency=>3..5).count
      	end
      	unhandle_alert_num
	end

	def handled_alert_num
		handled_alert_num=0
		InfoCommon.subclasses.each do |info|
      		handled_alert_num += info.joins(:operation).where(:operations => {:ignored => false ,:handled_alert => true  ,:ignored_alert => false},:urgency=>3..5).count 
      	end
      	handled_alert_num
	end

	def ignored_alert_num
		ignored_alert_num=0
		InfoCommon.subclasses.each do |info|
      		ignored_alert_num += info.joins(:operation).where(:operations => {:ignored => false ,:ignored_alert => true },:urgency=>3..5).count
      	end
      	ignored_alert_num		
	end


	def userlist
		Admin.all
	end


	def last_error(info_source_id)
		JobError.where(:info_source_id=>info_source_id).last
	end

	def last_job(info_source_id)
		Job.where(:info_source_id=>info_source_id).last
	end

	def has_error(info_source_id)
		has_error = false
		if last_job(info_source_id) == nil
			has_error = true
		else
			if last_error(info_source_id) && last_job(info_source_id).previous_executed < last_error(info_source_id).happened_at
				has_error = true
			end
		end
		has_error
	end



	# def maillist
	# 	maillist=[]
	# 	Admin.all.each do |admin|
	# 		maillist.push(admin.email)
	# 	end
	# 	maillist
	# end

	# def smslist
	# 	smslist=[]
	# 	Admin.all.each do |admin|
	# 		smslist.push(admin.phone)
	# 	end
	# 	smslist
	# end

	
end
