# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base


  protect_from_forgery

  layout :layout
  
  before_filter :authenticate_admin! , :make_action_mailer_use_request_host_and_protocol

  STRING_TO_INFO_MAPPER = {
    'weibo' => 'WeiboStatus',
    'wiki' => 'WikiPost',
    'bbs' => 'BbsPost',
    'blog' => 'BlogPost',
    'news' => 'News',
    'video' => 'VideoPost'
  }



  

  def get_info_class_by_name(info_name)
    class_name = STRING_TO_INFO_MAPPER[info_name]
    class_name.constantize
  end

  def get_analysis_categorized_class_by_info(info_class)
    "#{info_class.name}AnalysisCategorized".constantize
  end

  def get_info_count_by_operation_conditions(conds, info_class)
    conds.merge!(:operatable_type => info_class.name)
    Operation.where(conds).count
  end

  private

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : "application"
    # or turn layout off for every devise controller:
    !devise_controller? && "application"
  end
  

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  

end
