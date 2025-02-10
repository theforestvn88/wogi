require 'rails_helper'

RSpec.describe "/api/v1/brands", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }

  let(:valid_attributes) {
    { name: Faker::Name.name, user_id: user.id }
  }

  let(:invalid_attributes) {
    { name: "", user_id: user.id }
  }

  let(:auth_headers) {
    get_auth_params_from_sign_in_response_headers(response)
  }

  context 'admin user' do
    before do
      sign_in(admin.email, admin.password)
    end

    describe "GET /index" do
      it "renders a successful response" do
        Brand.create! valid_attributes
        get api_v1_brands_url, headers: auth_headers, as: :json
        expect(response).to be_successful
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        brand = Brand.create! valid_attributes
        get api_v1_brand_url(brand), headers: auth_headers, as: :json
        expect(response).to be_successful
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Brand" do
          expect {
            post api_v1_brands_url,
                params: { brand: valid_attributes }, headers: auth_headers, as: :json
          }.to change(Brand, :count).by(1)
        end

        it "renders a JSON response with the new brand" do
          post api_v1_brands_url,
              params: { brand: valid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Brand" do
          expect {
            post api_v1_brands_url,
                params: { brand: invalid_attributes }, headers: auth_headers, as: :json
          }.to change(Brand, :count).by(0)
        end

        it "renders a JSON response with errors for the new brand" do
          post api_v1_brands_url,
              params: { brand: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) {
          { name: 'updated name' }
        }

        it "updates the requested brand" do
          brand = Brand.create! valid_attributes
          patch api_v1_brand_url(brand),
                params: { brand: new_attributes }, headers: auth_headers, as: :json
          brand.reload
          skip("Add assertions for updated state")
        end

        it "renders a JSON response with the brand" do
          brand = Brand.create! valid_attributes
          patch api_v1_brand_url(brand),
                params: { brand: new_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the brand" do
          brand = Brand.create! valid_attributes
          patch api_v1_brand_url(brand),
                params: { brand: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested brand" do
        brand = Brand.create! valid_attributes
        expect {
          delete api_v1_brand_url(brand), headers: auth_headers, as: :json
        }.to change(Brand, :count).by(-1)
      end
    end
  end

  context 'normal user' do
    before do
      sign_in(user.email, user.password)
    end

    describe "GET /index" do
      it "renders a unauthorized response" do
        Brand.create! valid_attributes
        get api_v1_brands_url, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "GET /show" do
      it "renders a unauthorized response" do
        brand = Brand.create! valid_attributes
        get api_v1_brand_url(brand), headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "POST /create" do
      it "renders a unauthorized response" do
        expect {
          post api_v1_brands_url,
              params: { brand: valid_attributes }, headers: auth_headers, as: :json
        }.to change(Brand, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PATCH /update" do
      let(:new_attributes) {
        { name: 'updated' }
      }

      it "renders a unauthorized response" do
        brand = Brand.create! valid_attributes
        patch api_v1_brand_url(brand),
              params: { brand: new_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /destroy" do
      it "renders a unauthorized response" do
        brand = Brand.create! valid_attributes
        expect {
          delete api_v1_brand_url(brand), headers: auth_headers, as: :json
        }.to change(Brand, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
