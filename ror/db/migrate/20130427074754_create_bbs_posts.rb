# -*- encoding : utf-8 -*-
class CreateBbsPosts < ActiveRecord::Migration
  def change
    create_table :bbs_posts do |t|
      t.references :info_source
      t.references :keyword
      t.integer :urgency, :default =>0
      t.string :url
      t.string :title
      t.string :bbs_user_screen_name
      t.text :content
      t.integer :read_count
      t.integer :comment_count
      t.integer :sentiment, :default => 2
      t.datetime :created_at ,:null => false
      
    end
    add_index :bbs_posts, :info_source_id
    add_index :bbs_posts, :keyword_id
  end
end
