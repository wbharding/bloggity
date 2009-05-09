# == Schema Information
# Schema version: 20090406223746
#
# Table name: blogs
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)     
#  body            :text            
#  is_indexed      :boolean(1)      
#  tags            :string(255)     
#  posted_by_id    :integer(4)      
#  is_complete     :boolean(1)      
#  created_at      :datetime        
#  updated_at      :datetime        
#  url_identifier  :string(255)     
#  comments_closed :boolean(1)      
#  category_id     :integer(4)      
#  fck_created     :boolean(1)      
#  blog_set_id     :integer(4)      
#

class Blog < ActiveRecord::Base
	belongs_to :posted_by, :class_name => 'User'
  belongs_to :category, :class_name => 'BlogCategory'
	has_many :comments, :class_name => 'BlogComment'
	has_many :images, :class_name => 'BlogAsset'
	belongs_to :blog_set
	
	validates_presence_of :blog_set_id, :posted_by_id
	validate :authorized_to_blog?
	
	# Recommended... but only if you have it:
	# xss_terminate :except => [ :body ]
	
	before_save :update_url_identifier
	
	def update_url_identifier
		return if self.title.blank?
		self.url_identifier = self.title.strip.gsub(/\W/, '_')
		true
	end
	
	def comments_closed?
		self.comments_closed
	end
	
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	private
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	
	def authorized_to_blog?
		unless(self.posted_by.can_blog?(self.blog_set_id))
			self.errors.add(:blog_set_id, "is not authorized to post to this blog")
		end
	end
end
