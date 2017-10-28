module Optimacms
  module FormsHelper
    def horizontal_simple_form_for(resource, options = {}, &block)
      options[:html] ||= {}

      # class
      options[:html][:class] ||= []
      if options[:html][:class].is_a? Array
        options[:html][:class] << 'form-horizontal'
      else
        options[:html][:class] << ' form-horizontal'
      end
      options[:html][:role] = 'form'


      options[:wrapper] = :horizontal_form
      options[:wrapper_mappings] = {check_boxes: :horizontal_radio_and_checkboxes, radio_buttons: :horizontal_radio_and_checkboxes, file: :horizontal_file_input,boolean: :horizontal_boolean      }
      simple_form_for(resource, options, &block)
    end



    def inline_simple_search_form_for(filter_object, options = {}, &block)
      return render 'tableview/filter.html.haml', style: :inline, filter_object: filter_object
      return

      options[:html] ||= {}

      options[:url] = send(filter_object.url)

      options[:html][:role] = 'form'

      # class
      options[:html][:class] ||= []
      if options[:html][:class].is_a? String
        options[:html][:class] = [options[:html][:class]]
      end
      options[:html][:class] << 'form-inline'
      options[:html][:id] = 'formFilter'

      options[:wrapper] = :inline_search_form
      options[:wrapper_mappings] = {      }


      capture do
        simple_form_for(:filter, options) do |f|
          concat(hidden_field_tag 'cmd', 'apply')
          concat(render 'tableview/filter_fields', filter: filter_object, f: f)
          concat(render 'tableview/buttons_apply_clear_inline', filter: filter_object, f: f)
        end
      end

    end


    def horizontal_simple_search_form_for(filter_object, options = {}, &block)
      return render 'tableview/filter.html.haml', style: :horizontal, filter_object: filter_object
    end

=begin
    def link_to_sortable_column(field_name, title = nil, html_options = nil, &block)
      html_options ||= {}

      if @filter.search_method_post_and_redirect?
        html_options[:method] = :post
      end

      url = send(@filter.url, @filter.url_params_for_sortable_column(field_name))

      link_to(title, url, html_options)
    end
=end

  end
end
