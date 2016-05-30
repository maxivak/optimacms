module Optimacms

  class Layout < ActiveRecord::Base
    self.table_name = 'cms_templates'

    has_many :pages

    # scopes
    scope :main, -> { where(tpl_type: 'main')}

    # content

    def content(lang='')
      filename =  content_filename_full(lang)
      if !File.exists? filename
        return ''
      end
      File.read(filename)
    end

    def content=(v, lang='')
      File.open(content_filename_full(lang), "w+") do |f|
        f.write(v)
      end
    end

    def content_filename_full(lang)
      Layout.content_filename_dir + content_filename(lang)
    end

    def content_filename(lang='')
      self.name+content_filename_lang_postfix(lang)+'.'+content_filename_ext
    end


    def self.content_filename_dir
      #Rails.root.to_s + '/content/layouts/'
      Rails.root.to_s + '/app/views/layouts/'
    end

    def content_filename_lang_postfix(lang)
      return '' if lang==''
      return '.'+lang
    end

    def content_filename_ext
      return 'html.erb'
    end


  end
end

