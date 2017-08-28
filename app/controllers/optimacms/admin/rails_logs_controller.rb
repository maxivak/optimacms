module Optimacms
  class Admin::RailsLogsController < Admin::AdminBaseController

  def index

  end

  def list_logs
    name = params[:name]

    send "list_logs_#{name}"
  end

  def list_logs_app
    @path = File.join(Rails.root, 'log', Rails.env + ".log")
    @filename = File.basename(@path)

    @text = `tail -n 2000 #{@path}`

    render :template => "optimacms/admin/rails_logs/list_logs_app.html.haml"
  end


end
end