module Optimacms
  class PageTranslation < ActiveRecord::Base
    self.table_name = 'cms_pages_translation'

    belongs_to :page, :foreign_key => 'item_id', :class_name => 'Page', optional: true
    #belongs_to :page


  end
end
