module Optimacms
  class Admin::DeployController < Admin::AdminBaseController

    def lib_service
      Optimacms::Deploy::Service
    end

  def index
    @repo_data = Optimacms::Deploy::Settings.appdata_remote_repo(Rails.env)
    @dir_local_repo = Optimacms::Deploy::Settings.appdata_repo_path(Rails.env)


  end


  def server_save
    @res = Optimacms::Deploy::Service.run_rake_task("rake appdata:save  2>&1")


    respond_to do |format|
      format.html {      }
      format.json{        render :json=>@res}
    end
  end

  def server_update
    @res = Optimacms::Deploy::Service.run_rake_task("rake appdata:update  2>&1")


    respond_to do |format|
      format.html {      }
      format.json{        render :json=>@res}
    end
  end






end
end