# -*- encoding : utf-8 -*-
class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :str, :null => false
      t.references :category
      t.string :enstr
      t.boolean :show_by_tag, :default => false
    end
  end
end
