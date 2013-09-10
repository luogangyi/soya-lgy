# -*- encoding : utf-8 -*-
class CreateHots < ActiveRecord::Migration
  def change
    create_table :hots do |t|
      t.string :has_keywords
      t.string :without_keywords
      t.string :any_keywords
      t.datetime :start_at
      t.datetime :end_at
    end
  end
end
