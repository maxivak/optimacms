module Optimacms
  class PageTranslation < ApplicationRecord
    self.table_name = 'cms_pages_translation'

    belongs_to :page, :foreign_key => 'item_id', :class_name => 'Page', :inverse_of => :translations
    #belongs_to :page


  end
end
