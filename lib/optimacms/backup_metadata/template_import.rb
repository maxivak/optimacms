module Optimacms
  module BackupMetadata
    class TemplateImport


      def self.analyze_data_dir(dir_path)
        #
        files = []

        #Dir["#{dir_path}/templates/*.json"].each do |f|
        Dir["#{dir_path}/*.json"].each do |f|
          files << f
        end

        #files_templates = files_templates.sort_by{ |x| File.mtime(x) }.reverse
        files = files.sort_by{ |x| File.basename(x, '.json') }

        #
        res = files.map do |f|
          data = load_template_data(f)
          analysis = analyze_template_data(data)

          {filename: File.basename(f), data: data, analysis: analysis}
        end


        res
      end


      def self.analyze_template_file(filename)
        data = load_template_data(filename)

        return analyze_template_data(data)
      end

      def self.load_template_data(filename)
        data = JSON.parse(File.read(filename))
      end

      def self.analyze_template_data(data)
        tpl_basepath = data['basepath']

        #
        res = {}
        res['status'] = ''
        res['basepath'] = tpl_basepath
        res['changes'] = []
        res['errors'] = []
        res['warnings'] = []


        # find in db
        row = Template.where(basepath: tpl_basepath).first

        # statuses: new, not_compatible, changed

        if row.nil?
          res['status'] = 'new'

          # folder
          if data['is_folder']

          else


          end

          # check parents
          if data['ancestry_path'] && data['ancestry_path']!=""
            parents = data['ancestry_path'].split /,/

            current_parent = nil
            parents.each do |s_parent|

              if current_parent.nil?
                row_parent = Template.roots.where(basename: s_parent).first
              else
                row_parent = Template.children_of(current_parent).where(basename: s_parent).first
              end

              #
              if row_parent.nil?
                res['errors'] << {field: 'parent', message: "parent not found: #{s_parent}"}

                res['status'] = 'error'
                break
              end

              # next step
              current_parent = row_parent


            end
          end

        else
          # compare fields
          basic_fields = ['title', 'tpl_format', 'is_translated']

          basic_fields.each do |field|
            if data[field]!=row.send(field.to_sym)
              res['changes'] << {field: field}
            end
          end

          # id
          if row.id != data['id'].to_i
            res['warnings'] << {field: 'id', message: "id changed"}
          end

          # folder
          if row.is_folder != data['is_folder']
            res['changes'] << {field: 'is_folder', message: "is folder error"}
          end

          # type
          row_type_name = (row.type.name rescue nil)
          #if (row.type_id.nil? && !data['type_id'].nil?) || (!row.type_id.nil? && data['type_id'].nil?)
          #  res['changes'] << {field: 'type'}
          #elsif row.type.name != data['type_name']
          #  res['changes'] << {field: 'type'}
          #end

          if row_type_name != data['type_name']
            res['changes'] << {field: 'type'}
          end

          # parent
          row_ancestry_path = (row.ancestors.map{|r| r.basepath}.join(",") rescue nil)

          if (row_ancestry_path.nil? && !data['ancestry_path'].nil?) || (!row_ancestry_path.nil? && data['ancestry_path'].nil?)
            res['changes'] << {field: 'parent'}
          else
            if row_ancestry_path != data['ancestry_path']
              res['changes'] << {field: 'parent'}
            end

          end

          #
          if !res['changes'].empty?
            res['status'] = 'changed'
          end

        end

        res
      end

      ### settings
      def self.dir_backups
        BackupMetadata::Backup.dir_backups
      end

      ### import
      def self.import_template(backup_dir, filename, cmd)
        dir_path = File.join(dir_backups, backup_dir, "templates")

        if cmd=='add'
          return import_template_add(dir_path, filename)
        elsif cmd=='update'
          return import_template_update(dir_path, filename)
        else
          raise 'unknown command'
        end

      rescue =>e
        return {res: 0, message: e.message}
      end

      def self.import_template_add(dir_path, filename)
        # init
        f = File.join(dir_path, filename)

        data = load_template_data(f)
        analysis = analyze_template_data(data)

        # precheck
        if analysis['status']!='new'
          raise 'Template is not NEW'
        end

        # insert to db
        row=Template.new(basepath: data['basepath'])
        init_template_from_data row, data

        row.save!



        res = {res: 1, message: "ok"}
        return res

      rescue => e
        res = {res: 0, message: e.message}
        return res
      end

      def self.import_template_update(dir_path, filename)
        # init
        f = File.join(dir_path, filename)

        data = load_template_data(f)
        analysis = analyze_template_data(data)

        # precheck
        if analysis['status']!='changed'
          raise 'Template is not CHANGED'
        end

        # update in db
        row = Template.where(basepath: data['basepath']).first
        init_template_from_data row, data
        row.save!



        res = {res: 1, message: "ok"}
        return res

      rescue => e
        res = {res: 0, message: e.message}
        return res
      end

      ###

      def self.init_template_from_data(row, data)
        #
        #{"title"=>"t5", "basedirpath"=>"temp/", "basename"=>"t5",
        # "type_id"=>"2", "tpl_format"=>"haml", "is_translated"=>"0"}

        ['title', 'basedirpath', 'basename', "tpl_format"].each do |f|
          row.send("#{f}=", data[f])
        end

        row.is_folder = data['is_folder'] ? 1 : 0
        row.is_translated = data['is_translated'] ? 1 : 0

        # type_id
        row.type_id = TemplateType.get_id_by_name(data['type_name'])


        row
      end
    end
  end
end
