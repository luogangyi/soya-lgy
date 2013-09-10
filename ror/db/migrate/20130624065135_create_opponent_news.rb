# -*- encoding : utf-8 -*-
class CreateOpponentNews < ActiveRecord::Migration
  def change
    create_table :opponent_news do |t|
      
      t.string :url
      t.string :source_name
      t.references :info_source
      t.references :opponent_keyword
      t.string :title
      t.string :content

      t.integer :urgency, :default =>0
      t.integer :sentiment, :default => 2
      t.datetime :created_at


    end
    add_index :opponent_news, :info_source_id
    add_index :opponent_news, :opponent_keyword_id
  end
end
