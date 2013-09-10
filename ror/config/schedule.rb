# -*- encoding : utf-8 -*-
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

require File.expand_path(File.dirname(__FILE__) + "/environment")
#python_dir = SiteInfo.where(:key => "HASSETTING").first.value
python_dir = SiteInfo.where(:key => "PYTHON_DIR").first.value

PythonTask.where(:enable=>true).each do |task|
   every(task.period.minute) do
	  command "python " + python_dir + task.filename
   end
 end


every 2.days do
  rake "ts:reindex INDEX_ONLY=true" , :environment => 'development' 
end

every(30.minute) { rake 'ts:reindex' , :environment => 'development'  }


every 12.hours do
  command "backup perform -t tbs_backup"
end 

# Learn more: http://github.com/javan/whenever
