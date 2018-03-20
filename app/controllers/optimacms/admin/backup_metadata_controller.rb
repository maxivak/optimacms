module Optimacms
  class Admin::BackupMetadataController < Admin::AdminBaseController

    def lib_service
      Optimacms::BackupMetadata::Backup
    end

    def index
      @list_backups = lib_service.list_backups
    end

    def backup
      @res = lib_service.perform_backup


      respond_to do |format|
        format.html {      }
        format.json{        render :json=>@res      }
      end
    end

    def upload
      # input
      uploaded_file = params[:import][:file]


      #
      @res = BackupMetadata::Backup.upload_backup uploaded_file


      redirect_to backup_metadata_path
    end


    def view
      # input
      @filename = params[:f]
      @dirname = params[:dirname]

      #
      @backup_filename = BackupMetadata::Backup.make_backup_path @filename


    end

    def download
      f = params[:f]

      path = File.join(BackupMetadata::Backup.dir_backups, f)

      data = IO.read(path)
      send_data data, filename: f
      #send_file path
    end

    def delete
      f =  CGI::unescape(params[:f])
      @res = BackupMetadata::Backup.delete_backup(f)

      #
      respond_to do |format|
        format.html {      }
        format.js{ }
        format.json{        render :json=>@res      }
      end
    end


    ### import templates

    def reviewimport_templates
      # input
      @dirname = params[:dirname]

      # work
      @backup_basedir = Optimacms::BackupMetadata::Backup.make_backup_dir_path @dirname
      @backup_templates_dirpath = File.join(@backup_basedir, "templates")
      @analysis = Optimacms::BackupMetadata::TemplateImport.analyze_data_dir(@backup_templates_dirpath)

    end



    def import_template
      # input
      @backup_dir = params[:backup_dir]
      @filename = params[:filename]
      @cmd = params[:cmd]

      # work
      @res = Optimacms::BackupMetadata::TemplateImport.import_template(@backup_dir, @filename, @cmd)


      respond_to do |format|
        format.html {      }
        format.json{        render :json=>@res      }
      end
    end


    ### import pages

    def reviewimport_pages
      # input
      @dirname = params[:dirname]

      # work
      @backup_basedir = Optimacms::BackupMetadata::Backup.make_backup_dir_path @dirname
      @backup_templates_dirpath = File.join(@backup_basedir, "pages")

      @analysis = Optimacms::BackupMetadata::PageImport.analyze_data_dir(@backup_templates_dirpath)

    end


    def import_page
      # input
      @backup_dir = params[:backup_dir]
      @filename = params[:filename]
      @cmd = params[:cmd]

      # work
      @res = Optimacms::BackupMetadata::PageImport.import(@backup_dir, @filename, @cmd)


      respond_to do |format|
        format.html {      }
        format.json{        render :json=>@res      }
      end
    end


  end
end

