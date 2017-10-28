class Optimacms::Admin::CommonController < Optimacms::Admin::AdminBaseController

  before_action :init_data

  def init_data
    @res = params[:res].to_i
  end


  def res

  end
end

