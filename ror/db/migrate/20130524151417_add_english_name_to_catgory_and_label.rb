# -*- encoding : utf-8 -*-
class AddEnglishNameToCatgoryAndLabel < ActiveRecord::Migration
  def up
    add_column :categories, :str_en, :string
    add_column :labels, :str_en, :string
  end

  def down
    remove_column :categories, :str_en
    remove_column  :labels, :str_en
  end

end
 
