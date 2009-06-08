module BloggityPageNames
	
	# Define non-standard page names to be used in title bar and breadcrumbs
	# If an entry isn't in this list, we'll assume it's name is "#{action_name} #{controller_name}"
	PAGE_NAMES = { 
		:blog_posts => { :index => "Blog" },
	}
			
	# ---------------------------------------------------------------------------
	# Figure out the name for a page from its controller and action.  First we check
	# the table of exceptions (above), and if not, we create the name from the action/controller
	# combo 
	def look_up_page_name(controller_name, action_name)
		if (PAGE_NAMES[controller_name.to_sym] && PAGE_NAMES[controller_name.to_sym][action_name.to_sym])
			page_name = PAGE_NAMES[controller_name.to_sym][action_name.to_sym]
		else
			action_name += "_" + controller_name.singularize if action_name.index(/edit|show|new/)
			page_words = action_name.split("_")
			page_words.collect! do |word|
				word.capitalize + " "
			end
			page_words.to_s
		end		 
	end
	
end
