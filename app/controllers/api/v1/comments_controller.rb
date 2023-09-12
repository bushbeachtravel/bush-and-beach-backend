class Api::V1::CommentsController < ApplicationController
  # http_basic_authenticate_with name: 'dhh', password: 'secret', except: %i[index show]
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:user)
    comments_with_author = @comments.map do |comment|
      {
        id: comment.id,
        text: comment.text,
        author_email: comment.user.email,
        author_id: comment.user.id,
        time_created: comment.created_at
      }
    end
    render json: comments_with_author
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = Post.find(params[:post_id])

    # authorize! :create, @comment
    if @comment.save
      render json: {
        status: { code: 200, message: 'Comment updated' }

      }, status: :ok
    else
      @post = Post.find(params[:post_id])
      @comment = @post.comments.create(comment_params)
      render json: @post
    end
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
