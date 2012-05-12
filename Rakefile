require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "aavkontakte-rails3"
  gem.rubyforge_project = "aavkontakte-rails3"
  gem.homepage = "http://github.com/blimp666/aavkontakte-rails3"
  gem.license = "MIT"
  gem.summary = %Q{Yet Another Authlogic Vkontakte Authorization}
  gem.description = %Q{Vkontakte authorization for authlogic with ruby 1.9 and rails 3.0}
  gem.email = "nowhere@gmail.com"
  gem.authors = ["blimp666"]

  gem.files.include 'lib/aavkontakte-rails3.rb'
  gem.files.include 'lib/vkontakte.js'
  gem.files.include 'lib/vkontakte/authentication.rb'
  gem.files.include 'lib/vkontakte/session.rb'
  gem.files.include 'lib/vkontakte/helper.rb'
  gem.files.include 'lib/vkontakte/auth_success.rb'

end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
# end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "aavkontakte-rails3 #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
