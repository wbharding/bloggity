class BlogCommentsController < ApplicationController
	helper :blogs
	before_filter :login_required
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
		@blog_comment = current_user.blog_comments.find(params[:id])
	end

	def update
		@blog_comment = current_user.blog_comments.find(params[:id])
		@blog_comment.update_attributes(params[:blog_comment])
		redirect_to(blog_named_link(@blog))
	end
	
  def destroy
		c = BlogComment.find(params[:id])
		c.destroy
		redirect_to(params[:referring_url])
	end
		
end
