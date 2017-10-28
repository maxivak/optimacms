class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  #before_action :authenticate_beta if Rails.env.development? && Rails.application.config.TEST_ADMIN_PWD!=''
  #before_action :authenticate_beta if Rails.env.development?

  def authenticate_beta
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      #username == 'admin' && password == Rails.application.config.TEST_ADMIN_PWD
      username == 'admin' && password == 'admin'
    end
  end


end
