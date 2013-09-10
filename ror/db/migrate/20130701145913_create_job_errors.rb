# -*- encoding : utf-8 -*-
class CreateJobErrors < ActiveRecord::Migration
  def change
    create_table :job_errors do |t|
      t.references :info_source
      t.datetime :happened_at

    end
    add_index :job_errors, :info_source_id
  end
end
