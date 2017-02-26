module Optimacms
  class Admin::UsersController < Admin::AdminBaseController
    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :init_common
    before_action :init_data_form, only: [:new, :edit, :update, :create]



    def init_common

    end



    search_filter :index, {save_session: true, search_method: :post_and_redirect, url: :users_url, search_url: :search_users_url, search_action: :search} do
      # define filter
      default_order "username", 'asc'

      # fields
      field :username, :string, :text, {label: '', default_value: '', condition: :like_full}
    end

    def index
      @items = model.by_filter(@filter)

    end


    def show
    end

    def new
      @item = model.new

    end


    def create
      @item = model.new(item_params)
      @res = @item.save

      respond_to do |format|
        if @res
          format.html {
            u = params[:continue]=="1" ? edit_user_path(@item) : url_list
            redirect_to u, success: 'Successfully created'
          }
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
      @item.save
      @item.reload

    end


    def update
      @item.attributes = item_params
      @res = @item.save

      if @res
        u = params[:continue]=="1" ? edit_user_path(@item) : url_list
        redirect_to u, success: 'Successfully updated'
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

      #@languages = Language.list_with_default
    end


    def model
      CmsAdminUser
    end

    def model_param_name
      :cms_admin_user
    end

    def url_list
      users_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = model.find(params[:id])

      @url_back = url_list
    end

    def item_params
      params.require(model_param_name).permit(:username, :email, :password, :password_confirmation)
      #params.require(model_param_name).permit!
    end




  end
end

