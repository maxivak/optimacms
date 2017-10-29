module Optimacms
  class Admin::AppdataController < Admin::AdminBaseController

    def lib_service
      Optimacms::Appdata::Service
    end

    def index
      @list = Optimacms::Appdata::Settings.list_content(Rails.env)
      #@repo_data = Optimacms::Appdata::Settings.appdata_remote_repo(Rails.env)
      #@dir_local_repo = Optimacms::Appdata::Settings.appdata_repo_path(Rails.env)

    end


    def save
      @res = Optimacms::Appdata::Service.save(Rails.env, params[:content])


      respond_to do |format|
        format.html {      }
        format.json{        render :json=>@res}
      end
    end

    def update
      @res = Optimacms::Appdata::Service.update(Rails.env, params[:content])


      respond_to do |format|
        format.html {      }
        format.json{        render :json=>@res}
      end
    end


  end
end