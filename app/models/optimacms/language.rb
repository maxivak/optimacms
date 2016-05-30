module Optimacms
  class Language < ActiveRecord::Base
    self.table_name = 'cms_languages'

    scope :admin_enabled, -> { where("1=1").order('pos asc')}

    ### search
    searchable_by_simple_filter

    ###

    def self.list_with_default
      rows = ['']+Language.admin_enabled.all.map(&:lang)

    end

  end
end
