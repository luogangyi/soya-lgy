# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# ENV['RAILS_ENV'] ||= 'production'

# Initialize the rails application
Soya::Application.initialize!

CLASSIFIER_SERVER = "http://localhost:8080/soya/classify"
CLASSIFIER_SERVER_TRAIN = "http://localhost:8080/soya/train"

ActionMailer::Base.default_url_options = { :host => 'localhost',:port=>3010 }
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "smtp.ym.163.com",
    :port => 25,
    :domain => "tbs-info.com",
    :authentication => :login,
    :user_name => "service@tbs-info.com",
    :password => "7VezYcu1MU"
}
