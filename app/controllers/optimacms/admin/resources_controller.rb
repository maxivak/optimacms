module Optimacms
  class Admin::ResourcesController < Admin::AdminBaseController

    before_action :set_item, :only => [:edit, :update, :destroy, :usage]
    before_action :init_form_data, :only => [:new, :create, :edit, :update,]

    # search
    search_filter :index, {save_session: true, search_method: :post_and_redirect, url: :resources_url, search_url: :search_resources_url, search_action: :search} do
      default_order "name", 'asc'

      # fields
      field :name, :string, :text, {label: 'Name', default_value: '', condition: :like_full, input_html: {style: "width: 140px"}}

      field :enabled, :int, :select, {
          label: 'Enabled',
          default_value: -1, ignore_value: -1,
          collection: FilterHelper.for_select_yes_no('Enabled -- all')
      }
    end

    def model
      Resource
    end

    def model_name
      :resource
    end


    def url_list
      resources_path
    end

    def new
      @item = model.new

    end

    def show
    end

    def edit

    end


    def init_form_data
      @languages = Language.list_with_default
    end

    def index
      @items = model.by_filter(@filter)

    end


    def create

      res = model.new(item_params)

      res.save

      respond_to do |format|
        if res
          format.html { redirect_to url_list, notice: 'Saved' }
          #format.json { render :show, status: :created, location: @message }
          format.js   { }
        else
          format.html { render :new }
          format.json { render json: @item.errors, status: :unprocessable_entity }
          format.js   { }
        end
      end
    end

    def update
      #
      @res = @item.update(item_params)

      #
      respond_to do |format|
        if @res
          format.html {            redirect_to url_list, notice: 'Saved'          }
          #format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          #format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @item.destroy

      respond_to do |format|
        format.html { redirect_to url_list, notice: 'Saved' }
        format.json { head :no_content }
        format.js   { render layout: false }
      end
    end


    def usage
      @usages = @item.get_usages


    end

    private

    def set_item
      @item = model.find(params[:id])
    end

    def item_params
      params.require(model_name).permit(:title, :name, :enabled, :description, :pos, *model.globalize_attribute_names)
    end

  end

end
