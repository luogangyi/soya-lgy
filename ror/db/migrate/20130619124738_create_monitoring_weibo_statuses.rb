# -*- encoding : utf-8 -*-
class CreateMonitoringWeiboStatuses < ActiveRecord::Migration
  def change
    create_table :monitoring_weibo_statuses do |t|
      t.references :weibo_status

      t.datetime :created_at ,:null => false
      t.datetime :expiring_at ,:null => false
    end
    add_index :monitoring_weibo_statuses, :weibo_status_id,:unique => true
  end
end
