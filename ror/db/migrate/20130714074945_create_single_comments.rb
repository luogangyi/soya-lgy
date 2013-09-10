# -*- encoding : utf-8 -*-
class CreateSingleComments < ActiveRecord::Migration
  def change
    create_table :single_comments do |t|
      t.references :single_source_status
      t.string :origin_id
      t.string :source_app
      t.datetime :created_at
      t.string :text
      t.references :single_weibo_user
    end
    add_index :single_comments, :single_source_status_id
    add_index :single_comments, :single_weibo_user_id
  end
end
