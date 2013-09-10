# -*- encoding : utf-8 -*-
class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.references :info_source
      t.references :keyword
      t.string :source_name
      t.integer :urgency, :default =>0
      t.integer :sentiment, :default => 2
      t.string :url
      t.string :title
      t.text :content

      t.datetime :created_at ,:null => false

    end
  end
end
