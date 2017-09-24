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

    # find
    def self.get_id_by_name(name)
      row = TemplateType.where(name: name).first

      return nil if row.nil?

      row.id
    end

  end
end
