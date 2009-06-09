xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") {
	xml.channel {
		xml.title(@blog.title)  
		#if(!@blog.feedburner_url.blank?)
		#	xml.link(:rel => 'alternate', :type => 'application/rss+xml', :href => @blog.feedburner_url)
		#else
			xml.link(url_for(:only_path => false))
		#end 
		xml.description(@blog.subtitle)  
		xml.language('en-us')  
		for blog_post in @blog_posts
			xml.item do  
				 xml.title(blog_post.title || '')  
				 xml.link(blog_named_link(blog_post))
				 xml.description(blog_post.body)  
				 xml.tag(blog_post.tag_string)  
				 xml.posted_by(blog_post.posted_by.user_name)  
			 end  
		 end  
	}
}