class Api::V1::PostsController < ApplicationController
  # http_basic_authenticate_with name: 'dhh', password: 'secret', except: %i[index show]
  # before_action :set_post, only: %i[show update destroy]
  # before_action :authorize_post, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[update destroy create]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def create
    @post = current_user.posts.build(post_params)
    puts Rails.logger.debug(params.inspect)
    if @post.save
      # handle_image_uploads(@post)

      render json: @post
    else
      render error: { error: 'Unable to create a new Post' }, status: bad_request
    end
  end

  def like
    @user = current_user
    @post = current_user.posts.find(params[:id])
    @like = Like.find_or_create_by(author: current_user, post: @post)
    render json: @like
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_update)
      render json: @post
    else
      render json: { error: 'Unable to update post.' }, status: :bad_request
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post
      @post.destroy
      render json: { message: 'Post deleted successfully.' }, status: 200
    else
      render json: { error: 'Unable to delete post' }, status: :bad_request
    end
  end

  private

  def post_update
    params.require(:post).permit(body: {})
  end

  def post_params
    params.require(:post).permit(body: {})
  end

  def set_post
    @post = Post.find(params[:id])
  end

  # def handle_image_uploads(post)
  #   editorjs_data = params[:post][:body]

  #   uploaded_images = []

  #   editorjs_data.each do |block|
  #     if block['type'] == 'image'
  #       image_data = block['data']
  #       image_url = image_data['file']['url']

  #       image = post.images.create(url: image_url)
  #       uploaded_images << image
  #     end
  #   end
  #   uploaded_images
  # end
end
