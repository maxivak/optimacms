class  Optimacms::Admin::ContentSourcesController < Optimacms::Admin::AdminBaseController



  def index
    @data_obj = Optimacms::RemoteContent::SourcesList.new

    @items = @data_obj.items
  end

  def show
    # input
    @name = params[:id]

    #
    @item = Optimacms::RemoteContent::Sources.get_source_info @name


  end

  def clean_cache
    @name = params[:id]

    #

    Optimacms::RemoteContent::CacheManager.remove_content @name
    Optimacms::RemoteContent::CacheManager.remove_templates @name


    @res = true
    redirect_to_res @res
  end


  ### helpers

  def redirect_success(msg='OK')
    flash[:info] = msg
    redirect_to url_index
  end

end

