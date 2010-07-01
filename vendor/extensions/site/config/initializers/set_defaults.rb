# setting defaults for project
if Spree::Config.instance
  # locale defaults
  Spree::Config.set(:allow_locale_switching => false)
end