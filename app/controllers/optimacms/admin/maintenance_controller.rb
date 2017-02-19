module Optimacms
  class Admin::MaintenanceController < Admin::AdminBaseController

    def url_index
      '/admin/maintenance'
    end


    def index

    end




    def restart
      @res = Optimacms::Sys::AppFunctions.restart


      redirect_to_res @res
    end

    def info

    end

    def assets_precompile
      res = %x(rake assets:precompile)

      return redirect_success
    end

    ### helpers

    def redirect_success(msg='OK')
      flash[:info] = msg
      redirect_to url_index
    end

  end
end

