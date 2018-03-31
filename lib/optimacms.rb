require 'devise'
require "optimacms/engine"
require "optimacms/configuration"

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
