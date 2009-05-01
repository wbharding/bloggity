$:.unshift(File.dirname(__FILE__) + '/../lib')

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require 'test/unit'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))
require 'active_record/fixtures'
require 'action_controller/test_process'

#require File.join(File.dirname(__FILE__), 'fixtures/attachment')
#require File.join(File.dirname(__FILE__), 'base_attachment_tests')