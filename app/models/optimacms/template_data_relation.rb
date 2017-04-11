module Optimacms
  class TemplateDataRelation < ActiveRecord::Base
    self.table_name = 'cms_template_data_relations'

    belongs_to :template, :foreign_key => 'template_id', :class_name => 'Template'
  end
end
