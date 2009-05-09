
module Bloggity
  module UserInit

    def self.included(base)
      base.class_eval do
				has_many :blogs
				has_many :blog_comments
				
				# Implement in your user model 
				def display_name
					"My name"
				end
				
				# Implement in your user model 
				def can_blog?(blog_set_id = nil)
					# This can be implemented however you want, but here's how I would do it, if I were you and I had multiple blogs, 
					# where some users were allowed to write in one set of blogs and other users were allowed to write in a different 
					# set:
					# Create a string field in your user called something like "blog_permissions", and keep a Marshaled array of blogs 
					# that this user is allowed to contribute to.  Ezra gives some details on how to save Marshaled data in Mysql here:
					# http://www.ruby-forum.com/topic/164786
					# To determine if the user is allowed to blog here, call up the array, and see if the blog_set_id
					# is contained in their list of allowable blogs. 
					#
					# Of course, you could also create a join table to join users to blogs they can blog in.  But do you want to do 
					# that with blog comments and ability to moderate comments as well?
					true
				end
				
				# Implement in your user model 
				def can_comment?(blog_set_id = nil)
					true
				end
				
				# Implement in your user model 
				def can_moderate_comments?(blog_set_id = nil)
					true
				end
				
				# Implement in your user model, if you care.
				def comment_auto_approved?(blog_set_id = nil)
					true
				end
				
				# Implement in your user model 
				def logged_in?
					true
				end
				
				# Implement in your user model 
				def avatar_url
					case rand(4) # avatars intended for humor purposes only. do not take these urls seriously.
					when 0: "http://www.pistonsforum.com/images/avatars/avatar22.gif"
					when 1: "http://static.rcgroups.com/forums/customavatars/avatar198263_1.gif"
					when 2: "http://i.pbase.com/u12/swcoulter/upload/38201101.avatar.jpg"
					when 3: "http://www.vistax64.com/httpdocs/customavatars/avatar70155_1.gif"
					end
				end
				
      end
      base.extend(ClassMethods)
    end

    module ClassMethods			
    end
      
  end
end
