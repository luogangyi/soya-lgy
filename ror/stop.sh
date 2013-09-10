RAILS_ENV=development script/delayed_job -n 2 stop
rake ts:stop RAILS_ENV=development
thin stop -e development