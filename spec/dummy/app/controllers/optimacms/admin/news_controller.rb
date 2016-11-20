class Optimacms::Admin::NewsController < Optimacms::Admin::AdminBaseController
  #search
  search_filter :index, {save_session: true, search_method: :post_and_redirect, url: :admin_news_index_url, search_url: :search_admin_news_index_url, search_action: :search} do
    default_order "id", 'desc'

    # fields
    field :title, :string, :text, {label: 'title', default_value: '', condition: :like_full, input_html: {style: "width: 240px"}}
  end

  def index

    @items = News.by_filter(@filter)

  end

  def search2
    redirect_to action: :index
  end

end
