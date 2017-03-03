require 'devise'
require "optimacms/engine"

module Optimacms
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

end
