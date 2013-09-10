# -*- encoding : utf-8 -*-
class CreateInfoSourceTypes < ActiveRecord::Migration
  def change
    create_table :info_source_types do |t|
      t.string :str, :null => false
      t.string :enstr, :null => false
    end
  end
end
