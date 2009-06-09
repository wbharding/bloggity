class BlogCategoriesController < ApplicationController
  before_filter :load_blog_category, :only => [:show, :edit, :destroy, :update]
	before_filter :can_modify_blogs_or_redirect
	
	# GET /blog_categories
  # GET /blog_categories.xml
  def index
    @blog_categories = BlogCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_categories }
    end
  end

  # GET /blog_categories/1
  # GET /blog_categories/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog_category }
    end
  end

  # GET /blog_categories/new
  # GET /blog_categories/new.xml
  def new
    @blog_category = BlogCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog_category }
    end
  end

  # GET /blog_categories/1/edit
  def edit
  end

  # POST /blog_categories
  # POST /blog_categories.xml
  def create
    @blog_category = BlogCategory.new(params[:blog_category])

    respond_to do |format|
      if @blog_category.save
        flash[:notice] = 'BlogCategory was successfully created.'
        format.html { redirect_to(@blog_category) }
        format.xml  { render :xml => @blog_category, :status => :created, :location => @blog_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blog_categories/1
  # PUT /blog_categories/1.xml
  def update
    respond_to do |format|
      if @blog_category.update_attributes(params[:blog_category])
        flash[:notice] = 'BlogCategory was successfully updated.'
        format.html { redirect_to(@blog_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_categories/1
  # DELETE /blog_categories/1.xml
  def destroy
    @blog_category.destroy

    respond_to do |format|
      format.html { redirect_to(blog_categories_url) }
      format.xml  { head :ok }
    end
  end
	
	private
	
	def load_blog_category
		@blog_category = BlogCategory.find(params[:id])
		@blog_id = @blog_category.try(:blog_id)
	end
end
