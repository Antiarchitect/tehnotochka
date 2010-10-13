# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ThemeTehnotochkaExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://tehnotochka.ru"

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
        products = taxon.products.active.all
        if Spree::Config[:show_descendents]
          taxon.descendents.each do |taxon|
            products += taxon.products.active.all
          end
        end
        products.sort_by(&:price)[0, max]
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

      def count_products(taxon)
        count = 0
        taxon.self_and_descendants.each do |t|
          count += t.products.active.all.size
        end
        count
      end
    end

    Spree::Search.module_eval do
      def retrieve_products
        # taxon might be already set if this method is called from TaxonsController#show
        @taxon ||= Taxon.find_by_id(params[:taxon]) unless params[:taxon].blank?
        # add taxon id to params for searcher
        params[:taxon] = @taxon.id if @taxon
        @keywords = params[:keywords]

        per_page = params[:per_page].to_i
        per_page = per_page > 0 ? per_page : Spree::Config[:products_per_page]
        params[:per_page] = per_page
        params[:page] = 1 if (params[:page].to_i <= 0)

        # Prepare a search within the parameters
        Spree::Config.searcher.prepare(params)

        if !params[:order_by_price].blank?
          @product_group = ProductGroup.new.from_route([params[:order_by_price]+"_by_master_price"])
        elsif params[:product_group_name]
          @cached_product_group = ProductGroup.find_by_permalink(params[:product_group_name])
          @product_group = ProductGroup.new
        elsif params[:product_group_query]
          @product_group = ProductGroup.new.from_route(params[:product_group_query])
        else
          @product_group = ProductGroup.new
        end

        @product_group.add_scope('in_taxon', @taxon) unless @taxon.blank?
        @product_group.add_scope('keywords', @keywords) unless @keywords.blank?
        @product_group = @product_group.from_search(params[:search]) if params[:search]

        base_scope = @cached_product_group ? @cached_product_group.products.active : Product.active
        base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
        @products_scope = @product_group.apply_on(base_scope)

        curr_page = Spree::Config.searcher.manage_pagination ? 1 : params[:page]
        @products = @products_scope.all(:order => 'name ASC').paginate({
            :include  => [:images, :master],
            :per_page => per_page,
            :page     => curr_page
          })
        @products_count = @products_scope.count

        return(@products)
      end
    end
  end
end
