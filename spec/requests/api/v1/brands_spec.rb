require 'rails_helper'

RSpec.describe "/api/v1/brands", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }

  let!(:valid_attributes) {
    { name: Faker::Name.name }
  }

  let!(:invalid_attributes) {
    { name: "" }
  }

  let!(:brand) { create(:brand, user_id: admin.id, name: Faker::Name.name) }

  let(:auth_headers) {
    extract_auth_params_from_sign_in_response_headers(response)
  }

  context 'admin user' do
    before do
      sign_in(admin.email, admin.password)
    end

    describe "GET /index" do
      it "renders a successful response" do
        get api_v1_brands_url, headers: auth_headers, as: :json
        expect(response).to be_successful
        expect(response_body["data"].size).to eq(1)
        expect(json_attributes(:name, index: 0)).to eq(brand.name)
        expect(json_relationships(:owner, index: 0)[:type]).to eq("user")
        expect(json_included[:email]).to eq(admin.email)
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        get api_v1_brand_url(brand), headers: auth_headers, as: :json
        expect(response).to be_successful
        expect(json_attributes(:name)).to eq(brand.name)
        expect(json_relationships(:owner)[:type]).to eq("user")
        expect(json_included[:email]).to eq(admin.email)
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
          expect(json_attributes(:name)).to eq(Brand.last.name)
          expect(json_relationships(:owner)[:type]).to eq("user")
          expect(json_included[:email]).to eq(admin.email)
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

        it "not allow to create duplicate brand name" do
          post api_v1_brands_url,
              params: { brand: { name: brand.name } }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) {
          { name: 'updated name' }
        }

        it "updates the requested brand" do
          patch api_v1_brand_url(brand),
                params: { brand: new_attributes }, headers: auth_headers, as: :json
          brand.reload
          expect(brand.reload.name).to eq(new_attributes[:name])
        end

        it "renders a JSON response with the brand" do
          patch api_v1_brand_url(brand),
                params: { brand: new_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(json_attributes(:name)).to eq(brand.reload.name)
          expect(json_relationships(:owner)[:type]).to eq("user")
          expect(json_included[:email]).to eq(admin.email)
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the brand" do
          patch api_v1_brand_url(brand),
                params: { brand: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end


    describe "PATCH /update_state" do
      context "with valid state" do
        let(:new_attributes) {
          { state: "inactive" }
        }

        it "updates the brand state" do
          patch update_state_api_v1_brand_path(brand),
                params: { brand: new_attributes }, headers: auth_headers, as: :json
          brand.reload
          expect(brand.reload.state).to eq(new_attributes[:state])
        end

        it "renders a JSON response with the new state" do
          patch update_state_api_v1_brand_path(brand),
                params: { brand: new_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(json_attributes(:state)).to eq(brand.reload.state)
        end
      end

      context "with invalid state" do
        it "not update state and renders unprocessable_entity" do
          patch update_state_api_v1_brand_path(brand),
                params: { brand: { state: "" } }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(brand.state).to eq(brand.reload.state)
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested brand" do
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
        get api_v1_brands_url, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "GET /show" do
      it "renders a unauthorized response" do
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
        patch api_v1_brand_url(brand),
              params: { brand: new_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /destroy" do
      it "renders a unauthorized response" do
        expect {
          delete api_v1_brand_url(brand), headers: auth_headers, as: :json
        }.to change(Brand, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
