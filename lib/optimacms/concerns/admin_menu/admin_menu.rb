module Optimacms::Concerns::AdminMenu::AdminMenu
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    def get_menu_basic
      [
          {title: 'Content', url: nil, submenu: [
              {title: 'Pages', url: Optimacms::Engine.routes.url_helpers.pages_path},
              {title: 'Templates', url: Optimacms::Engine.routes.url_helpers.templates_path},
              {title: 'Resources', url: Optimacms::Engine.routes.url_helpers.resources_path},
              {title: 'Languages', url: Optimacms::Engine.routes.url_helpers.languages_path},
              {title: 'CSS Files', url: Optimacms::Engine.routes.url_helpers.css_files_path},
              {title: 'Media', url: Optimacms::Engine.routes.url_helpers.mediafiles_path}
          ]
          }

      ]
    end

    def get_menu
      get_menu_basic + get_menu_custom + get_menu_system
    end

    def get_menu_custom
      []
    end

    def get_menu_system
      [
          {title: 'System', url: nil, submenu: [
              {title: 'App', url: Optimacms::Engine.routes.url_helpers.app_sys_path},
              {title: 'Maintenance', url: false},
              {title: 'Backups', url: false},
              {title: 'Info', url: false}
          ]
          }

      ]

    end
  end
end