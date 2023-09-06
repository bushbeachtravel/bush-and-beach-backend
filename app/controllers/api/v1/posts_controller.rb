class Api::V1::PostsController < ApplicationController
  # http_basic_authenticate_with name: 'dhh', password: 'secret', except: %i[index show]
  # before_action :set_post, only: %i[show update destroy]
  # before_action :authorize_post, only: %i[show update destroy]
  before_action :authenticate_user!

  def index
    @posts = current_user.posts
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
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

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_update)
      render json: { message: 'Post updated successfully.' }, status: 200
    else
      render json: { error: 'Unable to update post.' }, status: :bad_request
    end
  end

  def destroy
    if @post
      @post.destroy
      render json: { message: 'Post deleted successfully.' }, status: 200
    else
      render json: { error: 'Unable to delete post' }, status: :bad_request
    end
  end

  private

  def post_update
    params.require(:post).permit(:title, :body)
  end

  def post_params
    params.require(:post).permit(:title, :body, :author_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    authorize @post
  end
end
