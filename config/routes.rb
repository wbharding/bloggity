ActionController::Routing::Routes.draw do |map|
  map.resources :blogs, :member => { :feed => :get } do |blogs|
		blogs.resources :blog_posts, :collection => { :create_asset => :post }, :member => { :close => :get }
	end
	
	map.connect 'blogs/:blog_url_id_or_id', :controller => 'blog_posts', :action => 'index'
	map.connect 'blogs/:blog_url_id_or_id/:id', :controller => 'blog_posts', :action => 'show'
	
end
