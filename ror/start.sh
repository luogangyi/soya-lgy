RAILS_ENV=development script/delayed_job -n 2 start
rake ts:start RAILS_ENV=development
thin start -d -p 3010 -e development