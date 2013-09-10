# -*- encoding : utf-8 -*-
class CreateAnalysisCategorizeds < ActiveRecord::Migration
  def change
    create_table :analysis_categorizeds do |t|
      t.references :analysable, :polymorphic => true
      t.references :category
      t.references :label
    end
    add_index :analysis_categorizeds, :analysable_id
    add_index :analysis_categorizeds, :category_id
    add_index :analysis_categorizeds, :label_id
  end
end
