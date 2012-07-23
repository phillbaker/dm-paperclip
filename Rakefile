# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'jeweler'
require 'yard'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

# desc 'Default: run unit tests.'
# task :default => [:clean, :all]

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options

  gem.name              = "dm-paperclip"
  gem.author            = "Ken Robertson"
  gem.email             = "ken@invalidlogic.com"
  gem.homepage          = "http://invalidlogic.com/dm-paperclip/"
  gem.platform          = Gem::Platform::RUBY
  gem.summary           = "File attachments as attributes for DataMapper, based on the original Paperclip by Jon Yurek at Thoughtbot"

  gem.requirements << "ImageMagick"

end
Jeweler::RubygemsDotOrgTasks.new

# Test tasks
desc 'Test the DM-Paperclip library.'
Rake::TestTask.new(:test) do |t|
  t.libs << '.'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

YARD::Rake::YardocTask.new

desc 'Default: run unit tests.'
task :default => [:clean, :test]

# Console 
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r dm-validations -r dm-migrations -r ./lib/dm-paperclip.rb"
end

# Rdoc
desc 'Generate documentation for the paperclip plugin.'
Rake::RDocTask.new(:doc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'DM-Paperclip'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
 
# Code coverage
task :coverage do
  system("rm -fr coverage")
  system("rcov test/*_test.rb")
  system("open coverage/index.html")
end

# Clean house
desc 'Clean up files.'
task :clean do |t|
  FileUtils.rm_rf "doc"
  FileUtils.rm_rf "coverage"
  FileUtils.rm_rf "tmp"
  FileUtils.rm_rf "pkg"
  FileUtils.rm_rf "log"
end
<<<<<<< HEAD

spec = Gem::Specification.new do |s| 
  s.name              = "dm-paperclip"
  s.version           = Paperclip::VERSION
  s.author            = "Ken Robertson"
  s.email             = "ken@invalidlogic.com"
  s.homepage          = "http://invalidlogic.com/dm-paperclip/"
  s.platform          = Gem::Platform::RUBY
  s.summary           = "File attachments as attributes for DataMapper, based on the original Paperclip by Jon Yurek at Thoughtbot"
  s.files             = FileList["README.rdoc",
                                 "LICENSE",
                                 "Rakefile",
                                 "init.rb",
                                 "{lib,tasks,test}/**/*"].to_a
  s.require_path      = "lib"
  s.test_files        = FileList["test/**/test_*.rb"].to_a
  s.rubyforge_project = "dm-paperclip"
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.rdoc"]
  s.rdoc_options << '--line-numbers' << '--inline-source'
  s.requirements << "ImageMagick"
  s.requirements << "dm-core"
  s.requirements << "dm-validations"
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end

desc 'Generate gemspec'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') { |f| f.puts(spec.to_ruby) }
end

WIN32 = (PLATFORM =~ /win32|cygwin/) rescue nil
SUDO  = WIN32 ? '' : ('sudo' unless ENV['SUDOLESS'])

desc "Install #{spec.name} #{spec.version}"
task :install => [ :package ] do
  sh "#{SUDO} gem install pkg/#{spec.name}-#{spec.version} --no-update-sources", :verbose => false
end

desc "Release new version"
task :release => [:test, :gem] do
  require 'rubygems'
  require 'rubyforge'
  r = RubyForge.new
  r.login
  r.add_release spec.rubyforge_project,
                spec.name,
                spec.version,
                File.join("pkg", "#{spec.name}-#{spec.version}.gem")
end
