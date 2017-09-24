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
  end
end

