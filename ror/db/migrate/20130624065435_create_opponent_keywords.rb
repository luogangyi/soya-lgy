# -*- encoding : utf-8 -*-
class CreateOpponentKeywords < ActiveRecord::Migration
  def change
    create_table :opponent_keywords do |t|
      t.string :str
      t.string :enstr
    end
  end
end
