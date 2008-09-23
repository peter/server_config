require File.join(File.dirname(__FILE__), "..", "init")

namespace :server_config do
  desc "Write parameter values to files as specified in config/server.rb"
  task :write do
    ServerConfig.write
  end  
end
