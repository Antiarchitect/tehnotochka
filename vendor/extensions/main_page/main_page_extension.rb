# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MainPageExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/main_page"

  # Please use main_page/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    Spree::BaseHelper.module_eval do
      def meta_data_tags
        taxon_names = Taxon.all(:select => [:name], :conditions => ['taxons.parent_id IS NOT NULL']).map { |t| t.name }.join(' ')
        "".tap do |tags|
          if self.respond_to?(:object) && object
            if object.respond_to?(:meta_keywords) and object.meta_keywords.present?
              tags << tag('meta', :name => 'keywords', :content => [taxon_names, object.meta_keywords].join(' ')) + "\n"
            else
              tags << tag('meta', :name => 'keywords', :content => taxon_names) + "\n"
            end
            if object.respond_to?(:meta_description) and object.meta_description.present?
              tags << tag('meta', :name => 'description', :content => [taxon_names, object.meta_description].join(' ')) + "\n"
            else
              tags << tag('meta', :name => 'description', :content => taxon_names) + "\n"
            end
          else
            tags << tag('meta', :name => 'keywords', :content => taxon_names) + "\n"
            tags << tag('meta', :name => 'description', :content => taxon_names) + "\n"
          end
        end
      end
    end
  end
end
