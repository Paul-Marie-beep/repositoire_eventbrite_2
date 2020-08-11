# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!


ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_LOGIN'],
  :password => ENV['SENDGRID_PWD'],
  :domain => 'smtp.sendgrid.net',
  :address => 'https://fierce-plateau-62518.herokuapp.com',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}