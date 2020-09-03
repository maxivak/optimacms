module Optimacms
  class PageMeta
    attr_accessor :name, :lang, :title, :keywords, :description
    attr_accessor :data

    def initialize(_name, _lang)
      @name = _name
      @lang = fix_lang(_lang)
    end

    def fix_lang(_lang)
      _lang=='default' ? '' : _lang
    end

    def title
      data[:title] || ''
    end

    def keywords
      data[:keywords] || ''
    end

    def description
      data[:description] || ''
    end

    def data
      return @data unless @data.nil?

      filename = meta_filename_full(lang)
      return nil if filename.nil?
      return meta_default(lang) if !File.exists? filename

      require 'json'
      text = File.read(filename)
      @data = JSON.parse text, :symbolize_names => true
      @data ||= meta_default(lang)
      @data
    end

    def data=(v)
      @data = v
    end

    def save!
      slang = lang=='default' ? '' : lang

      require 'json'
      File.open(meta_filename_full(slang), "w+") do |f|
        f.write(JSON.pretty_generate(data))
      end

      true
    end

    def meta_default(lang='')
      { lang: lang, title: '', keywords: '', description: ''}
    end

    def meta_filename(lang='')
      return nil if self.name.nil?
      self.name+meta_filename_lang_postfix(lang)+'.'+meta_filename_ext
    end

    def self.meta_dir
      File.join(Rails.root, '/app/pages/')
    end

    def meta_filename_full(lang)
      f = meta_filename(lang)
      return nil if f.nil?
      File.join(self.class.meta_dir, f)
    end

    def meta_filename_lang_postfix(lang)
      return '' if lang==''
      return '.'+lang
    end

    def meta_filename_ext
      return 'json'
    end
  end
end
