# Put your extension routes here.

map.resources :orders, :member => {:receipt => :get, :invoice => :get}
map.namespace :admin do |admin|
  admin.resources :orders, :member => {:waybill => :get, :cash_memo => :get}
end
map.connect 'robo_kassa/:action', :controller => 'robo_kassa'
