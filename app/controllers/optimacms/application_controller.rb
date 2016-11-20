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

  end
end
