require "paperclip"

unless Rails.env.production?
  # Windows
  Paperclip.options[:command_path] = 'd:\Program Files\ImageMagick-6.9.0-Q16'
  Paperclip.options[:swallow_stderr] = false
end


Paperclip.interpolates :p_company_id do |attachment, style|
  attachment.instance.p_company_id
end