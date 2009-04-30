require 'active_record'
require File.join(File.dirname(__FILE__), '../task_util')
require 'ruby-debug'

include TaskUtil
Debugger.start

BLOGGITY_BASE_DIR = File.join(File.dirname(__FILE__), "../..")

namespace :bloggity do 
	desc "Add database tables for bloggity"
	task :bootstrap_db => :environment do
	  CreateBlogTables.up
		puts "Bloggity tables created successfully!"
	end
	
	desc "Copy the stylesheets and Javascripts used natively by bloggity into host app's public directory"
	task :bootstrap_bloggity_assets => :environment do
		destination_dir = RAILS_ROOT + "/public/stylesheets/bloggity"
		Engines.mirror_files_from(BLOGGITY_BASE_DIR + "/public/stylesheets", destination_dir)
		puts "Files successfully copied to #{destination_dir}!"
	end
	
	desc "Copy the third party Javascripts (jquery and FCKEditor) by bloggity into host app's public directory"
	task :bootstrap_third_party_assets => :environment do
		destination_dir = RAILS_ROOT + "/public/javascripts/bloggity"
		Engines.mirror_files_from(BLOGGITY_BASE_DIR + "/public/javascripts/third_party", destination_dir)
		puts "Files successfully copied to #{destination_dir}!"
	end
	
end

class CreateBlogTables < ActiveRecord::Migration
	def self.up
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
	
	  add_index "blog_categories", ["group_id"], :name => "index_blog_categories_on_group_id"
	  add_index "blog_categories", ["parent_id"], :name => "index_blog_categories_on_parent_id"
	
	  create_table "blog_comments", :force => true do |t|
	    t.integer  "user_id"
	    t.integer  "blog_id"
	    t.text     "comment"
	    t.boolean  "approved"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end

	  add_index "blog_comments", ["blog_id"], :name => "index_blog_comments_on_blog_id"
		
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
	
	  add_index "blogs", ["category_id"], :name => "index_blogs_on_category_id"

		BlogCategory.create(:name => "Main blog")
	end
end
