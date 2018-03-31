module Optimacms
  module BackupMetadata
    class Backup
      def self.generate_backup_name
        d = Time.now.utc

        "#{d.strftime("%Y.%m.%d.%H.%M.%S")}"
      end

      def self.perform_backup()
        d = dir_backups

        backup_name = generate_backup_name

        d_base = File.join(d, backup_name)
        d_pages = File.join(d_base, "pages/")
        unless Dir.exists?(d_pages)
          Optimacms::Fileutils::Fileutils.create_dir_if_not_exists(d_pages)
        end

        d_templates = File.join(d_base, "templates/")
        unless Dir.exists?(d_templates)
          Optimacms::Fileutils::Fileutils.create_dir_if_not_exists(d_templates)
        end

        # pages
        pages_all = Page.order("id asc").all

        pages_all.each do |p|
          s = JSON.pretty_generate(page_to_hash(p))

          pfname = page_filename(p)
          f = File.join(d_pages, pfname+".json")

          File.open(f, "w+") do |f|
            f.write(s)
          end
        end

        # templates
        templates_all = Template.order("id asc").all

        templates_all.each do |p|
          s = JSON.pretty_generate(template_to_hash(p))

          f = File.join(d_templates, template_filename(p)+".json")
          File.open(f, "w+") do |f|
            f.write(s)
          end
        end


        # archive
        f_basename = File.basename(d_base)
        `cd #{d} && tar cvzf #{f_basename}.tar.gz #{f_basename}`

        #
        output = ""
        return {res: 1, output: output}
      rescue => e
        output = "exception. #{e.message}"
        return {res: 0, output: output}

      end


      def self.upload_backup(temp_file)
        # download file
        uploaded_file = temp_file
        #f_basename = File.basename(uploaded_file.original_filename)
        filename = make_backup_path uploaded_file.original_filename

        d = File.dirname(filename)
        unless Dir.exists?(d)
          Optimacms::Fileutils::Fileutils.create_dir_if_not_exists(filename.to_s)
        end

        File.open(filename, 'wb') do |f|
          f.write(uploaded_file.read)
        end

        # untar
        output = `cd #{d} && tar -xzvf #{File.basename(filename)}`

        return true
      end

      def self.list_backups
        res = []

        #
        files = []

        Dir["#{dir_backups}/**/*.tar.gz"].each do |f|
          files << f
        end

        files = files.sort_by{ |x| File.mtime(x) }.reverse

        res = files.map do |f|
          r = {}
          r[:shortpath] = f.gsub /#{dir_backups}\//, ''
          r[:name] = File.basename r[:shortpath], '.tar.gz'
          r[:path] = f
          r[:size] = File.size(f)

          r
        end


        res
      end



      def self.delete_backup(f)
        path = File.join(dir_backups, f)

        File.delete(path)

        # delete folder
        require 'fileutils'
        d = File.join(dir_backups, File.basename(f, ".tar.gz"))
        FileUtils.rm_r d if Dir.exists?(d)

        return {res:1 , output: "deleted"}
      rescue Exception => e
        return {res: 0, output: "error"}
      end


      ###
      def self.make_backup_path(f_basename)
        Rails.root.join(dir_backups, f_basename)
      end


      def self.make_backup_dir_path(dirname)
        Rails.root.join(dir_backups, dirname)
      end

      def self.page_to_hash(row)

        # translation
        translation = {}

        row.translations.each do |r|
          translation[r.lang] = {
              lang: r.lang,
              meta_title: r.meta_title,
              meta_keywords: r.meta_keywords,
              meta_description: r.meta_description,
          }
        end

        # return
        {
            id: row.id,
            name: row.name,
            title: row.title,

            url: row.url,
            url_parts_count: row.url_parts_count,
            url_vars_count: row.url_vars_count,
            parsed_url: row.parsed_url,

            #parent_id: row.parent_id,
            parent_name: (row.folder.name rescue nil),

            pos: row.pos,
            redir_url: row.redir_url,

            is_folder: row.is_folder,
            controller_action: row.controller_action,


            status: row.status,
            enabled: row.enabled,

            is_translated: row.is_translated,

            #template_id: row.is_translated,
            template_basepath: (row.template.basepath rescue nil),
            #layout_id: row.layout_id,
            layout_basepath: (row.layout.basepath rescue nil),



            translation: translation

        }

      end

      def self.page_filename(row)
        if row.parent_id && row.parent_id>0 && row.folder
          "#{row.folder.name}--#{row.name}" rescue "error-#{row.id}"
        elsif row.name
          row.name
        else
          "#{row.id}"
        end

      end


      ###

      def self.template_filename(row)
        row.basepath.gsub /\//, "--"
      end

      def self.template_to_hash(row)
        ancestry_path = (row.ancestors.map{|r| r.basepath}.join(",") rescue nil)

        #
        {
            id: row.id,
            title: row.title,
            basename: row.basename,
            basepath: row.basepath,
            basedirpath: row.basedirpath,

            #type_id: row.type_id,
            type_name: (row.type.name rescue nil),

            tpl_format: row.tpl_format,
            pos: row.pos,

            is_translated: row.is_translated,
            is_folder: row.is_folder,
            enabled: row.enabled,

            ancestry_path: ancestry_path

        }
      end


      def self.dir_backups
        Optimacms.config.metadata['backup_dir_base']

      end


    end
  end
end

