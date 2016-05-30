module Optimacms

module MetaContent
  extend ActiveSupport::Concern

  included do
    #has_many :taggings, as: :taggable

    #class_attribute :tag_limit


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
