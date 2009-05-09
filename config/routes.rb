ActionController::Routing::Routes.draw do |map|
  map.resources :blogs, :collection => { :feed => :get, :create_asset => :post }
	map.connect 'blog/:set_or_blog_id/:id', :controller => 'blogs', :action => 'show'
  
	map.resources :blog_comments
  map.resources :blog_categories

end
