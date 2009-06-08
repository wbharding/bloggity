ActiveRecord::Schema.define do
	def self.up
		create_table "blog_assets" do |t|
	    t.integer "blog_post_id"
	    t.integer "parent_id"
	    t.string  "content_type"
	    t.string  "filename"
	    t.string  "thumbnail"
	    t.integer "size"
	    t.integer "width"
	    t.integer "height"
	  end
		
	  create_table "blogs" do |t|
	    t.string   "title"
			t.string   "subtitle"
			t.string   "url_identifier"
			t.string   "stylesheet"
			t.string   "feedburner_url"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
		
	  create_table "blog_categories" do |t|
	    t.string   "name"
			t.integer  "parent_id"
	    t.integer  "blog_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
		
		create_table "blog_comments" do |t|
	    t.integer  "user_id"
	    t.integer  "blog_post_id"
	    t.text     "comment"
	    t.boolean  "approved"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
	  
		create_table "blog_tags" do |t|
			t.string   "name"
			t.integer  "blog_post_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
		end
		
	  create_table "blog_posts" do |t|
	    t.string   "title"
	    t.text     "body"
	    t.string   "tag_string"
	    t.integer  "posted_by_id"
	    t.boolean  "is_complete"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.string   "url_identifier"
	    t.boolean  "comments_closed"
	    t.integer  "category_id"
	    t.integer  "blog_id",   :default => 1
	    t.boolean  "fck_created"
	  end
		
end