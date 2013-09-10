# -*- encoding : utf-8 -*-
class CreateSingleSourceStatuses < ActiveRecord::Migration
  def change
    create_table :single_source_statuses do |t|
      t.string :origin_id
      t.integer :reposts_count
      t.integer :comments_count
      t.integer :attitudes_count
      t.string :text
      t.string :source_app
      t.string :pic
      t.references :single_weibo_user
      t.datetime :created_at
      t.string :url
    end
  end
end
