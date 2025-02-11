require 'rails_helper'

RSpec.describe "/assignments", type: :request do
  let(:admin) { create(:user, is_admin: true) }
  let(:user) { create(:user) }
  let(:client) { create(:client, user: user) }
  let(:brand) { create(:brand, user_id: admin.id) }
  let!(:active_product) { create(:product, brand: brand, owner: admin) }
  let!(:inactive_product) { create(:product, brand: brand, owner: admin, state: :inactive) }

  let(:valid_attributes) {
    { client_id: client.id, product_id: active_product.id, duration: 1.month }
  }

  let(:invalid_attributes) {
    { client_id: client.id, product_id: inactive_product.id, duration: 1.month }
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
        it "creates a new assignment" do
          expect {
            post api_v1_assignments_url,
                params: { assignment: valid_attributes }, headers: auth_headers, as: :json
          }.to change(Assignment, :count).by(1)
        end

        it "renders a JSON response with the new assignment" do
          post api_v1_assignments_url,
              params: { assignment: valid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new assignment" do
          expect {
            post api_v1_assignments_url,
                params: { assignment: invalid_attributes }, headers: auth_headers, as: :json
          }.to change(Assignment, :count).by(0)
        end

        it "renders a JSON response with errors for the new assignment" do
          post api_v1_assignments_url,
              params: { assignment: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested client" do
        assignment = Assignment.create! valid_attributes
        expect {
          delete api_v1_assignment_url(assignment), headers: auth_headers, as: :json
        }.to change(Assignment, :count).by(-1)
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
          post api_v1_assignments_url,
              params: { assignment: valid_attributes }, headers: auth_headers, as: :json
        }.to change(Assignment, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /destroy" do
      it "renders a unauthorized response" do
        assignment = Assignment.create! valid_attributes
        expect {
          delete api_v1_assignment_url(assignment), headers: auth_headers, as: :json
        }.to change(Assignment, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
