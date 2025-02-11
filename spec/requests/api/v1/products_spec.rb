require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }
  let(:brand) { create(:brand, user_id: admin.id) }

  let(:valid_attributes) {
    { name: Faker::Name.name, brand_id: brand.id  }
  }

  let(:invalid_attributes) {
    { name: "" }
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # ProductsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Product.create! valid_attributes
      get api_v1_products_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      product = Product.create! valid_attributes
      get api_v1_product_url(product), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post api_v1_products_url,
               params: { product: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post api_v1_products_url,
             params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post api_v1_products_url,
               params: { product: invalid_attributes }, as: :json
        }.to change(Product, :count).by(0)
      end

      it "renders a JSON response with errors for the new product" do
        post api_v1_products_url,
             params: { product: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "updated-name" }
      }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        product.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the product" do
        product = Product.create! valid_attributes
        patch api_v1_product_url(product),
              params: { product: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the product" do
        product = Product.create! valid_attributes
        patch api_v1_product_url(product),
              params: { product: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect {
        delete api_v1_product_url(product), headers: valid_headers, as: :json
      }.to change(Product, :count).by(-1)
    end
  end
end
