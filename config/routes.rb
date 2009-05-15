ActionController::Routing::Routes.draw do |map|
  map.resources :blog_sets, :member => { :feed => :get } do |blog_sets|
		blog_sets.resources :blogs, :collection => { :create_asset => :post }, :member => { :close => :get }
	end
	
	map.connect 'blogs/:blog_url_id_or_id', :controller => 'blogs', :action => 'index'
	map.connect 'blogs/:blog_url_id_or_id/:id', :controller => 'blogs', :action => 'show'
	
end
