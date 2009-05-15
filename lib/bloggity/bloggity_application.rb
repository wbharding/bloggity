require 'bloggity/bloggity_page_names'
require 'bloggity/bloggity_url_helper'

module Bloggity::BloggityApplication
	include BloggityPageNames
	include BloggityUrlHelper
	
	# Implement in your application
	def current_user
		User.find(1)
	end
	
	# Implement in your application
	def login_required
		if current_user
      true
    else
			flash[:error] = "Login required to do this action."
			redirect_to :controller => "blogs" # Send them to wherever they login on your site...
	    false
	  end
  end
	
	def blog_logged_in?
		current_user && current_user.logged_in?
	end
	
	def load_blog_set
		if(!params[:blog_set_id] && (blog_set_url_identifier = params[:blog_url_id_or_id]))
			@blog_set = BlogSet.find_by_url_identifier(blog_set_url_identifier)
		end
		@blog_set_id = params[:blog_set_id] || (@blog_set && @blog_set.id) || 1 # There is a default BlogSet created when the DB is bootstrapped, so we know we'll be able to fall back on this
		@blog_set = BlogSet.find(@blog_set_id) unless @blog_set
	end
	
	def blog_writer_or_redirect
		if @blog_set_id && current_user && current_user.can_blog?(@blog_set_id) 
			true
		else
			flash[:error] = "You don't have permission to do that."
			redirect_to :controller => "blogs" 
	    false
		end
	end
	
	def blog_comment_moderator_or_redirect
		if @blog_set_id && current_user && current_user.can_moderate_blog_comments?(@blog_set_id) 
			true
		else
			flash[:error] = "You don't have permission to do that."
			redirect_to :controller => "blogs" 
			false
		end
	end
	
  def get_bloggity_page_name
  	@page_name = look_up_page_name(params[:controller], params[:action])
  end
  
end
