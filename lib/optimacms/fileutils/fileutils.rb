module Optimacms
  module Fileutils
    class Fileutils
      def self.create_dir_if_not_exists(filename)
        if filename =~ /\/$/
          path = filename
        else
          path = File.dirname(filename)
        end


        return if File.directory? (path)

        begin
          a_dirs = path.split(/\//)
          d = ''

          a_dirs.each do |v|
            d += v + '/'
            if d.empty?
              continue
            end

            if ! File.directory? (d)
              Dir.mkdir(d, 0775)
            end
          end

          if ! File.directory? (path)
            Dir.mkdir(path, 0775)
          end

        rescue Exception => ex
        end
      end

    end
  end

end