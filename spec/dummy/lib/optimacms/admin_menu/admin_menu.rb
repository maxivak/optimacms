module Optimacms
  module AdminMenu
    class AdminMenu
      include Optimacms::Concerns::AdminMenu::AdminMenu

      def self.get_menu_custom
        [
            {title: 'News', route: nil, submenu: [
                {title: 'News', url: Rails.application.routes.url_helpers.admin_news_index_path},
                {title: 'Categories', url: Rails.application.routes.url_helpers.admin_news_index_path},
            ]
            }

        ]

      end

    end
  end
end
