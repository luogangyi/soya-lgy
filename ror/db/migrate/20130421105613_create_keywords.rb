# -*- encoding : utf-8 -*-
class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :str, :null => false
    end
  end
end
