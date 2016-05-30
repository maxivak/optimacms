module Optimacms
  class Language < ActiveRecord::Base
    self.table_name = 'cms_languages'


    scope :admin_enabled, -> {order('pos asc')}

    def self.list_with_default
      rows = ['']+Language.admin_enabled.all.map(&:lang)

    end

  end
end
