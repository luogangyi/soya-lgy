# -*- encoding : utf-8 -*-
require 'uri'
require 'net/http'

class AlertController < ApplicationController
  ItemPerPage = 5

  def index
  end

  def spider

    @python_tasks = PythonTask.all
    # @joblist=[]
    # Job.maximum(:id,:group => 'info_source_id').each do |temp|
    #   @joblist.push(Job.find(temp[1]))
    # end

  end

  def update_task_status
    python_task_id =  params['id']
    period_time = params['period']
    python_task_status = params['status']
    PythonTask.update_all(['enable=?,period=?',python_task_status,period_time],:id =>python_task_id)
    #更新定时任务
    Thread.new{update_schedule()}
    redirect_to :action => 'spider'
  end

  def sendmail
    maillist = params[:maillist].split(",")

    maillist.each do |mail|
      NotifyMailer.send_mail_delay(mail,"Tbs舆情预警", params[:info]+('<a href="'+params[:url]+'" target="_blank">原链接</a>').html_safe)
    end
    render :text => "OK"
  end


  def sendsms
    #http://1.tbsjms.sinaapp.com/?mobile=18626464667&content=%E6%88%91%E5%B7%AE
    url = "http://1.tbsjms.sinaapp.com/?mobile="+ params[:smslist] + '&content='+ params[:info]
    #print url
    uri = URI.parse(URI.escape(url))
    Net::HTTP.get(uri)
    render :text => "OK"
  end

  def alertlist
  	@alertlist=[]
  	InfoCommon.subclasses.each do |info|
	  	if params[:filter]=="handled"
	      temp=info.joins(:operation).where(:operations => {:ignored => false ,:handled_alert => true , :ignored_alert => false},:urgency=>3..5)#.limit(ItemPerPage).offset((params[:page].to_i)*ItemPerPage)
	    	temp.each do |t|
	    		@alertlist.push(t)
	    	end
	    elsif params[:filter]=="ignored"
	      temp=info.joins(:operation).where(:operations => {:ignored => false ,:ignored_alert => true},:urgency=>3..5)#.limit(ItemPerPage).offset((params[:page].to_i)*ItemPerPage)
	   		temp.each do |t|
	    		@alertlist.push(t)
	    	end
	    else
	      temp=info.joins(:operation).where(:operations => {:ignored => false ,:handled_alert => false , :ignored_alert => false},:urgency=>3..5)#.limit(ItemPerPage).offset((params[:page].to_i)*ItemPerPage)
	    	temp.each do |t|
	    		@alertlist.push(t)
	    	end
	    end
	end
	@alertlist = @alertlist.sort_by {|r| r.urgency}.reverse[params[:page].to_i*ItemPerPage..(params[:page].to_i*ItemPerPage+ItemPerPage)]

	render :layout => false
  end

  def ignore
    info_clz = get_info_class_by_name(params[:info_type])
    if info_clz.find(params[:id]).operation.update_attribute('ignored_alert' , true)
      render :text => "OK"
    end
  end

  def unignore
    info_clz = get_info_class_by_name(params[:info_type])
    if info_clz.find(params[:id]).operation.update_attribute('ignored_alert' , false)
      render :text => "OK"
    end
  end

  def handle
    info_clz = get_info_class_by_name(params[:info_type])
    if info_clz.find(params[:id]).operation.update_attribute('handled_alert' , true)
      render :text => "OK"
    end
  end

  def update_schedule
    schdule_path = File.dirname(File.dirname(File.dirname(__FILE__))) + "/config/schedule.rb"    
    cmd = "whenever -i -f "+schdule_path
    system(cmd)
  end

end
