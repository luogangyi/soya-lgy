# -*- encoding : utf-8 -*-
class CreateWikiPosts < ActiveRecord::Migration
  def change
    create_table :wiki_posts do |t|
      t.string :url, :null => false
      t.string :wiki_user_screen_name, :null => false
      t.references :info_source
      t.references :keyword
      t.string :title, :null => false
      t.string :content, :null => false
      t.integer :read_count, :null => false
      t.integer :comment_count, :null => false
      t.boolean :answered, :default => false
      t.integer :sentiment, :default => 2
      t.integer :urgency, :default => 0
      t.datetime :created_at ,:null => false
      
    end
    add_index :wiki_posts, :info_source_id
  end
end
