class BlogPostsController < ApplicationController
  before_filter :get_bloggity_page_name
	before_filter :load_blog_post
	before_filter :blog_writer_or_redirect, :except => [:close, :index, :show, :feed]
	
	# GET /blog_posts
  # GET /blog_posts.xml
  def index
		blog_show_params = params[:blog_show_params] || {}
    search_condition = { :blog_id => @blog_id, :is_complete => true }
		search_condition.merge!(:blog_tags => { :name => params[:tag_name] }) if params[:tag_name]
		@blog_posts = BlogPost.paginate(:all, :select => "DISTINCT blogs.*", :conditions => search_condition, :include => :tags, :order => "blog_posts.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		@page_name = @blog.title
    
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_posts }
    end
  end
	
	def close
		@blog_post = BlogPost.find(params[:id])
		@blog_post.update_attribute(:comments_closed, true)
		flash[:notice] = "Commenting for this blog has been closed."
		redirect_to blog_named_link(@blog_post)
	end

	# Upload a blog asset
	def create_asset
		image_params = params[:blog_asset] || {}
		@image = BlogAsset.new(image_params)
		@image.blog_post_id = image_params[:blog_post_id] # Can't mass-assign attributes of attachment_fu, so we'll set it manually here
		@image.save!
		render :text => @image.public_filename
	end
	
  # GET /blog_posts/1
  # GET /blog_posts/1.xml
  def show
		blog_show_params = params[:blog_show_params] || {}
		@blog_posts = BlogPost.paginate(:all, :conditions => ["blog_id = ? AND is_complete = ?", @blog_id, true], :order => "created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		@blog_post = BlogPost.find(:first, :conditions => ["id = ? OR url_identifier = ?", params[:id], params[:id]])

		if !@blog_post || (!@blog_post.is_complete && !current_user.can_blog?(@blog_post.blog_id))
			@blog_post = nil
			flash[:error] = "You do not have permission to see this blog."
			return (redirect_to( :action => 'index' ))
		else
			@page_name = @blog_post.title
		end
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog_post }
    end
  end

  # GET /blog_posts/new
  # GET /blog_posts/new.xml
  def new
    @blog_post = BlogPost.new(:posted_by_id => current_user, :fck_created => true, :blog_id => @blog_id)
		@blog_post.save # save it before we start editing it so we can know it's ID when it comes time to add images/assets
		redirect_to blog_named_link(@blog_post, :edit)
  end

  # GET /blog_posts/1/edit
  def edit
		@blog_post = BlogPost.find(params[:id])
  end

  # POST /blog_posts
  # POST /blog_posts.xml
  def create
		@blog_post = BlogPost.new(params[:blog_post])
	  @blog_post.posted_by = current_user

		if(@blog_post.save)
			redirect_to blog_named_link(@blog_post)
		else
			render blog_named_link(@blog_post, :new)
		end
  end

  # PUT /blog_posts/1
  # PUT /blog_posts/1.xml
  def update
    @blog_post = BlogPost.find(params[:id])

    if @blog_post.update_attributes(params[:blog_post])
      redirect_to blog_named_link(@blog_post)
    else
      render blog_named_link(@blog_post, :edit)
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.xml
  def destroy
    @blog_post.destroy
    redirect_to(blog_named_link(@blog_post, :index))
  end

	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	private
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	
	def load_blog_post
		load_blog
		@blog_post = BlogPost.find(:first, :conditions => ["blog_id = ? AND (id = ? OR url_identifier = ?)", @blog_id, params[:id], params[:id]]) if params[:id]
	end
end
