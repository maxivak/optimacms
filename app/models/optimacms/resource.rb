module Optimacms
  class Resource < ActiveRecord::Base
    self.table_name = 'cms_resources'

    # translation
    translates :content
    globalize_accessors :locales => Language.list_all

    ### search
    paginates_per 20

    ### search
    searchable_by_simple_filter


    ##
    def self.v(name)
      where(name: name).first.content rescue ''
    end

    ##
    def self.method_missing(method_sym, *arguments, &block)
      # the first argument is a Symbol, so you need to_s it if you want to pattern match
      #if method_sym.to_s =~ /^find_by_(.*)$/
        v(method_sym.to_s)
      #else
      #  super
      #end
    end

    ###
    def get_usages

      res = []
      dd = Rails.root.join('app', 'views')
      Dir.glob("#{dd}/**/*").each do |f|
        r = {}

        next if File.directory?(f)

        r[:path] = f
        r[:shortpath] = f.gsub(/#{dd}\/?/,'')

        # find in file
        hits = []
        File.foreach(f).with_index do |s, line_ind|
          #puts "#{line_num}: #{line}"

          if s[/msg\.#{name}/]
            hits << {line: s, line_ind: line_ind}
          end
        end

        r[:hits] = hits

        if hits.count > 0
          # find template
          tp = r[:shortpath].gsub(/\.html\.(haml|erb)$/, '')
          tp.gsub! /\/_/, '/'

          row_template = Optimacms::Template.where(:basepath=>tp).first
          if row_template
            r[:template_id] = row_template.id
          end

          res << r
        end

      end
      res
    end

  end
end