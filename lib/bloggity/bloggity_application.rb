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
			redirect_to :controller => "blog_posts" # Send them to wherever they login on your site...
	    false
	  end
  end
	
	def blog_logged_in?
		current_user && current_user.logged_in?
	end
	
	def load_blog
    blog_id = params[:blog_id] || (params[:controller] == 'blogs' && params[:id]) # A little help for trying to access a blog from '/blogs/:id'
		if(blog_id.blank? && (blog_url_identifier = params[:blog_url_id_or_id]))
			@blog = Blog.find_by_url_identifier(blog_url_identifier)
		end
		@blog_id = blog_id || (@blog && @blog.id) || blog_url_identifier || 1 # There is a default BlogSet created when the DB is bootstrapped, so we know we'll be able to fall back on this
		@blog = Blog.find(@blog_id) unless @blog
	end
	
	def blog_writer_or_redirect
		if @blog_id && current_user && current_user.can_blog?(@blog_id)
			true
		else
			flash[:error] = "You don't have permission to do that."
			redirect_to "/blog"
	    false
		end
	end
	
	def blog_comment_moderator_or_redirect
		if @blog_id && current_user && current_user.can_moderate_blog_comments?(@blog_id)
			true
		else
			flash[:error] = "You don't have permission to do that."
			redirect_to "/blog"
			false
		end
	end
	
	def can_modify_blogs_or_redirect
		if(current_user && current_user.can_modify_blogs?)
			true
		else
			redirect_to "/blog"
			false
		end
	end
		
  def get_bloggity_page_name
  	@page_name = look_up_page_name(params[:controller], params[:action])
  end
  
end
