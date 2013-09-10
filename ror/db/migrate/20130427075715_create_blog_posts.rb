# -*- encoding : utf-8 -*-
class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.references :info_source
      t.references :keyword
      t.integer :urgency, :default => 0
      t.string :url
      t.string :blog_user_screen_name
      t.string :title
      t.text :content
      t.integer :read_count
      t.integer :comment_count
      t.integer :sentiment, :default => 2

      t.datetime :created_at ,:null => false
      
    end
    add_index :blog_posts, :info_source_id
    add_index :blog_posts, :keyword_id
  end
end
