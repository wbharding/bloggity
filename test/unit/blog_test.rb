require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
	
	# Test our validations for new blogs
	def test_create
		blog = get_fixture(Blog, "blog_valid_and_posted")
		assert blog.valid?
		
		blog.blog_set_id = nil
		assert !blog.valid?
		assert blog.errors.on(:blog_set_id)
		
		blog = get_fixture(Blog, "blog_valid_and_posted")
		user = get_fixture(User, "users_001")
		def user.can_blog?(blog_set_id = nil)
			false
		end
		blog.posted_by = user
		assert !blog.valid?
		assert blog.errors.on(:posted_by_id)
	end
	
	def test_url_identifier
		blog = get_fixture(Blog, "blog_valid_and_posted")
		blog.is_complete = false
		blog.title = "My first blog"
		blog.save
		assert_equal blog.url_identifier, "My_first_blog"
		
		blog.is_complete = true
		blog.title = "My second blog"
		blog.save
		assert_equal blog.url_identifier, "My_first_blog"
	end
	
	def test_tag_creation
		blog = get_fixture(Blog, "blog_valid_and_posted")
		blog.tag_string = "Pony, horsie, doggie"
		blog.save
		assert_equal blog.tags.size, 3
		
		blog.tag_string = "Parrot"
		blog.save
		assert_equal blog.tags.size, 1
	end
end
