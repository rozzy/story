require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/clean'

lib = File.expand_path('../lib/', __FILE__)

$:.unshift lib unless $:.include?(lib)

CLEAN.include('ruby-aws-tools*.gem')
CLOBBER.include('doc/', '.yardoc')

desc "Build the ruby-aws-tools gem."
task :build do
  sh %{gem build ruby-aws-tools.gemspec}
end

desc "Build then install the ruby-aws-tools gem."
task :install => :build do
  require 'ruby-aws-tools/version'
  sh %{gem install ruby-aws-tools-#{Cwgem::RubyAWS::VERSION}.gem}
end

desc "Run specs for ruby-aws-tools gem"
RSpec::Core::RakeTask.new do
end

desc "Generate yard documentation for the api"
YARD::Rake::YardocTask.new do
end

desc "Clean existing gems and re-install"
task :devinst do
  ['clean','build','install'].each { |task| Rake::Task[task].invoke }
end

task :default => :install
