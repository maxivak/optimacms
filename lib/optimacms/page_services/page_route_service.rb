module Optimacms
  module PageServices
    class PageRouteService

      def self.find_page_by_url(url, lang='')
        where_base = 'is_folder = 0 AND enabled = 1 AND '
        order = 'url_parts_count DESC, url_vars_count ASC'

        if url.blank?
          where = where_base + 'url = \'\''
        else
          #where = where_base + '\'' + url + '\' REGEXP parsed_url'
          where = where_base + '\'' + url + '\''+ " REGEXP parsed_url"
        end

        # result
        pagedata = PageData.new
        pagedata.url = url

        # try 1
        rows = Page.where(where).order(order).all
        pagedata.page = rows[0] if rows.count>0

        # try 2
        if pagedata.page.nil? && url.blank?
          where = where_base + "url = '#{lang}'"
          rows = Page.where(where).order(order).all

          pagedata.page = rows[0] if row.count>0
        end

        return pagedata if pagedata.page.nil?


        # params from url
        pagedata.url_vars = get_url_vars(pagedata.url, pagedata.page)

        # controller
        if pagedata.page.controller_action.present?
          pagedata.controller, pagedata.action = parse_controller_action(pagedata.page.controller_action)
        end


        pagedata
      end

      def self.parse_controller_action(s)
        m = s.match /^(\w+)#(\w+)$/
        if m
          [m[1], m[2]]
        else
          return nil
        end
      end


      REGEX_VARIABLE = '[a-z\d\_]+'

      def self.parse_url(url)
        if url.blank?
          return '^$'
        end

        url_parts = url.split '/'
        a = []
        i_part = 0
        n_parts = url_parts.count
        is_last_optional = false

        url_parts.each do |part|
          i_part+=1
          is_last_optional = false


          # check for brackets inside brackets
          return nil if part =~ /\{[^{}]*[{}][^{}]*\}/

          # check if any single brackets or symbol $ without brackets or bracket without $
          return nil if part =~ /(\{[^}]*$|^[^{]*\}|[^{]\$|\{[^\$])/

          p = part


          # variables inside (...) - optional

          # last optional varible
          if i_part==n_parts
            # /^(:name)..$
            # include last / as optional
            p_before = p.clone
            p.gsub! /^(\(\:#{REGEX_VARIABLE}\))([-\.]|$)/, '\/?([^/]+)*\2'
            is_last_optional = true if p!=p_before
          end

          p.gsub! /(\(\:#{REGEX_VARIABLE}\))([-\.]|$)/, '([^/]+)*\2'

          #if i_part>1
            # add / to the beginning - / is optional too
            #p.gsub! /(\(\:#{REGEX_VARIABLE}\))([-\.]|$)/, '([^/]+)*\2'
          #else
            # the first param
            #p.gsub! /(\(\:#{REGEX_VARIABLE}\))([-\.]|$)/, '([^/]+)*\2'
          #end

          # variables
          #p.gsub! /\{\$[^}]+\}/, '([^/]+)'
          p.gsub! /(\:#{REGEX_VARIABLE})([-\.]|$)/, '([^/]+)\2'


          # escape system symbols
          # replace '.'
          p.sub! '.', '[.]'

          #
          if i_part>1 && !is_last_optional
            p = '/'+p
          end



          a << p
        end

        return '^'+a.join('')+'$'
      end

      def self.count_url_parts(url)
        url_parts = url.split '/'
        n = url_parts.count

        # if nothing after the last /
        n-=1 if url_parts.last == ''

        n
      end

      def self.count_url_vars(url)
        #m = url.scan /\{\$[^}]+\}/
        m = url.scan /\:#{REGEX_VARIABLE}/
        m.count
      end

      def self.get_url_vars(url, page_row)
        return {} if page_row.nil?
        return {} if url.blank?

        #parsed_url = page_row.parsed_url.sub '/', '\/'
        parsed_url = page_row.parsed_url

        #if (preg_match('/' . $parsed_url . '/', $url, $values_matches)) {
        m_params_in_url = url.scan /#{parsed_url}/

        return nil if m_params_in_url.empty?

        values_matches = m_params_in_url[0]

        # search for variables in URL
        #keys_matches = page_row.url.scan /\{\$([^}\/]+)\}/
        keys_matches = page_row.url.scan /\:(#{REGEX_VARIABLE})/
        if !keys_matches.empty?
          keys_matches = keys_matches.map{|r| r[0]}
          if keys_matches.count == values_matches.count
            res = {}
            values_matches.each_with_index do |val, key|
              res[keys_matches[key].to_sym] = val
            end
            #url_vars = array_combine($keys_matches, $values_matches);
            return res
          else
            #user_error('Keys and values has different number of elements');
            return {}
          end

        elsif m_params_in_url.count == 0
          # no variables found, and parsed_url has no variables => return empty []
          return {}
        else
          # smth wrong
          return {}
        end

      end

      def self.make_url(u, params_extra={})
        p = params_extra.keys.map{|x| x.to_sym}

        p_used = []
        res = u.gsub(/\:#{REGEX_VARIABLE}/) do |name|
          p_used << name[1..-1].to_sym
          (params_extra[name[1..-1].to_sym] || '')
        end

        # remove ()
        res.gsub! /[\(\)]/, ''

        # add extra params
        p_not_used =  p - p_used - [:controller, :action, :only_path, :url]

        #
        a_extra = []
        p_not_used.each do |name|
          a_extra << "#{name}=#{(params_extra[name] || '')}"
        end
        if a_extra.length>0
          res = res + '?'+a_extra.join('&')
        end

        #
        #res.gsub! /\?$/, ''
        res
      end
    end

  end
end