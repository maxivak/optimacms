module Optimacms
  class CmsAdminUser < ActiveRecord::Base
    self.table_name = 'cms_users'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
    devise :database_authenticatable, :recoverable, :rememberable, :trackable,
           authentication_keys: [:login]
    #, :validatable

    attr_accessor :login

    # search
    searchable_by_simple_filter

    ### validate
    validates_confirmation_of :password

    validates :password, :presence     => true,
              :confirmation => true,
              :length       => { :minimum => 6 },
              :if           => :should_validate_password? # only validate if password changed!

    validates :username,
              presence: :true,
              uniqueness: { case_sensitive: false }

    # Only allow letter, number, underscore and punctuation.
    #validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true


    def should_validate_password?
      x = new_record? || !password.blank?
      #if: Proc.new{|obj| obj.new_record? || !obj.<attribute>.blank? }
    end

    ### callbacks

    before_destroy :can_destroy?


    def can_destroy?
      !self.is_superadmin
    end


    ## properties

    def is_superadmin?
      self.is_superadmin
    end




    ### for login auth

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      conditions[:email].downcase! if conditions[:email]

      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_hash).first
      end
    end

  end
end
