require 'rake'
require 'rake/rdoctask'

desc 'Default: run RSpec'
task :default => :spec

desc 'Generate documentation for the server_config plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ServerConfig'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.rcov = true  
end
