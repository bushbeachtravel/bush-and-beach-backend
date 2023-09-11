class Api::V1::PhotosController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_photo, only: %i[show edit update destroy]
  def index
    @photos = Photo.allow
    render json: @photos
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      render json: @photo
    else
      render json: {
        status: 401,
        message: "Couldn't upload photo."
      }, status: :unauthorized
    end
  end

  def destroy
    if @photo.set_photo(photo_params)
      render json: @photo
    else
      render json: {
        status: 401,
        message: "Couldn't update the photo."
      }, status: :unauthorized
    end
  end

  def update
    if @photo.update(params)
      render json: @photo
    else
      render json: {
        status: 401,
        message: "Couldn't update the photo"
      }, status: :unauthorized
    end
  end

  private

  def set_photo
    @photo = Photo.find([:id])
  end

  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
