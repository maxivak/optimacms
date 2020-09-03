module Optimacms
  module MetaContentConcern
    extend ActiveSupport::Concern

    included do
      #has_many :taggings, as: :taggable

      #class_attribute :tag_limit

      ### meta

      # list of meta by lang
      def metas
        return @metas unless @metas.nil?

        @metas = {}
        @metas['default'] = meta('')
        Language.all.each do |r|
          lang = r.lang
          @metas[lang] = meta(lang)
        end

        @metas
      end

      def metas=(v_metas)
        v_metas.each do |lang, d|
          pagemeta = PageMeta.new(self.name, lang)
          pagemeta.data=d
          @metas[lang] = pagemeta
        end
        @metas
      end

      def meta(lang='')
        PageMeta.new(self.name, lang)
      end
    end


    def meta_keywords_content(lang='')
    end

    def meta_keywords_content=(v, lang='')
    end



    # methods defined here are going to extend the class, not the instance of it
    module ClassMethods

      def make_meta(langs)
        langs.each do |lang|
          define_method("meta_keywords_#{lang}") do
            #puts "@#{name} was set to #{val}"
            #instance_variable_set("@#{name}", val)
            x=0
          end
        end
      end

      def method_missing(method_sym, *arguments, &block)
        if method_sym.to_s =~ /^meta_(.*)_(.*)$/
          t, lang = $1, $2
          #find($1.to_sym => arguments.first)
          #self.x=0
        else
          super
        end
      end


      # settings

      def dir_meta

      end

      def tag_limit(value)
        self.tag_limit_value = value
      end


    end
  end
end
