# -*- encoding : utf-8 -*-
class CreateSiteInfos < ActiveRecord::Migration
  def change
    create_table :site_infos do |t|
      t.string :key
      t.string :value
    end
  end
end
