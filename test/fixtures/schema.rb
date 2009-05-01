ActiveRecord::Schema.define do
	create_table "blog_assets", :force => true do |t|
    t.integer "blog_id"
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end
	
  create_table "blog_categories", :force => true do |t|
    t.string   "name"
		t.integer  "parent_id"
    t.integer  "group_id",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end
	
  create_table "blog_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "blog_id"
    t.text     "comment"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
	
  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "is_indexed"
    t.string   "tags"
    t.integer  "posted_by_id"
    t.boolean  "is_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_identifier"
    t.boolean  "comments_closed"
    t.integer  "category_id"
    t.boolean  "fck_created"
  end
end