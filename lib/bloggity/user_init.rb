
module Bloggity
  module UserInit

    def self.included(base)
      base.class_eval do
				has_many :blogs
				has_many :blog_comments
				
				#implement in your user model 
				def display_name
					"implement display_name in your user model"
				end
				
				#implement in your user model 
				def blog_author?
					true
				end
				
				#implement in your user model 
				def logged_in?
					true
				end
				
      end
      base.extend(ClassMethods)
    end

    module ClassMethods			
    end
      
  end
end
