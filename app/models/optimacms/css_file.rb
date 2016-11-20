module Optimacms
  class CssFile
    attr_accessor :name, :basepath, :path, :is_folder, :content

    def init_from_path(f)
      if f =~ /^#{CssFile::dir_base}/
        # it is full path
        self.basepath = f.gsub /#{CssFile::dir_base}\/?/, ''
        self.path = f
      else
        # it is short path
        self.basepath = f
        self.path = "#{CssFile::dir_base}/#{f}"
      end


      #
      if File.file?(f)
        self.is_folder = false
      elsif File.directory?(f)
        self.is_folder = true
      end

    end

    ###
    def to_param
      basepath
    end

    ###
    def self.get_all

      get_list
    end


    ###

    def self.dir_base
      "app/assets/stylesheets"
    end

    def self.get_list
      res = []

      #
      #Dir["#{dir_base}/**"].each do |f|
      #Dir.glob(File.join(dir_base, "**", "*#{File::Separator}")).each do |f|
      Dir.glob(File.join(dir_base, "**", "*")).each do |f|
        next if File.directory?(f)

        r = CssFile.new
        r.init_from_path(f)

        res << r
      end


      #files = files.sort_by{ |x| File.mtime(x) }.reverse

      res
    end

    ###
    def update_attributes(p)
      self.content = p[:content]
    end

    def save
      save_content

      true
    end

    ### content

    def content
      return @content unless @content.nil?

      #
      return '' if !File.exists? self.path
      @content = File.read(self.path)

      @content
    end


    def save_content
      File.open(self.path, "w+") do |f|
        f.write(@content)
      end
    end

  end
end