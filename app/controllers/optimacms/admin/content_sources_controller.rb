class  Optimacms::Admin::ContentSourcesController < Optimacms::Admin::AdminBaseController

  def index
    @items = content_sources
  end

  def show
    # input
    @name = params[:id]

    @item = Friendlycontent::Rails.config.get_source_info @name

    # TODO: redirect to list if not found
  end

  def clean_cache
    @source_name = params[:id]

    Friendlycontent::Rails::ContentManager.expire_all_for_source @source_name
    #Optimacms::RemoteContent::CacheManager.remove_content @source_name
    #Optimacms::RemoteContent::CacheManager.remove_templates @source_name


    @res = true
    redirect_to_res @res
  end


  ### helpers

  def redirect_success(msg='OK')
    flash[:info] = msg
    redirect_to url_index
  end


  private

  def content_sources
    ::Friendlycontent::Rails.config.content_sources
  end
end

