module BlogsHelper
	def blog_named_link(blog, the_action = :show)
		{ :controller => 'blogs', :action => the_action, :id => (blog.url_identifier || blog.id) }
	end
end
