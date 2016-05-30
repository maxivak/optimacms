module Optimacms
  class Admin::LayoutsController < Admin::AdminBaseController

    before_action :set_item, only: [:show, :edit, :update, :destroy]

    def index
      @items = model.all

    end

    def show
    end

    def new
      @article = model.new
    end

    def edit
    end

    # POST /articles
    def create
      @item = model.new(item_params)
      @res = @item.save

      if @res
        redirect_to url_list, success: 'Successfully created'
      else
        render :new
      end
    end

    def update
      @res = @item.update(item_params)

      if @res
        redirect_to url_list, success: 'Successfully updated'
      else
        render :edit
      end
    end

    # DELETE /articles/1
    def destroy
      @item.destroy
      redirect_to url_list, success: 'Successfully destroyed'
    end



    private
      def model
        Layout
      end
      def model_name
        :layout
      end

      def url_list
        layouts_url
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