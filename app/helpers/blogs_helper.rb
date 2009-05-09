module BlogsHelper
	def blog_named_link(blog, the_action = :show, options = {})
		case the_action
			when :show: "/blogs/#{blog.blog_set.url_identifier}/#{blog.url_identifier}"
			when :index: "/blogs/#{options[:blog_set].url_identifier}"
		else
			{ :controller => 'blogs', :action => the_action, :blog_set_id => blog.blog_set_id, :id => blog.id }
		end
	end
	
end
