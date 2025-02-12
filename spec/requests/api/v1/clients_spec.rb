require 'rails_helper'

RSpec.describe "/clients", type: :request do
  let(:admin) { create(:user, is_admin: true) }
  let(:user) { create(:user) }

  let(:email) { Faker::Internet.unique.email }
  let(:password) { Faker::Internet.password(min_length: 10) }

  let(:valid_attributes) {
    { email:, password:, payout_rate: 10 }
  }

  let(:invalid_attributes) {
    { email:, password:, payout_rate: 0 }
  }

  let(:auth_headers) {
    extract_auth_params_from_sign_in_response_headers(response)
  }

  context "admin user" do
    before do
      sign_in(admin.email, admin.password)
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Client" do
          expect {
            post api_v1_clients_url,
                params: { client: valid_attributes }, headers: auth_headers, as: :json
          }.to change(User, :count).by(1)
        end

        it "renders a JSON response with the new client" do
          post api_v1_clients_url,
              params: { client: valid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Client" do
          expect {
            post api_v1_clients_url,
                params: { client: invalid_attributes }, headers: auth_headers, as: :json
          }.to change(User, :count).by(0)
        end

        it "renders a JSON response with errors for the new client" do
          post api_v1_clients_url,
              params: { client: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested client" do
        client = User.create! valid_attributes
        expect {
          delete api_v1_client_url(client), headers: auth_headers, as: :json
        }.to change(User, :count).by(-1)
      end
    end
  end

  context "normal user" do
    before do
      sign_in(user.email, user.password)
    end

    describe "POST /create" do
      it "renders a unauthorized response" do
        expect {
          post api_v1_clients_url,
              params: { client: valid_attributes }, headers: auth_headers, as: :json
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /destroy" do
      it "renders a unauthorized response" do
        client = User.create! valid_attributes
        expect {
          delete api_v1_client_url(client), headers: auth_headers, as: :json
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
