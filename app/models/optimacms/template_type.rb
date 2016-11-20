module Optimacms
  class TemplateType < ActiveRecord::Base
    self.table_name = 'cms_templatetypes'

    TYPE_LAYOUT = 1
    TYPE_PAGE = 2
    TYPE_PARTIAL = 3
    TYPE_BLOCKVIEW = 4

    #
    has_many :templates


    # properties

    def to_s
      title
    end
  end
end
