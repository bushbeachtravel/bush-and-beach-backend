require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /current_user" do
    it "returns http success" do
      get "/api/v1/users/current_user"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/users/index"
      expect(response).to have_http_status(:success)
    end
  end

end
