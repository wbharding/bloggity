require File.dirname(__FILE__) + '/../test_helper'

class BlogPostsControllerTest < ActionController::TestCase
	def setup
    @routes = ActionController::Routing::Routes
  end
	
	def test_blog_show_normal
		blog = BlogPost.first
		blog_url = "/blogs/#{blog.blog_set.url_identifier}/#{blog.url_identifier}"
		action_hash = @routes.recognize_path blog_url
		
		get action_hash[:action], action_hash
		assert_response :success
		assert_equal assigns(:blog), blog
		assert_equal assigns(:blogs).size, BlogPost.count(:conditions => { :blog_set_id => blog.blog_set_id, :is_complete => true })
		assert_equal assigns(:blog_set_id), blog.blog_set_id
	end

	def test_blog_show_secondary_index
		blog_set = BlogSet.find(:all)[1]
		blog_url = "/blogs/#{blog_set.url_identifier}"
		action_hash = @routes.recognize_path blog_url
		
		get action_hash[:action], action_hash
		assert_response :success
		assert_equal assigns(:blog_set_id), blog_set.id
		assert_equal assigns(:blogs).size, BlogPost.count(:conditions => { :blog_set_id => blog_set.id, :is_complete => true })
		assert_equal assigns(:blogs).first.blog_set_id, blog_set.id
		assert_nil assigns(:blog)
	end
	
	def test_blog_no_show_incomplete
		blog = BlogPost.find(:first, :conditions => { :is_complete => false })
		User.class_eval do
			def can_blog?(blog_set_id = nil)
				false
			end
		end
		
		get :show, :id => blog, :blog_set_id => blog.blog_set
		assert_response :redirect
		assert_nil assigns(:blog)
	end
	
end
