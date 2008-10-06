class ServerConfig
  attr_accessor :params

  def self.instance
    @@server_config ||= ServerConfig.new
  end
  
  def self.configure
    yield instance
  end
  
  def params
    @params ||= {}
  end
  
  def param(options = {})
    [:name, :value].each do |required_option|
      options[required_option] || raise("Missing #{required_option} option in param options '#{options.inspect}'")
    end
    params[options[:name].to_sym] = options.except(:name)
  end
  
  def param_value(name)
    if RAILS_ENV == "production" && params[name.to_sym].nil?
      raise("No server param '#{name}' defined in environment #{RAILS_ENV}")
    end
    params[name.to_sym] ? params[name.to_sym][:value] : nil
  end

  def self.write
    instance.write
  end

  def write
    params.each { |name, options| write_param(name, options[:value], options[:files]) if options[:files] }
  end
  
  private  
  def write_param(name, value, files)
    files.each do |relative_path|
      full_path = File.join(RAILS_ROOT, relative_path)
      contents = IO.read(full_path)
      contents.gsub!(replace_pattern(name), value)
      File.open(strip_example_extension(full_path), "w") { |file| file.print contents }
    end
  end

  def strip_example_extension(file_path)
    file_path[/^(.+)\.example$/, 1] || file_path
  end
  
  def replace_pattern(param_name)
    "__" + param_name.to_s + "__"    
  end
end
