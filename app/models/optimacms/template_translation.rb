module Optimacms
  class TemplateTranslation < ActiveRecord::Base
    self.table_name = 'cms_templates_translation'

    belongs_to :template, :foreign_key => 'item_id', :class_name => 'Template'

    delegate :basename, :basedirpath, :tpl_format, :is_type_partial?, to: :template

    ### content

    def content
      filename =  fullpath
      return nil if filename.nil?
      return '' if !File.exists? filename
      File.read(filename)
    end

    def content=(v)
      File.open(self.fullpath, "w+") do |f|
        f.write(v)
      end
    end


    ### path

    # base filename depending on  type
    # for page = name
    # for partial = _name
    def filename_base
      return '_'+basename if is_type_partial?
      basename
    end


    def path
      return nil if basename.nil?
      basedirpath + filename_base + Template.filename_lang_postfix(lang) + Template.filename_ext_with_dot(self.tpl_format)
    end

    def fullpath
      f = path
      return nil if f.nil?
      Template.base_dir + f
    end

  end
end
