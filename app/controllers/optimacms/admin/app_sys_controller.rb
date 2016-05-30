module Optimacms
  class Admin::AppSysController < Admin::AdminBaseController

    def index

    end




    def restart
      @res = Optimacms::Sys::AppFunctions.restart


      redirect_to_res @res
    end
  end
end

