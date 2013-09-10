# -*- encoding : utf-8 -*-
class SearchController < ApplicationController
  def index
  	@query=params[:query]
  	
  	unless @query.blank?
      @results = ThinkingSphinx.search @query , 
                  :match_mode => :phrase,
                  :classes => InfoCommon.subclasses
  	end


  end



  def searchlist
    @query=params[:query]
    if params[:d1].to_i>0
      if params[:sortType]=="time"
        orderstr="created_at DESC"
      else
        orderstr="urgency DESC"
      end
      starttime = Time.at(params["d1"].to_i/1000)+8.hour
      endtime   = Time.at(params["d2"].to_i/1000)+8.hour
      if params[:sentiment]=="0"
        unless @query.blank?
          @results = ThinkingSphinx.search @query , 
                      :match_mode => :phrase,
                      :classes => InfoCommon.subclasses,
                      :order => orderstr,
                      :with => {:created_at => starttime..endtime},
                      :page => params[:page],
                      :per_page => 5
        end
      else
        unless @query.blank?
          @results = ThinkingSphinx.search @query , 
                      :match_mode => :phrase,
                      :classes => InfoCommon.subclasses,
                      :order => orderstr,
                      :with => {:created_at => starttime..endtime,:sentiment => params[:sentiment].to_i},
                      :page => params[:page],
                      :per_page => 5
        end
      end
    else
       unless @query.blank?
        @results = ThinkingSphinx.search @query , 
                    :match_mode => :phrase,
                    :classes => InfoCommon.subclasses,
                    :order => "created_at DESC",
                    :page => params[:page],
                    :per_page => 5
       end
    end

    render :layout => false
  end


  def downloads
    @query=params[:query]
    if params[:d1].to_i>0
      if params[:sortType]=="time"
        orderstr="created_at DESC"
      else
        orderstr="urgency DESC"
      end
      starttime = Time.at(params["d1"].to_i/1000)+8.hour
      endtime   = Time.at(params["d2"].to_i/1000)+8.hour
      if params[:sentiment]=="0"
        unless @query.blank?
          results = ThinkingSphinx.search @query , 
                      :classes => InfoCommon.subclasses,
                      :match_mode => :phrase,
                      :order => orderstr,
                      :with => {:created_at => starttime..endtime},
                      :limit => 100000
        end
      else
        unless @query.blank?
          results = ThinkingSphinx.search @query , 
                      :classes => InfoCommon.subclasses,
                      :match_mode => :phrase,
                      :order => orderstr,
                      :with => {:created_at => starttime..endtime,:sentiment => params[:sentiment].to_i},
                      :limit => 100000
        end
      end

    else
      unless @query.blank?
          results = ThinkingSphinx.search @query , 
                      :classes => InfoCommon.subclasses,
                      :match_mode => :phrase,
                      :order => "created_at DESC",
                      :limit => 100000
      end
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
    p.serialize('search_result.xlsx')
    send_file 'search_result.xlsx', :type=>"application/xlsx"
  end
end
