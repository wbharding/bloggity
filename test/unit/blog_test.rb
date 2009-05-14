require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
	
	# Replace this with your real tests.
  def test_truth
    assert true
  end
	
	# Test our validations for new blogs
	def test_create
		blog = get_fixture(Blog, "blog_valid")
		assert blog.valid?
		
		blog.blog_set_id = nil
		assert !blog.valid?
		assert blog.errors.on(:blog_set_id)
		
		blog = get_fixture(Blog, "blog_valid")
		user = get_fixture(User, "users_001")
		def user.can_blog?(blog_set_id = nil)
			false
		end
		blog.posted_by = user
		assert !blog.valid?
		assert blog.errors.on(:posted_by_id)
	end
	
	
end
