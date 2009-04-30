class BlogCommentsController < ApplicationController
	before_filter :login_required
	before_filter :blog_writer_or_redirect, :only => [:destroy]
	
  # POST /blogs_comments
	# POST /blogs_comments.xml
	def create
		@blog_comment = BlogComment.new(params[:blog_comment])
		@blog_comment.user_id = current_user.id
		
		respond_to do |format|
			if @blog_comment.save
				@blog = @blog_comment.blog
				flash[:notice] = 'Blog comment was successfully created.'
				format.html { redirect_to(@blog) }
				format.xml  { render :xml => @blog, :status => :created, :location => @blog }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
			end
		end
	end

	def edit
		@blog_comment = current_user.blog_comments.find(params[:id])
	end

	def update
		@blog_comment = current_user.blog_comments.find(params[:id])
		@blog_comment.update_attributes(params[:blog_comment])
		redirect_to(:controller => 'blogs', :action => :show, :id => @blog_comment.blog.id)
	end
	
  def destroy
		c = Comment.find(params[:id])
		c.destroy
		redirect_to(params[:referring_url])
	end
		
end
