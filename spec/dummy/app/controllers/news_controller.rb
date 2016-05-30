class NewsController < ApplicationController

  before_action :set_page, only: [:index, :index_page]

  def index

    x = params[:pg]

    @items = News.all


  end

  def show
    @item = News.find params['id']
  end

  def index_page(tpl_filename=nil)

    @items = News.all

    @v_news = 9

    #@template = 'pages/news2.html.erb'
    #render nothing: true
    #(render template: tpl_filename) unless tpl_filename.nil?
    #my_render

    #render 'pages/news2.html'
    #render template: 'pages/news2.html.erb', locals: {pg: 4}

  end


  def default_render11(*args)
    #render 'pages/news2.html.erb'
    unless @optimacms_tpl.nil?
      render @optimacms_tpl and return
    end

    super
  end

  def set_page
    @pg = params[:pg] || 1
  end

end
