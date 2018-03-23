module Optimacms
  #class ApplicationController < ActionController::Base
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    # include FontAwesome::Rails::IconHelper

    include Optimacms::ApplicationHelper


    def current_lang
      return I18n.locale
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end


    # devise
    before_action :configure_permitted_parameters, if: :devise_controller?


    protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

  end
end
