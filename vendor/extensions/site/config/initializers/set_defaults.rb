# setting defaults for project
if Spree::Config.instance
  # locale defaults
  Spree::Config.set(:default_locale => 'ru-RU')
  Spree::Config.set(:allow_locale_switching => false)

  # production global config
  Spree::Config.set(:site_name => 'Техноточка')
  Spree::Config.set(:site_url => 'tehnotochka.heroku.com')

  # production mail config
  Spree::Config.set(:enable_mail_delivery => true)
  Spree::Config.set(:mail_host => 'smtp.sendgrid.net')
  Spree::Config.set(:mail_domain => ENV['SENDGRID_DOMAIN'])
  Spree::Config.set(:smtp_username => ENV['SENDGRID_USERNAME'])
  Spree::Config.set(:smtp_password => ENV['SENDGRID_PASSWORD'])
  Spree::Config.set(:mails_from => 'tehnotochka.heroku.com')
  Spree::Config.set(:order_from => 'orders@tehnotochka.heroku.com')
  Spree::Config.set(:mail_auth_type => MAIL_AUTH[1])
end