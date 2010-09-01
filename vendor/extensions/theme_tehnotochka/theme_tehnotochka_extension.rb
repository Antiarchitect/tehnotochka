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
    TaxonsHelper.module_eval do
      def taxon_preview(taxon, max=4)
        products = taxon.products.active.find(:all, :limit => max)
        if (products.size < max) && Spree::Config[:show_descendents]
          taxon.descendents.each do |taxon|
            to_get = max - products.length
            products += taxon.products.active.find(:all, :limit => to_get)
            break if products.size >= max
          end
        end
        products
      end
    end
  end
end
