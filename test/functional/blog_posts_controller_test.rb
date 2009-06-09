require File.dirname(__FILE__) + '/../test_helper'

class BlogPostsControllerTest < ActionController::TestCase
	def setup
    @routes = ActionController::Routing::Routes
  end
	
	def test_blog_show_normal
		blog_post = BlogPost.first
		blog_url = "/blog/#{blog_post.blog.url_identifier}/#{blog_post.url_identifier}"
		action_hash = @routes.recognize_path blog_url
		
		get action_hash[:action], action_hash
		assert_response :success
		assert_equal assigns(:blog_post), blog_post
		assert_equal assigns(:blog_posts).size, BlogPost.count(:conditions => { :blog_id => blog_post.blog_id, :is_complete => true })
		assert_equal assigns(:blog_id), blog_post.blog_id
	end

	def test_blog_show_secondary_index
		blog_post = BlogPost.find(:all)[1]
		blog_url = "/blog/#{blog_post.blog.url_identifier}"
		action_hash = @routes.recognize_path blog_url
		
		get action_hash[:action], action_hash
		assert_response :success
		assert_equal assigns(:blog_id), blog_post.id
		assert_equal assigns(:blog_posts).size, BlogPost.count(:conditions => { :blog_id => blog_post.blog_id, :is_complete => true })
		assert_equal assigns(:blog_posts).first.blog_id, blog_post.blog_id
		assert_nil assigns(:blog_post)
	end
	
	def test_blog_no_show_incomplete
		blog_post = BlogPost.find(:first, :conditions => { :is_complete => false })
		User.class_eval do
			def can_blog?(blog_id = nil)
				false
			end
		end
		
		get :show, :id => blog_post, :blog_id => blog_post.blog
		assert_response :redirect
		assert_nil assigns(:blog_post)
	end
	
end
