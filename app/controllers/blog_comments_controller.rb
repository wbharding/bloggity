class BlogCommentsController < ApplicationController
	helper :blogs
	before_filter :login_required
	before_filter :load_blog_comment, :only => [:edit, :update, :destroy]
	before_filter :blog_writer_or_redirect, :only => [:destroy]
	
  # POST /blogs_comments
	# POST /blogs_comments.xml
	def create
		@blog_comment = BlogComment.new(params[:blog_comment])
		@blog_comment.user_id = current_user.id
		
		if @blog_comment.save
			@blog = @blog_comment.blog
			redirect_to(blog_named_link(@blog))
		else
			render :action => "new"
		end
	end

	def edit
	end

	def update
		@blog_comment.update_attributes(params[:blog_comment])
		redirect_to(blog_named_link(@blog))
	end
	
  def destroy
		@blog_comment.destroy
		redirect_to(params[:referring_url])
	end
	
	def load_blog_comment 
		@blog_comment = BlogComment.find(params[:id])
		@blog = @blog_comment.try(:blog)
		@blog_set = @blog.try(:blog_set)
		unless current_user && @blog_comment && ((current_user == @blog_comment.user) || (current_user.can_moderate_comments?(@blog_set && @blog_set.id)))
			flash[:error] = "You don't have permission to edit that comment"
			redirect_to blog_named_link(@blog)
			false
		else
			true
		end
	end
end
