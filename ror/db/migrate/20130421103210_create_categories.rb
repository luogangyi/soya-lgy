# -*- encoding : utf-8 -*-
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :str, :null => false
      t.boolean :by_keyword, :default => false
    end
  end
end
