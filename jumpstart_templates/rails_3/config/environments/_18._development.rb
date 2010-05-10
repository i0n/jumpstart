config.action_mailer.default_url_options = {:host => "#{replace_project_name}.local"}

# Remember that sending email through local postfix/sendmail will not work when trying to deliver directly to a googlemail address.
# Use an alternative address that forwards to googlemail
config.action_mailer.delivery_method = :sendmail
