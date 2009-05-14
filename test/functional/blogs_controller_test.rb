require File.dirname(__FILE__) + '/../test_helper'

class BlogsControllerTest < ActionController::TestCase
	def setup
    @routes = ActionController::Routing::Routes
  end
	
	def test_blog_show_normal
		blog = Blog.first
		blog_url = "/blogs/#{blog.blog_set.url_identifier}/#{blog.url_identifier}"
		action_hash = @routes.recognize_path blog_url
		
		get action_hash[:action], action_hash
		assert_response :success
		assert_equal assigns(:blog), blog
		assert_equal assigns(:blogs).size, Blog.count(:conditions => { :blog_set_id => blog.blog_set_id, :is_complete => true })
		assert_equal assigns(:blog_set_id), blog.blog_set_id
	end

	def test_blog_show_secondary_index
		blog_set = BlogSet.find(:all)[1]
		blog_url = "/blogs/#{blog_set.url_identifier}"
		action_hash = @routes.recognize_path blog_url
		
		get action_hash[:action], action_hash
		assert_response :success
		assert_equal assigns(:blog_set_id), blog_set.id
		assert_equal assigns(:blogs).size, Blog.count(:conditions => { :blog_set_id => blog_set.id, :is_complete => true })
		debugger
		assert_equal assigns(:blogs).first.blog_set_id, blog_set.id
		assert_nil assigns(:blog)
	end
	
	
end
