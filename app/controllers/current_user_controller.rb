class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_privileges, only: [:destroy]

  def index
    render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
  end

  def all_users
    unless current_user.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    users = User.all

    render json: ActiveModel::Serializers::CollectionSerializer.new(
      users,
      each_serializer: UserSerializer
    ).as_json, status: :ok
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  private

  def check_admin_privileges
    return if current_user.admin?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
