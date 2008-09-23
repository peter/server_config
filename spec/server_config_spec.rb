require File.join(File.dirname(__FILE__), "spec_helper")
require 'fileutils'

describe "server config plugin" do
  before(:all) do
    FileUtils.rm_f File.join(File.dirname(__FILE__), "files", "spec_database.yml")

    ServerConfig.class_eval { @@server_config = nil } # Clear out any previous configuration
    ServerConfig.configure do |c|
      c.param :name => :db_password, :value => "my_db_password",
        :files => ["vendor/plugins/server_config/spec/files/spec_database.yml.example"]
      c.param :name => :payex_merchant_key, :value => "the_merchant_key",
        :files => ["vendor/plugins/server_config/spec/files/merchant.yml"]
      c.param :name => :smtp_password, :value => "my_smtp_password"
    end
  end
  
  before(:each) do
    @config = ServerConfig.instance
  end
  
  it "provides access to parameter values via ServerConfig#params method" do
    @config.params[:payex_merchant_key][:files].should == ["vendor/plugins/server_config/spec/files/merchant.yml"]
    @config.params[:payex_merchant_key][:value].should == "the_merchant_key"
    @config.params[:smtp_password][:value].should == "my_smtp_password"
  end

  it "provides indifferent access to values via ServerConfig#param_value" do
    @config.param_value(:payex_merchant_key).should == "the_merchant_key"
    @config.param_value('payex_merchant_key').should == "the_merchant_key"    
  end
  
  it "provides access to parameter values via the global server_param method" do
    server_param(:payex_merchant_key).should == "the_merchant_key"
    server_param('payex_merchant_key').should == "the_merchant_key"
  end

  it "does not write config files before write has been invoked" do
    File.exists?(file_path("spec_database.yml")).should_not be_true
  end

  describe "SpecConfig.write method" do
    before(:each) do
      FileUtils.rm_f File.join(File.dirname(__FILE__), "files", "spec_database.yml")
      ServerConfig.write
    end
    
    it "does param replacements in file.yml.example files and writes result to file.yml" do
      param_pattern = /^\s*password: my_db_password\s*$/
      IO.read(File.join(File.dirname(__FILE__), "files", "spec_database.yml.example")).should_not =~ param_pattern
      IO.read(file_path("spec_database.yml")).should =~ param_pattern
    end

    it "does inline param replacements in file.yml files" do
      IO.read(File.join(File.dirname(__FILE__), "files", "merchant.yml")).should =~ /merchant_key: the_merchant_key/
      File.exists?(File.join(File.dirname(__FILE__), "files", "merchant.yml.example")).should_not be_true
    end
  end

  def file_path(filename)
    File.join(File.dirname(__FILE__), "files", filename)
  end
end
