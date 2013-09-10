# -*- encoding : utf-8 -*-
class CreateWeiboUsers < ActiveRecord::Migration
  def change
    create_table :weibo_users do |t|
      t.string :user_origin_id, :null => false ,:limit => 8  
      t.references :info_source
      t.string :screen_name, :null => false
      t.string :profile_image_url, :null => false
      t.integer :status_count, :null => false
      t.integer :follower_count, :null => false
      t.integer :following_count, :null => false
      t.boolean :verified, :default => false
      t.string :geo_info_city
      t.string :geo_info_province
      t.string :gender, :null => false


      
    end
    add_index :weibo_users, :info_source_id
  end
end
