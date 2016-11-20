module Optimacms
  module SimpleFormExtensions
    module ButtonComponents
      def submit_cancel(*args, &block)
        template.content_tag :div, :class => "form-group" do
        template.content_tag :div, :class => "col-sm-offset-1 col-sm-6" do
          options = args.extract_options!

          # class
          options[:class] = [options[:class], 'btn', 'btn-primary', 'btn-lg'].compact

          #
          args << options


          # with cancel link
          if cancel = options.delete(:cancel)
            submit(*args, &block) + '&nbsp;&nbsp;'.html_safe + template.link_to(I18n.t('simple_form.buttons.cancel'), cancel)
          else
            submit(*args, &block)
          end

        end
        end
      end

      def save_continue_cancel(*args, &block)
        template.content_tag :div, :class => "form-group" do
          template.content_tag :div, :class => "col-sm-offset-1 col-sm-6" do
            options = args.extract_options!

            # class
            options[:class] = [options[:class], 'btn', 'btn-primary', 'btn-lg'].compact

            #
            args << options

            buttons = submit(*args, &block) + '&nbsp;&nbsp;'.html_safe+
                template.link_to(I18n.t('simple_form.buttons.save_continue'), '#', {class: options[:class]+['btn-save-continue']})

            # with cancel link
            if cancel = options.delete(:cancel)
              (buttons+'&nbsp;&nbsp;'.html_safe + template.link_to(I18n.t('simple_form.buttons.cancel'), cancel)).html_safe
            else
              buttons.html_safe
            end

          end
        end
      end

    end

    SimpleForm::FormBuilder.send :include, ButtonComponents
  end
end


