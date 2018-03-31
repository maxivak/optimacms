
require 'devise'

module Optimacms
  module Devise

    def self.config
      {
          class_name: "Optimacms::CmsAdminUser",
          path: '/'+Optimacms.config.main_namespace+'/'+Optimacms.config.admin_namespace,
          #path: ActiveAdmin.application.default_namespace || "/",
          controllers: Optimacms::Devise.controllers,
          path_names: { sign_in: 'login', sign_out: "logout" },
          options: {
              scoped_views: true
          }
          #sign_out_via: [*::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].uniq
      }
    end

    def self.controllers
      {
        sessions: "optimacms/devise/sessions",
        passwords: "optimacms/devise/passwords",
        unlocks: "optimacms/devise/unlocks",
        registrations: "optimacms/devise/registrations",
        confirmations: "optimacms/devise/confirmations"
      }
    end


    # got from activeadmin

    module Controller
      extend ::ActiveSupport::Concern

      included do
        layout 'optimacms/application_logged_out'
        #helper ::Optimacms::ViewHelpers
      end

      # Redirect to the default namespace on logout
      def root_path
        return '/'
        #namespace = Optimacms.application.default_namespace.presence
        namespace = nil
        root_path_method = [namespace, :root_path].compact.join('_')

        path = if Helpers::Routes.respond_to? root_path_method
                 Helpers::Routes.send root_path_method
               else
                 # Guess a root_path when url_helpers not helpful
                 "/#{namespace}"
               end

        # NOTE: `relative_url_root` is deprecated by rails.
        #       Remove prefix here if it is removed completely.
        #prefix = Rails.configuration.action_controller[:relative_url_root] || ''
        prefix = ''
        prefix + path
      end
    end



    class SessionsController < ::Devise::SessionsController
      include ::Optimacms::Devise::Controller
    end

    class PasswordsController < ::Devise::PasswordsController
      include ::Optimacms::Devise::Controller
    end

    class UnlocksController < ::Devise::UnlocksController
      include ::Optimacms::Devise::Controller
    end

    class RegistrationsController < ::Devise::RegistrationsController
       include ::Optimacms::Devise::Controller
    end

    class ConfirmationsController < ::Devise::ConfirmationsController
       include ::Optimacms::Devise::Controller
    end

    def self.controllers_for_filters
      [SessionsController, PasswordsController, UnlocksController, RegistrationsController, ConfirmationsController
      ]
    end
  end
end
