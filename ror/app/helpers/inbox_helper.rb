# -*- encoding : utf-8 -*-
module InboxHelper

	STRING_TO_INFO_MAPPER = {
	    'weibo' => 'WeiboStatus',
	    'wiki' => 'WikiPost',
	    'bbs' => 'BbsPost',
	    'blog' => 'BlogPost',
	    'video' => 'VideoPost',
	    'news' => 'News'
  	}


	def unhandle_num
		unhandle_num = Operation.where(:handled => false,:ignored => false ,:operatable_type => STRING_TO_INFO_MAPPER[params[:info_type]]).count
	end

	def handled_num
		handled_num = Operation.where(:handled => true  ,:ignored => false , :operatable_type => STRING_TO_INFO_MAPPER[params[:info_type]]).count # get_info_count_by_operation_conditions({:handled => true} , WeiboStatus.class)
	end

	def ignored_num
		ignored_num = Operation.where(:ignored => true , :operatable_type => STRING_TO_INFO_MAPPER[params[:info_type]]).count#WeiboStatus.where(:ignored => 1).count
	end


  	def monitoring_num
    	MonitoringWeiboStatus.where("expiring_at >= :now", {:now => Time.now }).count
  	end

  	def monitor_history_num
    	MonitoringWeiboStatus.where("expiring_at < :now", {:now => Time.now }).count
  	end




	def unhandle_num_label
		unhandle_num = WeiboStatus.joins(:analysis_categorizeds).joins(:operation).count(:conditions=>{:operations => {:handled => false , :ignored => false},:analysis_categorizeds=>{:label_id => params[:label_id].to_i}}) #Operation.where(:handled => false,:ignored => false ,:operatable_type => STRING_TO_INFO_MAPPER[params[:info_type]]).count
	end

	def handled_num_label
		handled_num = WeiboStatus.joins(:analysis_categorizeds).joins(:operation).count(:conditions=>{:operations => {:handled => true , :ignored => false},:analysis_categorizeds=>{:label_id => params[:label_id].to_i}}) #Operation.where(:handled => true  ,:ignored => false , :operatable_type => STRING_TO_INFO_MAPPER[params[:info_type]]).count # get_info_count_by_operation_conditions({:handled => true} , WeiboStatus.class)
	end

	def ignored_num_label
		ignored_num = WeiboStatus.joins(:analysis_categorizeds).joins(:operation).count(:conditions=>{:operations => {:ignored => true},:analysis_categorizeds=>{:label_id => params[:label_id].to_i}}) #Operation.where(:ignored => true , :operatable_type => STRING_TO_INFO_MAPPER[params[:info_type]]).count#WeiboStatus.where(:ignored => 1).count
	end



  	def label_categories
  		Category.where("id > 1")
  	end

  	def label_at_category(cid)
  		Label.where(:category_id => cid)
  	end

end
