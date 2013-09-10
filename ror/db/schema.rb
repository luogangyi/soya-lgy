# -*- encoding : utf-8 -*-
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130714074945) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "phone",                  :default => ""
    t.string   "username",               :default => ""
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["authentication_token"], :name => "index_admins_on_authentication_token", :unique => true
  add_index "admins", ["confirmation_token"], :name => "index_admins_on_confirmation_token", :unique => true
  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "analysis_categorizeds", :force => true do |t|
    t.integer "analysable_id"
    t.string  "analysable_type"
    t.integer "category_id"
    t.integer "label_id"
  end

  add_index "analysis_categorizeds", ["analysable_id"], :name => "index_analysis_categorizeds_on_analysable_id"
  add_index "analysis_categorizeds", ["category_id"], :name => "index_analysis_categorizeds_on_category_id"
  add_index "analysis_categorizeds", ["label_id"], :name => "index_analysis_categorizeds_on_label_id"

  create_table "bbs_posts", :force => true do |t|
    t.integer  "info_source_id"
    t.integer  "keyword_id"
    t.integer  "urgency",              :default => 0
    t.string   "url"
    t.string   "title"
    t.string   "bbs_user_screen_name"
    t.text     "content"
    t.integer  "read_count"
    t.integer  "comment_count"
    t.integer  "sentiment",            :default => 2
    t.datetime "created_at",                          :null => false
  end

  add_index "bbs_posts", ["info_source_id"], :name => "index_bbs_posts_on_info_source_id"
  add_index "bbs_posts", ["keyword_id"], :name => "index_bbs_posts_on_keyword_id"

  create_table "blog_posts", :force => true do |t|
    t.integer  "info_source_id"
    t.integer  "keyword_id"
    t.integer  "urgency",               :default => 0
    t.string   "url"
    t.string   "blog_user_screen_name"
    t.string   "title"
    t.text     "content"
    t.integer  "read_count"
    t.integer  "comment_count"
    t.integer  "sentiment",             :default => 2
    t.datetime "created_at",                           :null => false
  end

  add_index "blog_posts", ["info_source_id"], :name => "index_blog_posts_on_info_source_id"
  add_index "blog_posts", ["keyword_id"], :name => "index_blog_posts_on_keyword_id"

  create_table "categories", :force => true do |t|
    t.string  "str",                           :null => false
    t.boolean "by_keyword", :default => false
    t.string  "str_en"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "hots", :force => true do |t|
    t.string   "has_keywords"
    t.string   "without_keywords"
    t.string   "any_keywords"
    t.datetime "start_at"
    t.datetime "end_at"
  end

  create_table "info_source_types", :force => true do |t|
    t.string "str",   :null => false
    t.string "enstr", :null => false
  end

  create_table "info_sources", :force => true do |t|
    t.string  "str"
    t.integer "period"
    t.integer "info_source_type_id"
    t.string  "en_str"
  end

  create_table "job_errors", :force => true do |t|
    t.integer  "info_source_id"
    t.datetime "happened_at"
  end

  add_index "job_errors", ["info_source_id"], :name => "index_job_errors_on_info_source_id"

  create_table "jobs", :force => true do |t|
    t.integer  "info_source_id"
    t.integer  "fetched_info_count",      :null => false
    t.integer  "real_fetched_info_count", :null => false
    t.datetime "previous_executed",       :null => false
  end

  add_index "jobs", ["info_source_id"], :name => "index_jobs_on_info_source_id"

  create_table "keywords", :force => true do |t|
    t.string "str", :null => false
  end

  create_table "label_keywords", :force => true do |t|
    t.integer  "label_id"
    t.string   "str"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "label_keywords", ["label_id"], :name => "index_label_keywords_on_label_id"

  create_table "labels", :force => true do |t|
    t.string  "str",                            :null => false
    t.integer "category_id"
    t.string  "enstr"
    t.boolean "show_by_tag", :default => false
    t.string  "str_en"
  end

  create_table "monitoring_weibo_statuses", :force => true do |t|
    t.integer  "weibo_status_id"
    t.datetime "created_at",      :null => false
    t.datetime "expiring_at",     :null => false
  end

  add_index "monitoring_weibo_statuses", ["weibo_status_id"], :name => "index_monitoring_weibo_statuses_on_weibo_status_id", :unique => true

  create_table "news", :force => true do |t|
    t.integer  "info_source_id"
    t.integer  "keyword_id"
    t.string   "source_name"
    t.integer  "urgency",        :default => 0
    t.integer  "sentiment",      :default => 2
    t.string   "url"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",                    :null => false
  end

  create_table "operations", :force => true do |t|
    t.boolean "handled",         :default => false
    t.boolean "ignored",         :default => false
    t.boolean "handled_alert",   :default => false
    t.boolean "ignored_alert",   :default => false
    t.integer "operatable_id"
    t.string  "operatable_type"
  end

  create_table "opponent_keywords", :force => true do |t|
    t.string "str"
    t.string "enstr"
  end

  create_table "opponent_news", :force => true do |t|
    t.string   "url"
    t.string   "source_name"
    t.integer  "info_source_id"
    t.integer  "opponent_keyword_id"
    t.string   "title"
    t.string   "content"
    t.integer  "urgency",             :default => 0
    t.integer  "sentiment",           :default => 2
    t.datetime "created_at"
  end

  add_index "opponent_news", ["info_source_id"], :name => "index_opponent_news_on_info_source_id"
  add_index "opponent_news", ["opponent_keyword_id"], :name => "index_opponent_news_on_opponent_keyword_id"

  create_table "python_tasks", :force => true do |t|
    t.string   "filename"
    t.decimal  "period",     :precision => 10, :scale => 0
    t.string   "remark"
    t.boolean  "enable"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "single_comments", :force => true do |t|
    t.integer  "single_source_status_id"
    t.string   "origin_id"
    t.string   "source_app"
    t.datetime "created_at"
    t.string   "text"
    t.integer  "single_weibo_user_id"
  end

  add_index "single_comments", ["single_source_status_id"], :name => "index_single_comments_on_single_source_status_id"
  add_index "single_comments", ["single_weibo_user_id"], :name => "index_single_comments_on_single_weibo_user_id"

  create_table "single_repost_statuses", :force => true do |t|
    t.integer  "single_source_status_id"
    t.string   "origin_id"
    t.string   "url"
    t.integer  "reposts_count"
    t.integer  "comments_count"
    t.integer  "attitudes_count"
    t.string   "text"
    t.string   "source_app"
    t.string   "pic"
    t.integer  "single_weibo_user_id"
    t.datetime "created_at"
    t.integer  "repost_depth"
    t.integer  "direct_reposts_count"
    t.string   "parent_origin_id"
  end

  create_table "single_source_statuses", :force => true do |t|
    t.string   "origin_id"
    t.integer  "reposts_count"
    t.integer  "comments_count"
    t.integer  "attitudes_count"
    t.string   "text"
    t.string   "source_app"
    t.string   "pic"
    t.integer  "single_weibo_user_id"
    t.datetime "created_at"
    t.string   "url"
  end

  create_table "single_weibo_users", :force => true do |t|
    t.string   "origin_id"
    t.string   "screen_name"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "bi_followers_count"
    t.string   "description"
    t.string   "profile_image_url"
    t.string   "city"
    t.string   "province"
    t.string   "gender"
    t.datetime "created_at"
    t.string   "verified_type"
    t.string   "profile_url"
    t.integer  "statuses_count"
  end

  create_table "site_infos", :force => true do |t|
    t.string "key"
    t.string "value"
  end

  create_table "video_posts", :force => true do |t|
    t.integer  "info_source_id"
    t.integer  "keyword_id"
    t.integer  "urgency",                :default => 0
    t.string   "video_user_screen_name"
    t.string   "title"
    t.string   "url"
    t.integer  "watch_count"
    t.integer  "comment_count"
    t.integer  "up_count"
    t.integer  "down_count"
    t.integer  "repost_count"
    t.integer  "sentiment",              :default => 2
    t.datetime "created_at",                            :null => false
    t.string   "source_name"
  end

  add_index "video_posts", ["info_source_id"], :name => "index_video_posts_on_info_source_id"
  add_index "video_posts", ["keyword_id"], :name => "index_video_posts_on_keyword_id"

  create_table "weibo_statuses", :force => true do |t|
    t.string   "url",                                                    :null => false
    t.string   "weibo_origin_id",        :limit => 8,                    :null => false
    t.integer  "weibo_user_id"
    t.string   "weibo_user_screen_name",                                 :null => false
    t.integer  "info_source_id"
    t.integer  "keyword_id"
    t.integer  "repost_count",                                           :null => false
    t.integer  "comment_count",                                          :null => false
    t.boolean  "retweeted",                           :default => false
    t.integer  "retweeted_status_id"
    t.boolean  "with_picture",                        :default => false
    t.string   "pic_address"
    t.string   "geo_info_city"
    t.string   "geo_info_province"
    t.integer  "sentiment",                           :default => 2
    t.integer  "urgency",                             :default => 0
    t.string   "text"
    t.datetime "created_at",                                             :null => false
  end

  create_table "weibo_users", :force => true do |t|
    t.string  "user_origin_id",    :limit => 8,                    :null => false
    t.integer "info_source_id"
    t.string  "screen_name",                                       :null => false
    t.string  "profile_image_url",                                 :null => false
    t.integer "status_count",                                      :null => false
    t.integer "follower_count",                                    :null => false
    t.integer "following_count",                                   :null => false
    t.boolean "verified",                       :default => false
    t.string  "geo_info_city"
    t.string  "geo_info_province"
    t.string  "gender",                                            :null => false
  end

  add_index "weibo_users", ["info_source_id"], :name => "index_weibo_users_on_info_source_id"

  create_table "wiki_posts", :force => true do |t|
    t.string   "url",                                      :null => false
    t.string   "wiki_user_screen_name",                    :null => false
    t.integer  "info_source_id"
    t.integer  "keyword_id"
    t.string   "title",                                    :null => false
    t.string   "content",                                  :null => false
    t.integer  "read_count",                               :null => false
    t.integer  "comment_count",                            :null => false
    t.boolean  "answered",              :default => false
    t.integer  "sentiment",             :default => 2
    t.integer  "urgency",               :default => 0
    t.datetime "created_at",                               :null => false
  end

  add_index "wiki_posts", ["info_source_id"], :name => "index_wiki_posts_on_info_source_id"

end
