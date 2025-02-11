require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }
  let(:brand) { create(:brand, user_id: admin.id) }
  let!(:product) { create(:product, brand: brand, owner: admin) }

  let(:valid_attributes) {
    { name: Faker::Name.name, brand_id: brand.id, price: 9.9, currency: 'usd'  }
  }

  let(:invalid_attributes) {
    { name: "", brand_id: brand.id, price: 9.9, currency: "usd" }
  }

  let(:invalid_currency) {
    { name: "product", brand_id: brand.id, price: 9.9, currency: "money" }
  }

  let(:invalid_price) {
    { name: "product", brand_id: brand.id, price: 0.0, currency: "usd" }
  }

  let(:auth_headers) {
    extract_auth_params_from_sign_in_response_headers(response)
  }

  context "admin user" do
    before do
      sign_in(admin.email, admin.password)
    end

    describe "GET /index" do
      it "renders a successful response" do
        get api_v1_products_url, headers: auth_headers, as: :json
        expect(response).to be_successful
        expect(response_body["data"].size).to eq(1)
        expect(json_attributes(:name, index: 0)).to eq(product.name)
        expect(json_relationships(:brand, index: 0)[:type]).to eq("brand")
        expect(json_included[:name]).to eq(brand.name)
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        get api_v1_product_url(product), headers: auth_headers, as: :json
        expect(response).to be_successful
        expect(json_attributes(:name)).to eq(product.name)
        expect(json_relationships(:brand)[:type]).to eq("brand")
        expect(json_included[:name]).to eq(brand.name)
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Product" do
          expect {
            post api_v1_products_url,
                params: { product: valid_attributes }, headers: auth_headers, as: :json
          }.to change(Product, :count).by(1)
        end

        it "renders a JSON response with the new product" do
          post api_v1_products_url,
              params: { product: valid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(json_attributes(:name)).to eq(Product.last.name)
          expect(json_relationships(:brand)[:type]).to eq("brand")
          expect(json_included[:name]).to eq(brand.name)
        end
      end

      context "with invalid parameters" do
        it "does not create a new Brand" do
          expect {
            post api_v1_products_url,
                params: { product: invalid_attributes }, headers: auth_headers, as: :json

            post api_v1_products_url,
                params: { product: invalid_currency }, headers: auth_headers, as: :json

            post api_v1_products_url,
                params: { product: invalid_price }, headers: auth_headers, as: :json
          }.to change(Product, :count).by(0)
        end

        it "renders a JSON response with errors for the new product" do
          post api_v1_products_url,
              params: { product: invalid_attributes }, headers: auth_headers, as: :json
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

        it "updates the requested product" do
          patch api_v1_product_url(product),
                params: { product: new_attributes }, headers: auth_headers, as: :json
          product.reload
          expect(product.reload.name).to eq(new_attributes[:name])
        end

        it "renders a JSON response with the product" do
          patch api_v1_product_url(product),
                params: { product: new_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(json_attributes(:name)).to eq(product.reload.name)
          expect(json_relationships(:brand)[:type]).to eq("brand")
          expect(json_included[:name]).to eq(brand.name)
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the product" do
          patch api_v1_product_url(product),
                params: { product: invalid_attributes }, headers: auth_headers, as: :json
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

        it "updates the product state" do
          patch update_state_api_v1_product_path(product),
                params: { product: new_attributes }, headers: auth_headers, as: :json
          product.reload
          expect(product.reload.state).to eq(new_attributes[:state])
        end

        it "renders a JSON response with the new state" do
          patch update_state_api_v1_product_path(product),
                params: { product: new_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(json_attributes(:state)).to eq(product.reload.state)
        end
      end

      context "with invalid state" do
        it "not update state and renders unprocessable_entity" do
          patch update_state_api_v1_product_path(product),
                params: { product: { state: "" } }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(product.state).to eq(product.reload.state)
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested product" do
        expect {
          delete api_v1_product_url(product), headers: auth_headers, as: :json
        }.to change(Product, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  context 'normal user' do
    before do
      sign_in(user.email, user.password)
    end

    describe "GET /index" do
      it "renders a successful response" do
        get api_v1_products_url, headers: auth_headers, as: :json
        expect(response).to be_successful
        expect(response_body["data"].size).to eq(1)
        expect(json_attributes(:name, index: 0)).to eq(product.name)
        expect(json_relationships(:brand, index: 0)[:type]).to eq("brand")
        expect(json_included[:name]).to eq(brand.name)
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        get api_v1_product_url(product), headers: auth_headers, as: :json
        expect(response).to be_successful
        expect(json_attributes(:name)).to eq(product.name)
        expect(json_relationships(:brand)[:type]).to eq("brand")
        expect(json_included[:name]).to eq(brand.name)
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
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /destroy" do
      it "renders a unauthorized response" do
        expect {
          delete api_v1_product_url(product), headers: auth_headers, as: :json
        }.to change(Product, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
