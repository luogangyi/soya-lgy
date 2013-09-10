delete from soya.jobs;

ALTER TABLE soya.jobs AUTO_INCREMENT = 1;

INSERT INTO soya.jobs SELECT * FROM test.dosa_job;


delete from soya.weibo_users;

ALTER TABLE soya.weibo_users AUTO_INCREMENT = 1;

INSERT INTO soya.weibo_users SELECT * FROM test.dosa_weibo_user;

delete from soya.weibo_statuses;

ALTER TABLE soya.weibo_statuses AUTO_INCREMENT = 1;

INSERT INTO soya.weibo_statuses SELECT id-250000000,url,weibo_origin_id,weibo_user_id,weibo_user_screen_name,info_source_id,keyword_id,repost_count,comment_count,retweeted,retweeted_status_id,with_pic,pic_address,geo_info_city,geo_info_province,urgency,text,created_at,sentiment FROM test.dosa_weibo_status;

delete from soya.operations;

ALTER TABLE soya.operations AUTO_INCREMENT = 1;

INSERT INTO soya.operations SELECT null, handled,ignored,handled_alert,ignored_alert, id-250000000 ,"WeiboStatus" FROM test.dosa_weibo_status;

delete from soya.analysis_categorizeds;

ALTER TABLE soya.analysis_categorizeds AUTO_INCREMENT = 1;

INSERT INTO soya.analysis_categorizeds SELECT null,info_id-250000000,"WeiboStatus",category_id+1,label_id FROM test.dosa_weibo_status_analysis_categorized;



delete from soya.bbs_posts;

ALTER TABLE soya.bbs_posts AUTO_INCREMENT = 1;

INSERT INTO soya.bbs_posts SELECT id-200000000,info_source_id,keyword_id,bbs_user_screen_name,urgency,url,title,content,read_count,comment_count,created_at,sentiment FROM test.dosa_bbs_post;

INSERT INTO soya.operations SELECT null, handled,ignored,handled_alert,ignored_alert, id-200000000 ,"BbsPost" FROM test.dosa_bbs_post;

INSERT INTO soya.analysis_categorizeds SELECT null,info_id-200000000,"BbsPost", category_id+1 ,label_id FROM test.dosa_bbs_post_analysis_categorized;




delete from soya.blog_posts;

ALTER TABLE soya.blog_posts AUTO_INCREMENT = 1;

INSERT INTO soya.blog_posts SELECT id-150000000,info_source_id,keyword_id,urgency,url,blog_user_screen_name,title,content,read_count,comment_count,created_at,sentiment FROM test.dosa_blog_post;

INSERT INTO soya.operations SELECT null, handled,ignored,handled_alert,ignored_alert, id-150000000 ,"BlogPost" FROM test.dosa_blog_post;

INSERT INTO soya.analysis_categorizeds SELECT null,info_id-150000000,"BlogPost", category_id+1 ,label_id FROM test.dosa_blog_post_analysis_categorized;




delete from soya.news;

ALTER TABLE soya.news AUTO_INCREMENT = 1;

INSERT INTO soya.news SELECT id-100000000,info_source_id,keyword_id,source_name,urgency,url,title,content,created_at,sentiment FROM test.dosa_news;

INSERT INTO soya.operations SELECT null, handled,ignored,handled_alert,ignored_alert, id-100000000 ,"News" FROM test.dosa_news;

INSERT INTO soya.analysis_categorizeds SELECT null,info_id-100000000,"News", category_id+1 ,label_id FROM test.dosa_news_analysis_categorized;





delete from soya.video_posts;

ALTER TABLE soya.video_posts AUTO_INCREMENT = 1;

INSERT INTO soya.video_posts SELECT id,info_source_id,url,keyword_id,urgency,video_user_screen_name,title,watch_count,comment_count,up_count,down_count,repost_count,created_at,sentiment FROM test.dosa_video_post;

INSERT INTO soya.operations SELECT null, handled,ignored,handled_alert,ignored_alert, id ,"VideoPost" FROM test.dosa_video_post;

INSERT INTO soya.analysis_categorizeds SELECT null,info_id,"VideoPost", category_id+1 ,label_id FROM test.dosa_video_post_analysis_categorized;



delete from soya.wiki_posts;

ALTER TABLE soya.wiki_posts AUTO_INCREMENT = 1;

INSERT INTO soya.wiki_posts SELECT id-50000000,url,wiki_user_screen_name,info_source_id,keyword_id,title,content,read_count,comment_count,answered,urgency,created_at,sentiment FROM test.dosa_wiki_post;

INSERT INTO soya.operations SELECT null, handled,ignored,handled_alert,ignored_alert, id-50000000 ,"WikiPost" FROM test.dosa_wiki_post;

INSERT INTO soya.analysis_categorizeds SELECT null,info_id-50000000 ,"WikiPost", category_id+1 ,label_id FROM test.dosa_wiki_post_analysis_categorized;
