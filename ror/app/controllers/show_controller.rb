# -*- encoding : utf-8 -*-
class ShowController < ApplicationController
  ItemPerPage = 5


  def bysource
    @info_source_types=InfoSourceType.all
    @colors=["red","blue","purple","green","grey","yellow","red","blue","purple","green"]
  end


  def sourceinfolist
    @sourceinfos = get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => 1,:ignored => 0}).order("created_at DESC").limit(ItemPerPage).offset((params[:page].to_i)*ItemPerPage)
    @type = params[:info_type]
    render :layout => false
  end

  def labelinfolist
    @labelinfos_alc = get_infos_alc_by_label(params[:page].to_i,params[:label_id])
    @label_id = params[:label_id]
    render :layout => false
  end

  def opponentinfolist
    if !params[:page]
      page = 0
    else
      page = params[:page].to_i
    end
    @infos = OpponentNews.where(:opponent_keyword_id=>params[:opponent_keyword_id]).order("created_at DESC").limit(ItemPerPage).offset(page * ItemPerPage)
    render :layout => false
  end



  def infoindex_label
    @labelinfos_alc = get_infos_alc_by_label(1,params[:label_id])
    @label_id = params[:label_id]
    @label_str = Label.where(:id => params[:label_id]).first.str
  end


  def infolist_label
    @labelinfos_alc = get_infos_alc_by_label(params[:page].to_i,params[:label_id])
    @label_id = params[:label_id]
    render :layout => false
  end



  def bylabel
    @labels = Label.where(:show_by_tag => true)
    @colors=["red","blue","purple","green","grey","yellow","red","blue","purple","green","grey","yellow","red","blue","purple","green","grey","yellow","red","blue","purple","green","grey","yellow"]
  end

  def byopponent
    @opponent_keywords = OpponentKeyword.all
    @colors=["red","blue","purple","green","grey","yellow","red","blue","purple","green","grey","yellow"]
  end

  def single_opponent
    @infos = OpponentNews.where(:id=>params[:id])
  end


  def infoindex_opponent
    if !params[:page]
      page = 0
    else
      page = params[:page].to_i
    end
    @opk_str=OpponentKeyword.find(params[:opponent_keyword_id]).str
    @infos = get_opponent_list(page)

  end

  def infolist_opponent
    if !params[:page]
      page = 0
    else
      page = params[:page].to_i
    end

    @infos = get_opponent_list(page)

    render :layout => false
  end

  def get_opponent_list(page)
    if params[:d1].to_i>0
      OpponentNews.where(:opponent_keyword_id=>params[:opponent_keyword_id],:created_at => Time.at(params[:d1].to_i/1000).to_s(:db)..Time.at(params[:d2].to_i/1000).to_s(:db)).order("created_at DESC").limit(ItemPerPage).offset(page * ItemPerPage) 
    else
      OpponentNews.where(:opponent_keyword_id=>params[:opponent_keyword_id]).order("created_at DESC").limit(ItemPerPage).offset(page * ItemPerPage)
    end
  end





  def single
    @type= params[:info_type]
    @infos=get_info_class_by_name(params[:info_type]).where(:id => params[:id].to_i)
  end


  def infoindex
    @infos= get_infos(0)
    @type = params[:info_type]
    @typestr = InfoSourceType.where(:enstr => params[:info_type]).first.str
  end


  def infolist
    page = params[:page].to_i
    @infos= get_infos(page)
    @type = params[:info_type]
    render :layout => false
  end


  def get_infos(page)
    if params[:d1].to_i>0
      if params[:sortType]=="time"
        orderstr="created_at DESC"
      else
        orderstr="urgency DESC"
      end
      if params[:emotion].to_i == 0
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => 1,:ignored => 0},:created_at => Time.at(params[:d1].to_i/1000).to_s(:db)..Time.at(params[:d2].to_i/1000).to_s(:db)).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      else
        get_info_class_by_name(params[:info_type]).joins(:operation).where(:sentiment => params[:emotion].to_i , :operations => {:handled => 1,:ignored => 0},:created_at => Time.at(params[:d1].to_i/1000).to_s(:db)..Time.at(params[:d2].to_i/1000).to_s(:db)).order(orderstr).limit(ItemPerPage).offset(page*ItemPerPage)
      end


    else
      get_info_class_by_name(params[:info_type]).joins(:operation).where(:operations => {:handled => 1,:ignored => 0}).order("created_at DESC").limit(ItemPerPage).offset(page*ItemPerPage)
    end
  end

  def get_infos_alc_by_label(page,label_id)

    wherestr = ""
    orderstr = "created_at DESC"
    if params[:d1].to_i>0
      wherestr +=" and created_at > '"+ Time.at(params[:d1].to_i/1000).to_s(:db) +"' and created_at < '"+ Time.at(params[:d2].to_i/1000).to_s(:db)+"'"

      if params[:sortType]!="time"
        orderstr="urgency DESC"
      end
      if params[:emotion].to_i != 0
        wherestr +=" and sentiment = "+params[:emotion]
      end
    end

    AnalysisCategorized.paginate_by_sql("select a1.id as info_id, a1.created_at, a1.urgency, b1.* from weibo_statuses a1,analysis_categorizeds b1, operations c1 where c1.operatable_id = a1.id and c1.operatable_type='WeiboStatus' and c1.handled=1 and c1.ignored=0 and a1.id = b1.analysable_id and b1.analysable_type='WeiboStatus' and b1.label_id = '" + label_id + "'" + wherestr +"
             union all select a2.id as info_id, a2.created_at, a2.urgency, b2.* from wiki_posts a2,analysis_categorizeds b2, operations c2 where c2.operatable_id = a2.id and c2.operatable_type='WikiPost' and c2.handled=1 and c2.ignored=0 and a2.id = b2.analysable_id and b2.analysable_type='WikiPost' and b2.label_id = '" + label_id + "'" + wherestr  +"
             union all select a3.id as info_id, a3.created_at, a3.urgency, b3.* from bbs_posts a3,analysis_categorizeds b3, operations c3 where c3.operatable_id = a3.id and c3.operatable_type='BbsPost' and c3.handled=1 and c3.ignored=0 and a3.id = b3.analysable_id and b3.analysable_type='BbsPost' and b3.label_id =  '" + label_id + "'" + wherestr  +"
             union all select a4.id as info_id, a4.created_at, a4.urgency, b4.* from blog_posts a4,analysis_categorizeds b4 , operations c4 where c4.operatable_id = a4.id and c4.operatable_type='BlogPost' and c4.handled=1 and c4.ignored=0 and a4.id = b4.analysable_id and b4.analysable_type='BlogPost' and b4.label_id =  '" + label_id + "'" + wherestr +" 
             union all select a5.id as info_id, a5.created_at, a5.urgency, b5.* from video_posts a5,analysis_categorizeds b5 , operations c5 where c5.operatable_id = a5.id and c5.operatable_type='VideoPost' and c5.handled=1 and c5.ignored=0 and a5.id = b5.analysable_id and b5.analysable_type='VideoPost' and b5.label_id =  '" + label_id + "'" + wherestr +" 
             union all select a6.id as info_id, a6.created_at, a6.urgency, b6.* from news a6,analysis_categorizeds b6 , operations c6 where c6.operatable_id = a6.id and c6.operatable_type='News' and c6.handled=1 and c6.ignored=0 and a6.id = b6.analysable_id and b6.analysable_type='News' and b6.label_id =  '" + label_id + "'" + wherestr +"
             order by " + orderstr, :page => page, :per_page => ItemPerPage)

    # AnalysisCategorized.paginate_by_sql("select a1.created_at, a1.urgency, b1.* from weibo_statuses a1,analysis_categorizeds b1 where a1.id = b1.analysable_id and b1.analysable_type='WeiboStatus' and b1.label_id = '"+label_id+"'"+ wherestr +"
                                         
    #                                      union all 

    #                                      select a2.created_at, a2.urgency, b2.* from wiki_posts a2,analysis_categorizeds b2  where a2.id = b2.analysable_id and b2.analysable_type='WikiPost' and b2.label_id = '"+label_id+"'"+ wherestr +"

    #                                      union all 

    #                                      select a3.created_at, a3.urgency, b3.* from bbs_posts a3,analysis_categorizeds b3 where a3.id = b3.analysable_id and b3.analysable_type='WikiPost' and b3.label_id =  '"+label_id+"'"+ wherestr +"

    #                                      union all 

    #                                      select a4.created_at, a4.urgency, b4.* from blog_posts a4,analysis_categorizeds b4 where a4.id = b4.analysable_id and b4.analysable_type='WikiPost' and b4.label_id =  '"+label_id+"'"+ wherestr +"

    #                                      union all 

    #                                      select a5.created_at, a5.urgency, b5.* from video_posts a5,analysis_categorizeds b5 where a5.id = b5.analysable_id and b5.analysable_type='WikiPost' and b5.label_id =  '"+label_id+"'"+ wherestr +"

    #                                      union all 

    #                                      select a6.created_at, a6.urgency, b6.* from news a6,analysis_categorizeds b6 where a6.id = b6.analysable_id and b6.analysable_type='WikiPost' and b6.label_id =  '"+label_id+"'"+ wherestr +"

    #                                      order by "+orderstr ,:page => page, :per_page => ItemPerPage)
    
  end

end
