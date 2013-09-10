# -*- encoding : utf-8 -*-
class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :info_source
      t.integer :fetched_info_count ,:null => false
      t.integer :real_fetched_info_count ,:null => false
      t.datetime :previous_executed ,:null => false
    end
    add_index :jobs, :info_source_id
  end
end
