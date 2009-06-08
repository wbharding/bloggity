# == Schema Information
# Schema version: 119
#
# Table name: comments
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  blog_id    :integer(11)     
#  comment    :text            
#  approved   :boolean(1)      
#  created_at :datetime        
#  updated_at :datetime        
#

class BlogComment < ActiveRecord::Base
	belongs_to :user
	belongs_to :blog_post
	attr_protected :approved
	
	validates_presence_of :blog_post_id, :user_id, :comment
	before_create :determine_approval
	
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	private
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	
	def determine_approval
		self.approved = if self.user.blog_comment_auto_approved?(self.blog_post.blog_id)
			true
		else
			false
		end
		true
	end
end
