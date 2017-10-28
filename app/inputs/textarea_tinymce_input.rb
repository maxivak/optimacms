
class TextareaTinymceInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    out = ActiveSupport::SafeBuffer.new

     # prepare options
    new_html_options = prepare_html_options(wrapper_options)


    #input_html_classes.unshift(" currency")
    #input_html_options[:type] ||= input_type if html5?

    #template.content_tag(:span, "$", class: "add-on") +
    #@builder.text_field(attribute_name, input_html_options)

    out << @builder.text_area(attribute_name, new_html_options)
    out
  end

  def prepare_html_options(wrapper_options=nil)
   new_options = {}
   new_options[:class] = [input_html_options[:class], options[:class], 'tinymce'].compact

   merge_wrapper_options(input_html_options.merge(new_options), wrapper_options)
 end

end