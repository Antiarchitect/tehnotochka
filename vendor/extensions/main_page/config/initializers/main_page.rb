unless Spree::Config[:stylesheets].include?('main_page')
  Spree::Config.set(:stylesheets => "#{Spree::Config[:stylesheets]},main_page")
end