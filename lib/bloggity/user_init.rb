require 'md5' # Needed only if you want to use gravatars

module Bloggity
  module UserInit

    def self.included(base)
      base.class_eval do
				# Copy these to your user model
				has_many :blog_posts
				has_many :blog_comments
				
				# Implement in your user model 
				def display_name
					"My name"
				end
				
				# Whether a user can post to a given blog
				# Implement in your user model
				def can_blog?(blog_id = nil)
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
				
				# Whether a user can moderate the comments for a given blog
				# Implement in your user model
				def can_moderate_blog_comments?(blog_id = nil)
					true
				end
				
				# Whether the comments that a user makes within a given blog are automatically approved (as opposed to being queued until a moderator approves them)
				# Implement in your user model, if you care.
				def blog_comment_auto_approved?(blog_id = nil)
					true
				end
				
				# Whether a user has access to create, edit and destroy blogs
				# Implement in your user model
				def can_modify_blogs?
					true
				end
				
				# Implement in your user model 
				def logged_in?
					true
				end
				
				# The path to your user's avatar.  Here we have sample code to fall back on a gravatar, if that's your bag.
				# Implement in your user model 
				def blog_avatar_url
					if(self.respond_to?(:email))
						downcased_email_address = self.email.downcase
						hash = MD5::md5(downcased_email_address)
						"http://www.gravatar.com/avatar/#{hash}"
					else
						"http://www.pistonsforum.com/images/avatars/avatar22.gif"
					end
				end
				
      end
      base.extend(ClassMethods)
    end

    module ClassMethods			
    end
      
  end
end
