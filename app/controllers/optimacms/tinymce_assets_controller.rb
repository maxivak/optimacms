class Optimacms::TinymceAssetsController < ApplicationController

  def create
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed

    #params.require(:photo).permit(:title, :description, :photo)
    #@item = model.build item_params

    item = Optimacms::Mediafile.new(:photo=>params[:file])
    res = item.save


    render json: {
      image: {
        #url: view_context.image_url(item.photo_url)
        url: item.photo.url
      }
    }, content_type: "text/html"
  end
end