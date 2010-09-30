# setting defaults for project
if Spree::Config.instance
  # locale defaults
  Spree::Config.set(:allow_locale_switching => false)

  # production mail config
  Spree::Config.set(:enable_mail_delivery => true)
  Spree::Config.set(:mail_host => 'smtp.sendgrid.net')
  Spree::Config.set(:mail_domain => ENV['SENDGRID_DOMAIN'])
  Spree::Config.set(:smtp_username => ENV['SENDGRID_USERNAME'])
  Spree::Config.set(:smtp_password => ENV['SENDGRID_PASSWORD'])
  Spree::Config.set(:mails_from => 'tehnotochka.ru')
  Spree::Config.set(:order_from => 'orders@tehnotochka.ru')
  Spree::Config.set(:mail_auth_type => 'plain')

  #bells and whistles
  Spree::Config.set(:products_per_page => 12)
  Spree::Config.set(:logo => '/images/my_logo.png')
end