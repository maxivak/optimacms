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
      get_menu_basic + get_menu_custom + get_menu_users + get_menu_system
    end

    def get_menu_custom
      []
    end

    def get_menu_users
      [
          {title: 'Users', url: nil, submenu: [
              {title: 'Users', url: Optimacms::Engine.routes.url_helpers.users_path},
          ]
          }

      ]

    end

    def get_menu_system
      [
          {title: 'System', url: nil, submenu: [
              {title: 'Logs', url: Optimacms::Engine.routes.url_helpers.rails_logs_path},
              {title: 'Maintenance', url: Optimacms::Engine.routes.url_helpers.maintenance_path},
              {title: 'Sync app data', url: Optimacms::Engine.routes.url_helpers.appdata_path},
              #{title: 'Backups', url: false},
              {title: 'Backup metadata', url: Optimacms::Engine.routes.url_helpers.backup_metadata_path},
              {title: 'Info', url: Optimacms::Engine.routes.url_helpers.maintenance_info_path}
            ]
          }

      ]

    end
  end
end