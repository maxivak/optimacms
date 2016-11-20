module Optimacms
  class Admin::CssFilesController < Admin::AdminBaseController

    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :init_common
    before_action :init_data_form, only: [:new, :edit, :update, :create]


    ####
    def init_common

    end


    def index
      #
      @items = model.get_all

    end


    def show
    end

    def new
      @item = model.new

    end


    def create
      @item = model.new
      @item.update_attributes item_params
      @res = @item.save


      respond_to do |format|
        if @res
          format.html {  redirect_to edit_css_file_path(basepath: @item.basepath), success: 'Successfully created' }
          format.js {}
        else
          format.html {  render :new }
          format.js {}
        end
      end
    end


    def edit

    end


    def update
      # fix line breaks
      #content = data[:content]
      #content.gsub! /\r\n/, "\n"

      @item.update_attributes item_params
      @res = @item.save

      if @res
        u = params[:continue]=="1" ? edit_css_file_path(basepath: @item.basepath) : url_list
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


    end


    def model
      Optimacms::CssFile
    end

    def model_name
      :css_file
    end

    def url_list
      css_files_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Optimacms::CssFile.new
      @item.init_from_path(params[:basepath])

    end

    def item_params
      #params.require(model_name).permit(:title)
      params.require(model_name).permit!
    end



  end
end
