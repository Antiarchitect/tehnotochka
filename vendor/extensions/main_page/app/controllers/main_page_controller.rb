class MainPageController < Spree::BaseController
  rescue_from ActionView::MissingTemplate, :with => :render_404
  helper 'products'
  def index
    taxonomy = Taxonomy.find_by_name('Категории')
    #@taxons = taxonomy.root.children.compact
  end
end
