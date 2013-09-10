# -*- encoding : utf-8 -*-
class CreateSingleRepostStatuses < ActiveRecord::Migration
  def change
    create_table :single_repost_statuses do |t|
      t.references :single_source_status
      t.string :origin_id
      t.string :url
      t.integer :reposts_count
      t.integer :comments_count
      t.integer :attitudes_count
      t.string :text
      t.string :source_app
      t.string :pic
      t.references :single_weibo_user
      t.datetime :created_at
      t.integer :repost_depth
      t.integer :direct_reposts_count
      t.string :parent_origin_id
    end
  end
end
