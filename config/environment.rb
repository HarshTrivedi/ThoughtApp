# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ThoughtApp::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name => 'app21034641@heroku.com',
  :password => 'rq9vjtvj',
  :domain => 'http://thoughtapp.herokuapp.com/',
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}