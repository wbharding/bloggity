class BlogsController < ApplicationController
  before_filter :get_page_name
	before_filter :blog_writer_or_redirect, :except => [:close, :index, :show, :feed]
	
	# GET /blogs
  # GET /blogs.xml
  def index
		blog_show_params = params[:blog_show_params] || {}
    @blogs = Blog.paginate(:all, :conditions => ["is_indexed = ? AND is_complete = ? AND blog_set_id = ?", true, true, @blog_set_id], :order => "blogs.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		set_page_title("Relentless Simplicity - The Bonanzle Blog")
    
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end
	
	def close
		@blog = Blog.find(params[:id])
		@blog.update_attribute(:comments_closed, true)
		redirect_to( :action => :show, :id => @blog )
	end

  # GET the blog as a feed
	def feed
		@blogs = Blog.find(:all, :conditions => ["is_indexed = ? AND is_complete = ? AND blog_set_id = ?", true, true, @blog_set_id], :order => "blogs.created_at DESC", :limit => 15)
		render :action => :feed, :layout => false
	end
	
	# Upload a blog asset
	def create_asset
		image_params = params[:blog_asset] || {}
		@image = BlogAsset.new(image_params)
		@image.blog_id = image_params[:blog_id] # Can't mass-assign attributes of attachment_fu, so we'll set it manually here
		@image.save

		render :text => @image.public_filename
	end
	
  # GET /blogs/1
  # GET /blogs/1.xml
  def show
		blog_show_params = params[:blog_show_params] || {}
		@blogs = Blog.paginate(:all, :conditions => ["is_indexed = ? AND is_complete = ? AND blog_set_id = ?", true, true, @blog_set_id], :order => "created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
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
    @blog = Blog.new(:posted_by_id => current_user, :fck_created => true)
		@blog.save # save it before we start editing it so we can know it's ID when it comes time to add images/assets
		redirect_to(:controller => 'blogs', :action => :edit, :id => @blog)
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

		respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to(@blog) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
			if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end

end
