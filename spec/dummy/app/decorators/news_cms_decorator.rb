class NewsCmsDecorator
  def initialize( _obj)
    @obj = _obj
  end


  def edit_path
    Rails.application.routes.url_helpers.edit_admin_news_path(@obj)
  end


end