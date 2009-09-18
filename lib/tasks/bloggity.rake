require 'active_record'
require File.join(File.dirname(__FILE__), '../task_util')
#require 'ruby-debug'

include TaskUtil
#Debugger.start

BLOGGITY_BASE_DIR = File.join(File.dirname(__FILE__), "../..")

namespace :bloggity do 
	desc "Add database tables for bloggity"
	task :bootstrap_db => :environment do
	  CreateBlogTables.up
		puts "Bloggity tables created successfully!"
	end
	
	desc "Copy the stylesheets and Javascripts used natively by bloggity into host app's public directory"
	task :bootstrap_bloggity_assets => :environment do
		destination_root = RAILS_ROOT + "/public/"
    %w(stylesheets images).each{|asset|
      destination_path = destination_root + asset
      unless File.exists?(destination_path)
        FileUtils.mkpath(destination_path)
      end
      Dir[File.join(BLOGGITY_BASE_DIR, 'public', asset, '*')].each{|f|
        FileUtils.cp_r(f, File.expand_path(File.join(destination_root, asset, 'bloggity')))
      }
    }
		puts "Files successfully copied!"
	end
	
	desc "Copy the third party Javascripts (jquery and FCKEditor) by bloggity into host app's public directory"
	task :bootstrap_third_party_assets => :environment do
		destination_dir = RAILS_ROOT + "/public/javascripts/bloggity"
		FileUtils.cp_r(File.join(BLOGGITY_BASE_DIR, 'public/javascripts/third_party/.'), destination_dir)
    #Engines.mirror_files_from(BLOGGITY_BASE_DIR + "/public/javascripts/third_party", destination_dir)
		puts "Files successfully copied to #{destination_dir}!"
	end
	
	desc "Run all Bloggity tests"
	task :run_tests => :environment do 
		Rake::Task['bloggity:test:blog_posts'].invoke 
		Rake::Task['bloggity:test:blog_post'].invoke 
	end
	
	desc "Run a Bloggity test"
	rule "" do |t|
		# test:file:method
		if /bloggity\:test:(.*)(:([^.]+))?$/.match(t.name)
			arguments = t.name.split(":")[1..-1]
			arguments.delete("test")
			file_name = arguments.first
			test_name = arguments[1..-1] 
			
			if File.exist?(BLOGGITY_BASE_DIR + "/test/unit/#{file_name}_test.rb")
				run_file_name = "unit/#{file_name}_test.rb" 
			elsif File.exist?(BLOGGITY_BASE_DIR + "/test/functional/#{file_name}_controller_test.rb")
				run_file_name = "functional/#{file_name}_controller_test.rb" 
			elsif File.exist?(BLOGGITY_BASE_DIR + "/test/functional/#{file_name}_test.rb")
				run_file_name = "functional/#{file_name}_test.rb" 
			end
			
			sh "ruby -Ilib:test #{BLOGGITY_BASE_DIR}/test/#{run_file_name} -n /#{test_name}/"
		end
	end
	
end

class CreateBlogTables < ActiveRecord::Migration
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
		
	  add_index "blogs", ["url_identifier"], :name => "index_blogs_on_url_identifier"
		
	  create_table "blog_categories" do |t|
	    t.string   "name"
			t.integer  "parent_id"
	    t.integer  "blog_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
	
		add_index "blog_categories", ["blog_id"], :name => "index_blog_categories_on_blog_id"
	  add_index "blog_categories", ["parent_id"], :name => "index_blog_categories_on_parent_id"
	
	  create_table "blog_comments" do |t|
	    t.integer  "user_id"
	    t.integer  "blog_post_id"
	    t.text     "comment"
	    t.boolean  "approved"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
	  
		add_index "blog_comments", ["blog_post_id"], :name => "index_blog_comments_on_blog_post_id"
		
		create_table "blog_tags" do |t|
			t.string   "name"
			t.integer  "blog_post_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
		end
					
	  add_index "blog_tags", ["blog_post_id"], :name => "index_blog_tags_on_blog_post_id"
		
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
	
	  add_index "blog_posts", ["category_id"], :name => "index_blog_posts_on_category_id"
		add_index "blog_posts", ["url_identifier"], :name => "index_blog_posts_on_url_identifier"
		add_index "blog_posts", ["blog_id"], :name => "index_blog_posts_on_blog_id"

		Blog.create(:title => "My Bloggity Blog", :subtitle => "No, this blog doesn't have a subtitle.  What's it to ya?", :url_identifier => 'main')
	end
end
