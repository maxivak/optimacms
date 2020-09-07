module Optimacms
  module Filters
    class FormFilter

    end
  end
end


=begin
module Optimacms
  module Filters
    class FormFilter

      FIELD_TYPE_TEXT = 'text'
      FIELD_TYPE_HIDDEN = 'hidden'
      FIELD_TYPE_SELECT_AUTO = 'select_auto' # text with autocomplete

      DBTYPE_STRING = 'string'
      DBTYPE_INT = 'int'
      DBTYPE_DATE = 'date'

      #
      attr_accessor :prefix # session prefix
      attr_accessor :fields
      attr_accessor :data
      #attr_accessor :order # [ ["order_column", "asc|desc"], ..]



      def initialize(_session, _prefix)
        @prefix = _prefix
        @session = _session

        @fields ||={}

        # init data
        data()
      end


      ############
      # fields
      ############

      def add_field(f)
        @fields[f[:name]] = f

      end

      def add_fields_from_array(a)
        a.each do |fa|
          add_field fa
        end

      end


      def field_def_value(name)
        if (@fields.has_key? name) && (@fields[name].has_key? :def)
          return @fields[name][:def]
        end
        nil
      end

      ############
      # sessions
      ############

      def session_get(name, def_value)
        @session[prefix+name] || def_value
      end

      def session_save(name, v)
        @session[prefix+name] = v
      end


      ############
      # data
      ############


      def data
        return @data unless @data.nil?

        # from session
        @data_sess = session_get 'data', nil
        unless @data_sess.nil?
          @data = @data_sess
        else

        end

        #
        @data ||= {}

        session_save('data', @data)

        #
        @data
      end

      def v(name, v_def=nil)
        if (data.has_key? name) && (!data[name].nil?) && (!data[name].nil?)
          return data[name]
        end

        field_def_value(name) || v_def
      end

      def v_empty?(name)
        if (data.has_key? name) && (!data[name].nil?)
          return true
        end

        # if v == default value

      end

      def set(field_name,v)
        data[field_name] = v
      end


      def clear_data
        session_save 'data', {}
      end

      def set_data_from_form(params)
        # search for fields like filter[XXX]
        params.each do |name, v|
          #if f =~ /^filter\[([^\]]+)\]$/
            #name = Regexp.last_match(1)

            next unless @fields.has_key? name

            if @fields[name][:dbtype]==DBTYPE_INT
              data[name] = (v.to_i rescue 0)
            else
              data[name] = v
            end

          #end
        end

        # default values from fields
        @fields.each do |name, f|
          next if @data.has_key? name

          @data[name] = field_def_value name
        end

      end



      ####
      # order
      ####

      def order
        return @order unless @order.nil?

        # from session
        @v_sess = session_get 'order', nil
        @order = @v_sess unless @v_sess.nil?

        #
        @order ||= []

        session_save 'order', @order

        #
        @order
      end

      def order= (value)
        @order = value

        session_save 'order', @order
      end

      def set_order_default(order_by, order_dir)
        return false if !order.nil? && !order.empty?

        set_order(order_by, order_dir)

      end


      def set_order(order_by, order_dir)
        self.order = [[order_by, order_dir]]
      end

      def get_order
        order[0] if order.count>0
        order[0]
      end


      def get_opposite_order_dir_for_column(name)
        return 'asc' if order.empty?


        if order[0][0] == name
          return opposite_order_dir(order[0][1])
        end

        return 'asc'
      end

      def opposite_order_dir(order_dir)
        return 'asc' if order_dir=='desc'
        return 'desc' if order_dir=='asc'
        'asc'
      end



      #helper methods

      def html_style(name)
        return '' unless @fields[name].has_key?(:opt)

        s = ''
        opt = @fields[name][:opt]
        unless opt[:width].nil?
          s << "width: #{opt[:width]}px; "
        end
      end
    end
  end
end

=end