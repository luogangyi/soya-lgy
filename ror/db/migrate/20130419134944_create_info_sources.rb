# -*- encoding : utf-8 -*-
class CreateInfoSources < ActiveRecord::Migration
  def change
    create_table :info_sources do |t|
      t.string :str
      t.integer :period
      t.references :info_source_type
      t.string :en_str
    end
  end
end
