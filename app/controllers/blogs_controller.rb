class BlogsController < ApplicationController
  before_filter :get_page_name
	before_filter :load_blog
	before_filter :blog_writer_or_redirect, :except => [:close, :index, :show, :feed]
	
	# GET /blogs
  # GET /blogs.xml
  def index
		blog_show_params = params[:blog_show_params] || {}
    search_condition = { :blog_set_id => @blog_set_id, :is_complete => true }
		search_condition.merge!(:blog_tags => { :name => params[:tag_name] }) if params[:tag_name]
		@blogs = Blog.paginate(:all, :select => "DISTINCT blogs.*", :conditions => search_condition, :joins => :tags, :order => "blogs.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		set_page_title(@blog_set.title)
    
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end
	
	def close
		@blog = Blog.find(params[:id])
		@blog.update_attribute(:comments_closed, true)
		redirect_to blog_named_link(@blog)
	end

  # GET the blog as a feed
	def feed
		@blogs = Blog.find(:all, :conditions => ["blog_set_id = ? AND is_complete = ?", @blog_set_id, true], :order => "blogs.created_at DESC", :limit => 15)
		render :action => :feed, :layout => false
	end
	
	# Upload a blog asset
	def create_asset
		image_params = params[:blog_asset] || {}
		debugger
		@image = BlogAsset.new(image_params)
		@image.blog_id = image_params[:blog_id] # Can't mass-assign attributes of attachment_fu, so we'll set it manually here
		@image.save!
		render :text => @image.public_filename
	end
	
  # GET /blogs/1
  # GET /blogs/1.xml
  def show
		blog_show_params = params[:blog_show_params] || {}
		@blogs = Blog.paginate(:all, :conditions => ["blog_set_id = ? AND is_complete = ?", @blog_set_id, true], :order => "created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		@blog = Blog.find(:first, :conditions => ["id = ? OR url_identifier = ?", params[:id], params[:id]])

		if !@blog || (!@blog.is_complete && !current_user.can_blog?(@blog.blog_set_id))
			flash[:error] = "You do not have permission to see this blog."
			return (redirect_to( :action => 'index' ))
		else
			set_page_title(@blog.title)
		end
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new(:posted_by_id => current_user, :fck_created => true, :blog_set_id => @blog_set_id)
		@blog.save # save it before we start editing it so we can know it's ID when it comes time to add images/assets
		redirect_to blog_named_link(@blog, :edit)
  end

  # GET /blogs/1/edit
  def edit
		@blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create
		@blog = Blog.new(params[:blog])
	  @blog.posted_by = current_user

		if(@blog.save)
			redirect_to blog_named_link(@blog)
		else
			render blog_named_link(@blog, :new)
		end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    @blog = Blog.find(params[:id])

    if @blog.update_attributes(params[:blog])
      redirect_to blog_named_link(@blog)
    else
      render blog_named_link(@blog, :edit)
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog.destroy
    redirect_to(blog_named_link(@blog, :index))
  end

	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	private
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	
	def load_blog
		load_blog_set
		@blog = Blog.find(:first, :conditions => ["blog_set_id = ? AND (id = ? OR url_identifier = ?)", @blog_set_id, params[:id], params[:id]]) if params[:id]
	end
end
