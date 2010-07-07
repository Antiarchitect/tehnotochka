# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ThemeTehnotochkaExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/tehnotochka"

  # Please use tehnotochka/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    Image.attachment_definitions[:attachment][:styles] =
      { :mini => '48x48>', :small => '100x100>', :product => '300x300>',
        :large => '600x600>', :xl => '900x900>' }
  end
end
