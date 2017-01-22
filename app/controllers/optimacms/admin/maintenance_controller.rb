module Optimacms
  class Admin::MaintenanceController < Admin::AdminBaseController

    def index

    end




    def restart
      @res = Optimacms::Sys::AppFunctions.restart


      redirect_to_res @res
    end

    def info

    end
  end
end

