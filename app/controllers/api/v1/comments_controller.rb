class Api::V1::CommentsController < ApplicationController
  # http_basic_authenticate_with name: 'dhh', password: 'secret', except: %i[index show]
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.post = Post.find(params[:post_id])

    authorize! :create, @comment
    if @comment.save
      render json: {
        status: {code: 200, message: 'Comment updated'},

      }, status: :ok
    else
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    render json: @post
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    render json: @post
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
