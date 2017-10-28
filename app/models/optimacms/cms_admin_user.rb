module Optimacms
  class CmsAdminUser < ActiveRecord::Base
    self.table_name = 'cms_users'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
    devise :database_authenticatable, :recoverable, :rememberable, :trackable
    #, :validatable


    # search
    searchable_by_simple_filter

    ### validate
    validates_confirmation_of :password

    validates :password, :presence     => true,
              :confirmation => true,
              :length       => { :minimum => 6 },
              :if           => :should_validate_password? # only validate if password changed!

    def should_validate_password?
      x = new_record? || !password.blank?
      #if: Proc.new{|obj| obj.new_record? || !obj.<attribute>.blank? }
    end

    before_destroy :can_destroy?

    def can_destroy?
      !self.is_superadmin
    end


    ## properties

    def is_superadmin?
      self.is_superadmin
    end
  end
end
