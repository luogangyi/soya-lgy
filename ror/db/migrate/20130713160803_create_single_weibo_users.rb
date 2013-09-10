# -*- encoding : utf-8 -*-
class CreateSingleWeiboUsers < ActiveRecord::Migration
  def change
    create_table :single_weibo_users do |t|
      t.string :origin_id
      t.string :screen_name
      t.integer :followers_count
      t.integer :friends_count
      t.integer :bi_followers_count
      t.string :description
      t.string :profile_image_url
      t.string :city
      t.string :province
      t.string :gender
      t.datetime :created_at
      t.string :verified_type
      t.string :profile_url
      t.integer :statuses_count
    end
  end
end
