# -*- encoding : utf-8 -*-
class CreateWeiboStatuses < ActiveRecord::Migration
  def change
    create_table :weibo_statuses do |t|
      t.string :url, :null => false
      t.string :weibo_origin_id, :null => false ,:limit => 8  
      t.references :weibo_user
      t.string :weibo_user_screen_name, :null => false
      t.references :info_source
      t.references :keyword
      t.integer :repost_count, :null => false
      t.integer :comment_count, :null => false
      t.boolean :retweeted, :default => false
      t.integer :retweeted_status_id
      t.boolean :with_picture, :default => false
      t.string :pic_address
      t.string :geo_info_city
      t.string :geo_info_province
      t.integer :sentiment, :default => 2
      t.integer :urgency, :default => 0
      t.string :text
      t.datetime :created_at ,:null => false
      
    end
  end
end
