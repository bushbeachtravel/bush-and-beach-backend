class Api::V1::LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.build(user_id: current_user.id, post_id: @post.id)
    render json: @like
  end
end
