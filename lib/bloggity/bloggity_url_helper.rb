# Here's a location to keep task-specific defines
module BloggityUrlHelper
	
	# Create a named url for the blog and action combination
	def blog_named_link(blog, the_action = :show, options = {})
		case the_action
		when :show: "/blogs/#{blog.blog_set.url_identifier}/#{blog.url_identifier}"
		when :index: "/blogs/#{options[:blog_set].url_identifier}"
		when :feed: { :controller => 'blog_sets', :id => options[:blog_set].url_identifier, :action => :feed }
		else
			{ :controller => 'blogs', :action => the_action, :blog_set_id => (options[:blog_set] && options[:blog_set].id) || blog.blog_set_id, :id => blog }
		end
	end
	
	
end
