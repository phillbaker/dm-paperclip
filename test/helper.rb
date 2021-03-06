require 'bundler'
require 'test/unit'

require 'shoulda'
require 'mocha'

RUBY_VERSION >= '1.9.0' ? require("debugger") : require('ruby-debug')

Bundler.setup(:default, :development)

require "dm-migrations"
require "dm-validations"

ROOT = File.join(File.dirname(__FILE__), '..')

class Test::Unit::TestCase
  def setup
    silence_warnings do
      Object.const_set(:Rails, stub('Rails', :root => ROOT, :env => 'test'))
      Object.const_set(:Merb, stub('Merb', :root => ROOT, :env => 'test'))
    end
  end
end

$:.push File.expand_path("../lib", File.dirname(__FILE__))
require 'dm-paperclip'

ENV['RAILS_ENV'] ||= 'test'

FIXTURES_DIR = File.join(File.dirname(__FILE__), "fixtures") 
DataMapper.setup(:default, 'sqlite3::memory:')

unless defined?(Mash)
  class Mash < Hash
  end
end

Paperclip.configure do |config|
  config.root               = ROOT   # the application root to anchor relative urls (defaults to Dir.pwd)
  config.env                = 'test' # server env support, defaults to ENV['RACK_ENV'] or 'development'
  config.use_dm_validations = false   # validate attachment sizes and such, defaults to false
end

def rebuild_model options = {}
  rebuild_class options
  Dummy.auto_migrate!
end

def rebuild_class options = {}
  Object.send(:remove_const, "Dummy") rescue nil
  Object.const_set("Dummy", Class.new)
  Dummy.class_eval do
    include DataMapper::Resource
    #include DataMapper::Validate
    # => include DataMapper::Validations
    include Paperclip::Resource
    property :id, ::DataMapper::Property::Serial
    property :other, String
    has_attached_file :avatar, options
  end
  DataMapper.auto_migrate!
end

class FakeModel
  attr_accessor :avatar_file_name,
                :avatar_file_size,
                :avatar_updated_at,
                :avatar_content_type,
                :avatar_fingerprint,
                :id

  def errors
    @errors ||= []
  end

  def run_paperclip_callbacks name, *args
  end

end

def attachment options
  Paperclip::Attachment.new(:avatar, FakeModel.new, options)
end

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end

def should_accept_dummy_class
  should "accept the class" do
    assert_accepts @matcher, @dummy_class
  end

  should "accept an instance of that class" do
    assert_accepts @matcher, @dummy_class.new
  end
end

def should_reject_dummy_class
  should "reject the class" do
    assert_rejects @matcher, @dummy_class
  end

  should "reject an instance of that class" do
    assert_rejects @matcher, @dummy_class.new
  end
end

def with_exitstatus_returning(code)
  saved_exitstatus = $?.nil? ? 0 : $?.exitstatus
  begin
    `ruby -e 'exit #{code.to_i}'`
    yield
  ensure
    `ruby -e 'exit #{saved_exitstatus.to_i}'`
  end
end
