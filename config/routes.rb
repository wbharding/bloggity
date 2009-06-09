ActionController::Routing::Routes.draw do |map|
  map.resources :blogs, :member => { :feed => :get } do |blogs|
		blogs.resources :blog_posts, :collection => { :create_asset => :post, :pending => :get }, :member => { :close => :get }
	end
	
	map.resources :blog_categories
	map.resources :blog_assets
	map.resources :blog_comments, :member => { :approve => :get }
	
	map.connect 'blog/:blog_url_id_or_id', :controller => 'blog_posts', :action => 'index'
	map.connect 'blog/:blog_url_id_or_id/:id', :controller => 'blog_posts', :action => 'show'
	map.connect 'blog', :controller => 'blog_posts', :action => 'index', :blog_url_id_or_id => 'main'
end
