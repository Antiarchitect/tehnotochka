# setting defaults for project
if Spree::Config.instance
  # locale defaults
  Spree::Config.set(:allow_locale_switching => false)

  #bells and whistles
  Spree::Config.set(:products_per_page => 12)
end