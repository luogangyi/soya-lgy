# -*- encoding : utf-8 -*-
class CreatePythonTasks < ActiveRecord::Migration
  def change
    create_table :python_tasks do |t|
      t.string :filename
      t.decimal :period
      t.string :remark
	  t.boolean :enable

      t.timestamps
    end
  end
end
