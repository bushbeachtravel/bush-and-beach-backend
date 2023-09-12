# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  respond_to :json

  REQUIRED_PARAMETERS = %i[name email password password_confirmation].freeze

  private

  def respond_with(resource, _opts = {})
    if request.method == 'POST'
      permitted_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
      if all_parameters_exist?(permitted_params)
        if resource.persisted?
          render json: {
            status: { code: 200, message: 'Signed up successfully' },
            data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: {
              code: 422,
              message: "User could not be created successfuly #{resource.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      else
        render json: {
          status: {
            code: 422,
            message: "Bad request #{resource.errors.full_messages.to_sentence} All parameters must be provided"
          }
        }, status: :unprocessable_entity
      end
    elsif request.method == 'DELETE'
      render json: {
        status: { code: 200, message: 'Account deleted successfully' }
      }, status: :ok
    end
  end

  def all_parameters_exist?(params)
    REQUIRED_PARAMETERS.all? { |param| params[param].present? }
  end
end
