# -*- encoding : utf-8 -*-
class CreateVideoPosts < ActiveRecord::Migration
  def change
    create_table :video_posts do |t|
      t.references :info_source
      t.references :keyword
      t.integer :urgency, :default =>0
      t.string :video_user_screen_name
      t.string :title
      t.string :url
      t.integer :watch_count
      t.integer :comment_count
      t.integer :up_count
      t.integer :down_count
      t.integer :repost_count
      t.integer :sentiment, :default => 2
      t.datetime :created_at ,:null => false
      t.string :source_name

    end
    add_index :video_posts, :info_source_id
    add_index :video_posts, :keyword_id
  end
end
