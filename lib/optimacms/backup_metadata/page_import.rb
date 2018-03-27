module Optimacms
  module BackupMetadata
    class PageImport
      def self.analyze_data_dir(dir_path)
        #
        files = []

        Dir["#{dir_path}/*.json"].each do |f|
          files << f
        end

        files = files.sort_by{ |x| File.basename(x, '.json') }

        #
        res = files.map do |f|
          data = load_data(f)
          analysis = analyze_data(data)

          {filename: File.basename(f), data: data, analysis: analysis}
        end


        res
      end


      def self.analyze_file(filename)
        data = load_data(filename)

        return analyze_data(data)
      end

      def self.load_data(filename)
        data = JSON.parse(File.read(filename))
      end

      def self.analyze_data(data)
        name = data['name']

        #
        res = {}
        res['status'] = '' # statuses: not_changed, new, changed, error
        res['name'] = name
        res['changes'] = []
        res['errors'] = []
        res['warnings'] = []


        # find in db
        row = Page.where(name: name, is_folder: data['is_folder']).first

        if row.nil?
          res['status'] = 'new'

          # folder
          if data['is_folder']

          else


          end

          # check parents
          if data['parent_name'] && data['parent_name']!=""
            row_parent = Page.where(name: data['parent_name']).first

            if row_parent.nil?
              res['errors'] << {field: 'parent', message: "parent not found: #{data['parent_name']}"}
            end

          end

        else
          # compare fields
          fields_page = ['title', 'url', 'parsed_url', 'pos', 'redir_url',
                         'controller_action',
                         'status', 'enabled',
                         'is_translated']
          fields_folder = ['title', 'pos']
          basic_fields = data['is_folder'] ? fields_folder : fields_page

          basic_fields.each do |field|
            if data[field]!=row.send(field.to_sym)
              res['changes'] << {field: field, message: "changed"}
            end
          end

          # id
          if row.id != data['id'].to_i
            res['warnings'] << {field: 'id', message: "id changed"}
          end

          # folder
          #if row.is_folder != data['is_folder']
          #  res['changes'] << {field: 'is_folder', message: "is folder error"}
          #end




          # parent
          if !data['is_folder']
            if data['parent_name'].nil? || data['parent_name']==""
              # new - no folder, old - in folder
              if row.folder
                res['changes'] << {field: 'parent', message: "moved to root folder"}
              end
            else
              # new page - in folder

              # check if new folder exists
              row_parent = Page.where(name: data['parent_name']).first

              if row_parent.nil?
                res['errors'] << {field: 'parent', message: "parent not found: #{data['parent_name']}"}
              else
                if row.folder
                  # folder changed
                  if row.folder.name!=data['parent_name']
                    res['changes'] << {field: 'parent', message: "moved to another folder"}
                  end
                else
                  res['changes'] << {field: 'parent', message: "moved from root to folder"}
                end
              end

            end
          end

          # translation
          data['translation'].each do |lang, r|
            row_tran = row.translations.where(lang: lang).first

            ['meta_title', 'meta_keywords', 'meta_description'].each do |f|
              if row_tran.nil? || row_tran.send(f)!=r[f]
                res['changes'] << {field: "tran_#{f}", message: "changed"}
              end
            end
          end


        end



        # template
        #"template_basepath": "textpages/repair_of_flooded_laptop",
        #"layout_basepath": "layouts/article",

        if !data['is_folder']
          old_template_basepath = (row.template.basepath rescue "")


          if old_template_basepath != data['template_basepath']
            # check template exists
            row_template = Template.where(basepath: data['template_basepath']).first

            if row_template.nil?
              res['errors'] << {field: 'template', message: "not found: #{data['template_basepath']}"}
            else
              if row.nil?
                # it is new row

              else
                # updated row
                res['changes'] << {field: 'template', message: "changed"}
              end

            end


          end


          # layout
          old_layout_basepath = (row.layout.basepath rescue "")

          if old_layout_basepath != data['layout_basepath']
            # check layout exists
            row_layout = Template.layouts.where(basepath: data['layout_basepath']).first

            if row_layout.nil?
              res['errors'] << {field: 'layout', message: "not found: #{data['layout_basepath']}"}
            else
              if row.nil?
                # it is new row
              else
                res['changes'] << {field: 'layout', message: "changed"}
              end

            end


          end
        end



        # fix status
        if res['status']==''
          res['status'] = 'changed' if !res['changes'].empty?
          res['status'] = 'error' if !res['errors'].empty?
        end



        res
      end


      ### settings
      def self.dir_backups
        BackupMetadata::Backup.dir_backups
      end



      ### import
      def self.import(backup_dir, filename, cmd)
        dir_path = File.join(dir_backups, backup_dir, "pages")

        if cmd=='add'
          return import_add(dir_path, filename)
        elsif cmd=='update'
          return import_update(dir_path, filename)
        else
          raise 'unknown command'
        end

      rescue =>e
        return {res: 0, message: e.message}
      end

      def self.import_add(dir_path, filename)
        # init
        f = File.join(dir_path, filename)

        data = load_data(f)
        analysis = analyze_data(data)

        # precheck
        if analysis['status']!='new'
          raise 'Page is not NEW'
        end

        # insert to db
        row=Page.new(name: data['name'])
        init_from_data row, data

        row.save!



        res = {res: 1, message: "ok"}
        return res

      rescue => e
        res = {res: 0, message: e.message}
        return res
      end

      def self.import_update(dir_path, filename)
        # init
        f = File.join(dir_path, filename)

        data = load_data(f)
        analysis = analyze_data(data)

        # precheck
        if analysis['status']!='changed'
          raise 'Page is not CHANGED'
        end

        # update in db
        row = Page.where(name: data['name']).first
        init_from_data row, data
        row.save!



        res = {res: 1, message: "ok"}
        return res

      rescue => e
        res = {res: 0, message: e.message}
        return res
      end

      ###

      def self.init_from_data(row, data)


        #
        ['title',
         'url', 'url_parts_count', 'url_vars_count', 'parsed_url', 'redir_url',
          'pos', 'controller_action','status', 'enabled'
         ].each do |f|
          row.send("#{f}=", data[f])
        end

        row.is_folder = data['is_folder'] ? 1 : 0
        row.is_translated = data['is_translated'] ? 1 : 0

        # parent_name
        if data['parent_name']
          row.parent_id = Page.where(name: data['parent_name']).first.id
        else
          row.parent_id = nil
        end


        #"template_basepath"
        #"layout_basepath"

        if !data['is_folder']
          if data['template_basepath']
            row.template_id = Template.where(basepath: data['template_basepath']).first.id
          else
            row.template_id = nil
          end

          if data['layout_basepath']
            row.layout_id = Template.layouts.where(basepath: data['layout_basepath']).first.id
          else
            row.layout_id = nil
          end
        end



        # translation
        if !data['is_folder']
          row.build_translations

          data['translation'].each do |lang, r|
            #row.assign_attributes(translations_attributes: {"0"=>r})
            #row_tran = row.translations.where(lang: lang).first
            row_tran = row.translations.detect{|rt| rt.lang==lang}
            ['meta_title', 'meta_keywords', 'meta_description'].each do |f|
              row_tran.send("#{f}=", r[f])
            end

          end
        end



        row
      end
    end
  end
end

