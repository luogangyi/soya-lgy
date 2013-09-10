# -*- encoding : utf-8 -*-
class CreateLabelKeywords < ActiveRecord::Migration
  def change
    create_table :label_keywords do |t|
      t.references :label
      t.string :str

      t.timestamps
    end
    add_index :label_keywords, :label_id
  end
end
