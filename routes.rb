ActionController::Routing::Routes.draw do |map|
  map.resources :blogs, :collection => { :feed => :get, :create_asset => :post }
	map.resources :blog_comments
  map.resources :blog_categories

end
