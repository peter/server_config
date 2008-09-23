require File.join(File.dirname(__FILE__), "lib", "server_config")

module ::Kernel
  def server_param(param_name)
    ServerConfig.instance.param_value(param_name)
  end
end

config_path = File.join(RAILS_ROOT, "config", "server.rb")
require config_path if File.exists?(config_path)
