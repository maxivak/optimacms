module Optimacms
  class CmsAdminUser < ActiveRecord::Base
    self.table_name = 'cms_users'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  end
end
