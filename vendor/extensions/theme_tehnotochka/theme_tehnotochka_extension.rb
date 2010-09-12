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

      def breadcrumbs(taxon, separator="&nbsp;&raquo;&nbsp;")
        return "" if current_page?("/")
        separator = raw(separator)
        crumbs = [content_tag(:li, link_to(t(:home) , root_path) + separator)]
        if taxon
          crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + separator) } unless taxon.ancestors.empty?
          crumbs << content_tag(:li, content_tag(:span, taxon.name))
        else
          crumbs << content_tag(:li, content_tag(:span, t('products')))
        end
        crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join))
        content_tag(:div, crumb_list + tag(:br, {:class => 'clear'}, false, true), :class => 'breadcrumbs')
      end
    end
  end
end
