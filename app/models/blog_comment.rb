# == Schema Information
# Schema version: 119
#
# Table name: comments
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  record_id  :integer(11)     
#  comment    :text            
#  approved   :boolean(1)      
#  created_at :datetime        
#  updated_at :datetime        
#

class BlogComment < Comment
	belongs_to :user
	belongs_to :blog, :foreign_key => :record_id
	 
	validates_presence_of :record_id, :user_id, :comment
end
