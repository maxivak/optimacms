module Optimacms
  class Admin::LanguagesController < Admin::AdminBaseController

    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :init_data_form, only: [:new, :edit]


    # search
    search_filter :index, {save_session: true, search_method: :post_and_redirect, url: :languages_url, search_url: :search_languages_url, search_action: :search} do
      default_order "pos", 'asc'

      # fields
      #field :title, :string, :text, {label: 'Title', default_value: '', condition: :like_full, input_html: {style: "width: 240px"}}



    end


    def index
      #@filter.set_order('pos','asc')
      @items = model.by_filter(@filter)

    end




    def show
    end

    def new
      @item = model.new
      @url_back = url_list
    end


    def create
      @item = model.new(item_params)
      @res = @item.save

      respond_to do |format|
        if @res
          format.html {  redirect_to edit_language_path(@item), success: 'Saved' }
          #format.json {  render json: @item, status: :created, location: user_clients_url(:action => 'index')        }
          format.js {}
        else
          format.html {  render :new }
          #format.json { render json: @item.errors, status: :unprocessable_entity }
          format.js {}
        end
      end
    end


    def edit
    end


    def update
      @res = @item.update(item_params)

      if @res
        redirect_to url_list, success: 'Saved'
      else
        render :edit
      end
    end


    def destroy
      @res = @item.destroy

      if @res
        redirect_to url_list, success: 'Successfully deleted'
      else
        redirect_to url_list, error: 'Cannot delete'
      end
    end



    private

    def init_data_form
      @url_back = url_list

    end


    def model
      Language
    end
    def model_name
      :language
    end

    def url_list
      languages_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = model.find(params[:id])

      @url_back = url_list
    end


    def item_params
      #params.require(model_name).permit(:title)
      params.require(model_name).permit!
    end


  end
end
