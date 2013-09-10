# -*- encoding : utf-8 -*-
require 'uri'
require 'net/http'

class InboxController < ApplicationController
  ItemPerPage = 5  
 
  def infoindex
    @infos= get_infos(0)
    @type = params[:info_type]
    @typestr = InfoSourceType.where(:enstr => params[:info_type]).first.str
  end

  def infoindex_label
    @label = Label.find(params[:label_id].to_i)
    @infos= get_infos_label(0,params[:label_id].to_i)
    @type = params[:info_type]
    @typestr = InfoSourceType.where(:enstr => params[:info_type]).first.str
  end




  def single
    @type= params[:info_type]
    @infos=get_info_class_by_name(params[:info_type]).where(:id => params[:id].to_i)
  end


  def infolist
    page = params[:page].to_i
    @infos= get_infos(page)
    @type = params[:info_type]
    render :layout => false
  end

  def infolist_label
    @label = Label.find(params[:label_id].to_i)
    page = params[:page].to_i
    @infos= get_infos_label(page,params[:label_id].to_i)
    @type = params[:info_type]
    render :layout => false
  end


  def get_infos(page)

    if params[:d1].to_i>0
      starttime = Time.at(params[:d1].to_i/1000)
      endtime =Time.at(params[:d2].to_i/1000)
      if params[:sortType]=="time"
        orderstr="created_at DESC"
      else
        orderstr="urgency DESC"
      end
      if params[:filter]=="handled"
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => true , :ignored => false},:created_at => starttime..endtime).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      elsif params[:filter]=="ignored"
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:ignored => true},:created_at => starttime..endtime).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      else
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => false , :ignored => false},:created_at => starttime..endtime).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      end
    else
      if params[:filter]=="handled"
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => true , :ignored => false}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
      elsif params[:filter]=="ignored"
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:ignored => true}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
      else
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => false , :ignored => false}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
      end
    end
  end



  def get_infos_label(page,label_id)

    if params[:d1].to_i>0
      starttime = Time.at(params[:d1].to_i/1000)
      endtime =Time.at(params[:d2].to_i/1000)
      if params[:sortType]=="time"
        orderstr="created_at DESC"
      else
        orderstr="urgency DESC"
      end
      if params[:filter]=="handled"
        get_info_class_by_name(params[:info_type]).joins(:operation).joins(:analysis_categorizeds).where(:analysis_categorizeds=>{:label_id => label_id},:operations => {:handled => true , :ignored => false},:created_at => starttime..endtime).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      elsif params[:filter]=="ignored"
        get_info_class_by_name(params[:info_type]).joins(:operation).joins(:analysis_categorizeds).where(:analysis_categorizeds=>{:label_id => label_id},:operations => {:ignored => true},:created_at => starttime..endtime).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      else
        get_info_class_by_name(params[:info_type]).joins(:operation).joins(:analysis_categorizeds).where(:analysis_categorizeds=>{:label_id => label_id},:operations => {:handled => false , :ignored => false},:created_at => starttime..endtime).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      end
    else
      if params[:filter]=="handled"
        get_info_class_by_name(params[:info_type]).joins(:operation).joins(:analysis_categorizeds).where(:analysis_categorizeds=>{:label_id => label_id},:operations => {:handled => true , :ignored => false}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
      elsif params[:filter]=="ignored"
        get_info_class_by_name(params[:info_type]).joins(:operation).joins(:analysis_categorizeds).where(:analysis_categorizeds=>{:label_id => label_id},:operations => {:ignored => true}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
      else
        get_info_class_by_name(params[:info_type]).joins(:operation).joins(:analysis_categorizeds).where(:analysis_categorizeds=>{:label_id => label_id},:operations => {:handled => false , :ignored => false}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
      end
    end
  end

 
  def set_urgency
    info_clz = get_info_class_by_name(params[:info_type])
    if info_clz.find(params[:info_id]).update_attributes(:urgency => params[:urgency]) && params[:urgency].to_i<6
      render :text => "OK"
    end
  end

  def ignore
    info_clz = get_info_class_by_name(params[:info_type])
    if info_clz.find(params[:info_id]).operation.update_attribute('ignored' , true)
      render :text => "OK"
    end
  end

  def unignore
    info_clz = get_info_class_by_name(params[:info_type])
    info_clz.find(params[:info_id]).operation.update_attribute('handled' , false)
    if info_clz.find(params[:info_id]).operation.update_attribute('ignored' , false)
      render :text => "OK"
    end
  end

  def monitoring
    if params[:filter] == "history"
      ids = []
      MonitoringWeiboStatus.where("expiring_at < :now", {:now => Time.now }).each do |i|
        ids.push(i.weibo_status_id)
      end
      @infos= WeiboStatus.find_all_by_id(ids)
    else
      ids = []
      MonitoringWeiboStatus.where("expiring_at >= :now", {:now => Time.now }).each do |i|
        ids.push(i.weibo_status_id)
      end
      @infos= WeiboStatus.find_all_by_id(ids)
    end
      
  end


  def monitor
    MonitoringWeiboStatus.where(
      :weibo_status_id=>params[:info_id],
      :created_at => Time.now,
      :expiring_at => Time.now + 2.day
      ).first_or_create
    render :text => "OK"
  end

  def unmonitor
    MonitoringWeiboStatus.where(
      :weibo_status_id=>params[:info_id]
      ).destroy_all
    render :text => "OK"
  end

  def handle
    info_clz = get_info_class_by_name(params[:info_type])
    tags = params[:tags].split(',')
    info_clz.find(params[:info_id]).analysis_categorizeds.delete_all
    tags.each do |tag|
      label = Label.where(:str => tag).first

      url = CLASSIFIER_SERVER_TRAIN + '?label_id='+(label.id).to_s + '&content='+ info_clz.find(params[:info_id]).extract_meaningful_content
      print url
      uri = URI.parse(URI.escape(url))
      Net::HTTP.get(uri)

      AnalysisCategorized.where(
            :analysable_id => params[:info_id],
            :analysable_type => info_clz.name,
            :label_id => label.id,
            :category_id => label.category_id
          ).first_or_create


    end

    thesentiment = AnalysisCategorized.where(:analysable_id => params[:info_id], :analysable_type=> info_clz.name, :category_id => 1).first.label_id

    info_clz.find(params[:info_id]).update_attributes(:sentiment => thesentiment)

    info_clz.find(params[:info_id]).operation.update_attribute('handled' , true)
    


    render :text => "OK"
    
  end


  def handlelist

    info_clz = get_info_class_by_name(params[:info_type])

    if params[:ignore] == "1" 
      (info_clz.search params[:keystr] , :per_page => 100000, :limit => 100000).each do |r|
        r.operation.update_attribute('ignored' , params[:ignore])
      end
    else
      tags = params[:labelstr][0,params[:labelstr].length-1].split(' ')

      (info_clz.search params[:keystr] , :per_page => 100000, :limit => 100000).each do |r|

        r.analysis_categorizeds.delete_all
        tags.each do |tag|
          label = Label.where(:str => tag).first
          AnalysisCategorized.where(
                :analysable_id => r.id,
                :analysable_type => info_clz.name,
                :label_id => label.id,
                :category_id => label.category_id
              ).first_or_create
        end

        AnalysisCategorized.where(
                :analysable_id => r.id,
                :analysable_type => info_clz.name,
                :label_id => params[:sentiment],
                :category_id => 1
              ).first_or_create


        r.update_attributes(:sentiment => params[:sentiment])

        r.operation.update_attribute('handled' , true)
      end

    end

    render :text => "OK"

  end



end
