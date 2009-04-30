# == Schema Information
# Schema version: 182
#
# Table name: comments
#
#  id         :integer(11)     not null, primary key
#  type       :string(255)     
#  record_id  :integer(11)     
#  user_id    :integer(11)     
#  comment    :text            
#  approved   :boolean(1)      
#  created_at :datetime        
#  updated_at :datetime        
#

class Comment < ActiveRecord::Base
	belongs_to :user
	attr_protected :approved
	
	validates_presence_of :record_id, :user_id, :comment
end
