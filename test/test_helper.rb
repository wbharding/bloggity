$:.unshift(File.dirname(__FILE__) + '/../lib')

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require 'test/unit'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))
require 'active_record'
require 'active_record/fixtures'
require 'action_controller/test_process'
#require 'ruby-debug'
#Debugger.start

FIXTURE_DIR = File.dirname(__FILE__) + '/fixtures'
BLOGGITY_TABLES = ["blog_posts", "blog_comments", "blogs", "users"]
file = FIXTURE_DIR + "/schema.rb"
load(file)

@fixtures = Fixtures.create_fixtures(FIXTURE_DIR, BLOGGITY_TABLES)
@built_fixtures = {}
BLOGGITY_TABLES.each_with_index { |table, idx| @built_fixtures[table] = @fixtures[idx] }
BLOGGITY_FIXTURES = @built_fixtures

def get_fixture(class_name, record_name)
	class_name.find(BLOGGITY_FIXTURES[class_name.table_name][record_name]["id"])
end

#require File.join(File.dirname(__FILE__), 'fixtures/attachment')
#require File.join(File.dirname(__FILE__), 'base_attachment_tests')