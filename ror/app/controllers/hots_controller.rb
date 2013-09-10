# -*- encoding : utf-8 -*-
class HotsController < ApplicationController
  ItemPerPage = 5 
  def index
  	@hots = Hot.all
  end




  def show
    @query = get_query(params[:id])
    @hot = Hot.find(params[:id])
    @results = get_all_infos(params[:id])

  end

  def resultlist
    @query = get_query(params[:id])
    @hot = Hot.find(params[:id])
    if params[:d1].to_i>0
      starttime = Time.at(params["d1"].to_i/1000)-8.hour
      endtime   = Time.at(params["d2"].to_i/1000)-8.hour

      if params[:sentiment]=="0"
        if params[:sortType]=="time"
          @results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db)}.sort_by{|info|info.created_at}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        else
          @results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db)}.sort_by{|info|info.urgency.to_i}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        end
      else
        if params[:sortType]=="time"
          @results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.sentiment == params[:sentiment].to_i }.sort_by{|info|info.created_at}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        else
          @results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.sentiment == params[:sentiment].to_i }.sort_by{|info|info.urgency.to_i}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        end
      end
    else
        @results = get_all_infos(params[:id]).sort_by{|info|info.created_at}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
    end

    render :layout => false
  end


  def report
    @hot = Hot.find(params[:id])
  end

  def new
  	@hot = Hot.new
  end


  def create
  	@hot = Hot.new(params[:hot])
    
  	@hot.start_at = Time.parse(params[:hot]["start_at"] + "　00:00:00")
    p params[:hot]["start_at"]
  	@hot.end_at = Time.parse(params[:hot]["end_at"] + "　23:59:59")
  	if @hot.save 
  		redirect_to :action => "index"
  	end
  end


  def destroy
  	@hot = Hot.find(params[:id])
  	@hot.destroy
  	redirect_to :action => "index"
  end



  def downloads
    @hot = Hot.find(params[:id])

    if params[:d1].to_i>0
      starttime = Time.at(params["d1"].to_i/1000)-8.hour
      endtime   = Time.at(params["d2"].to_i/1000)-8.hour

      if params[:sentiment]=="0"
        if params[:sortType]=="time"
          results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db)}.sort_by{|info|info.created_at}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        else
          results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db)}.sort_by{|info|info.urgency.to_i}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        end
      else
        if params[:sortType]=="time"
          results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.sentiment == params[:sentiment].to_i }.sort_by{|info|info.created_at}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        else
          results = get_all_infos(params[:id]).find_all{|info| info.created_at > starttime.to_s(:db) && info.created_at < endtime.to_s(:db) && info.sentiment == params[:sentiment].to_i }.sort_by{|info|info.urgency.to_i}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
        end
      end
    else
        results = get_all_infos(params[:id]).sort_by{|info|info.created_at}.reverse[params[:page].to_i*ItemPerPage,ItemPerPage]
    end


    require "rubygems"
    require 'axlsx'

    sitename= SiteInfo.where(:key => "NAME" ).first().value

   
    p = Axlsx::Package.new
    wb = p.workbook
    ws = p.workbook.add_worksheet
    title = wb.styles.add_style(
                           :border=>Axlsx::STYLE_THIN_BORDER,
                           :alignment=>{:horizontal => :center})


    ws.add_row ['编号',"公司","性质","风险级别","平台来源","来源","用户昵称","粉丝数","发布内容/标题","转发数/阅读数","评论数","链接","地区","发布时间"] , :style=>title


    results.each_with_index do |w,index|
      if w.class.to_s == "WeiboStatus"
        ws.add_row [(index+1).to_s,sitename,
                        w.sentiment_str,
                        w.urgency, 
                        w.class.to_s,
                        w.info_source.str,
                        w.weibo_user_screen_name,
                        w.weibo_user.follower_count,
                        w.text,
                        w.repost_count,
                        w.comment_count,
                        w.url,
                        w.geo_info_province+"-"+w.geo_info_city,
                        w.created_at
                      ]
      elsif w.class.to_s == "BbsPost"
        ws.add_row [(index+1).to_s,sitename,
                        w.sentiment_str,
                        w.urgency, 
                        w.class.to_s,
                        w.info_source.str,
                        w.bbs_user_screen_name,
                        "",
                        w.title,
                        w.read_count,
                        w.comment_count,
                        w.url,
                        "",
                        w.created_at
                      ]
      elsif w.class.to_s == "BlogPost"
        ws.add_row [(index+1).to_s,sitename,
                        w.sentiment_str,
                        w.urgency, 
                        w.class.to_s,
                        w.info_source.str,
                        w.blog_user_screen_name,
                        "",
                        w.title,
                        w.read_count,
                        w.comment_count,
                        w.url,
                        "",
                        w.created_at
                      ]
      elsif w.class.to_s == "WikiPost"
        ws.add_row [(index+1).to_s,sitename,
                        w.sentiment_str,
                        w.urgency, 
                        w.class.to_s,
                        w.info_source.str,
                        w.wiki_user_screen_name,
                        "",
                        w.title,
                        w.read_count,
                        w.comment_count,
                        w.url,
                        "",
                        w.created_at
                      ]
      elsif w.class.to_s == "VideoPost"
        ws.add_row [(index+1).to_s,sitename,
                        w.sentiment_str,
                        w.urgency, 
                        w.class.to_s,
                        w.info_source.str,
                        w.video_user_screen_name,
                        "",
                        w.title,
                        w.watch_count,
                        w.comment_count,
                        w.url,
                        "",
                        w.created_at
                      ]
      elsif w.class.to_s == "News"
        ws.add_row [(index+1).to_s,sitename,
                        w.sentiment_str,
                        w.urgency, 
                        w.class.to_s,
                        w.source_name,
                        "",
                        "",
                        w.title,
                        "",
                        "",
                        w.url,
                        "",
                        w.created_at
                      ]
      end
    end     
    p.serialize('hots_result.xlsx')
    send_file 'hots_result.xlsx', :type=>"application/xlsx"
  end


  def get_query(hotid)
    get_query = ""
    hot = Hot.find(hotid)

    query1=""
    hot.has_keywords.split(",").each do |k|
        query1 = query1 + k + " "
    end

    if query1.length>0
      query1 = query1[0,query1.length-1]
    end

    query2=""
    hot.any_keywords.split(",").each do |k|
        query2 = query2 + k + " "
    end

    get_query = query1
    if query2.length>0
      query2 = query2[0,query2.length-1]
      get_query = query1 + " " + query2
    end
    get_query
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
                      :match_mode => :phrase,
                      :classes => InfoCommon.subclasses,
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
                    :match_mode => :phrase,
                    :classes => InfoCommon.subclasses,
                    :limit => 100000
      end
      
      results3=[]
      unless query3.blank?
        results3 = ThinkingSphinx.search query3 , 
                    :match_mode => :phrase,
                    :classes => InfoCommon.subclasses,
                    :limit => 100000
      end
      results = (results1.compact.to_ary | results2.compact.to_ary)-results3.compact.to_ary
    end

end
