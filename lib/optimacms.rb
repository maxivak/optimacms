require 'devise'
require "optimacms/engine"
require "optimacms/configuration"
# TBD
#require "optimacms/devise"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem

# loader.push_dir File.expand_path("../../app/models", __FILE__)
# loader.push_dir File.expand_path("../../app/helpers", __FILE__)
# loader.push_dir File.expand_path("../../app/controllers", __FILE__)
#loader.push_dir File.expand_path("../../config", __FILE__)
#loader.push_dir File.expand_path("../../app/views", __FILE__)

loader.ignore("#{__dir__}/optimacms/engine")
#loader.ignore("#{__dir__}/optimacms/devise")

loader.setup

# TBD
# should be ignored by zeitwerk
#require_relative "optimacms/engine"
#require_relative "../config/routes"




module Optimacms
  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.reset
    @config = Configuration.new
  end

  def self.configure
    yield(config) if block_given?

  end

  # internal paths
  #BASE_PATH       = File.join(File.dirname(__FILE__), "optimacms")
  #BASE_LIB_PATH = "optimacms"

  #require_relative File.join(BASE_LIB_PATH, 'page_services/page_process_service')

  # OLD. will be removed in new versions
=begin
  #
  mattr_accessor :files_dir_path
  def files_dir_path
    @@files_dir_path || 'uploads'
  end


  #
  mattr_accessor :main_namespace
  def main_namespace
    @@main_namespace || ''
  end


  #
  mattr_accessor :admin_namespace
  def admin_namespace
    @@admin_namespace || 'admin'
  end

=end



end
