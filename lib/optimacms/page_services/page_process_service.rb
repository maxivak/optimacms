module Optimacms
  module PageServices
    module PageProcessService

      def compile_content(page_content)
        #res.gsub! /\{\{content\}\}/, page_content
        res = page_content

        res
      end

      def generate_view_name
        uid =SecureRandom.uuid.to_s
        id = uid.gsub /[^a-z\d]+/,''
        f_path = id+'.html.erb'
        #Digest::SHA1.hexdigest(Time.now.to_s)
        #filename = dir_cache+'/'+f_path
        f_path
        #'pages/2.html.erb'
      end

      def save_text_to_compiled_view(text)
        filename = compiled_view_filename
        File.open(filename, "w+") do |f|
          f.write(text)
        end
      end

    end
  end
end

