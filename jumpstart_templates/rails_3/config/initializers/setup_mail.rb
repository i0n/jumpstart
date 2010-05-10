# Settings for using gmail in development

# ActionMailer::Base.smtp_settings = {
#   :address => "smtp.gmail.com",
#   :port => 587,
#   :domain => 'gmail.com',
#   :user_name => 'user_name_goes_here',
#   :password => 'password_goes_here',
#   :authentication => 'plain',
#   :enable_starttls_auto => true
# }

# Sets up an interceptor in lib/development_mail_interceptor.rb that redirects all mail to a specific address in development
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?