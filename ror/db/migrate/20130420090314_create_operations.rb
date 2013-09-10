# -*- encoding : utf-8 -*-
class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.boolean :handled, :default => false
      t.boolean :ignored, :default => false
      t.boolean :handled_alert, :default => false
      t.boolean :ignored_alert, :default => false
      t.references :operatable, :polymorphic => true
    end
  end
end
