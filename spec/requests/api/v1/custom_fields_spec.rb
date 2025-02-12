require 'rails_helper'

RSpec.describe "/custom_fields", type: :request do
    let!(:admin) { create(:user, is_admin: true) }
    let!(:user) { create(:user) }
    let!(:brand) { create(:brand, user_id: admin.id) }

    let(:valid_attributes) {
        { customable_type: "Brand", customable_id: brand.id, field_type: "Text", field_name: "description" }
    }

    let(:invalid_attributes) {
        { customable_type: "Brand", customable_id: brand.id, field_type: "Text", field_name: "" }
    }

    let(:auth_headers) {
        extract_auth_params_from_sign_in_response_headers(response)
    }

    context "admin" do
        before do
            sign_in(admin.email, admin.password)
        end

        describe "POST /create" do
            context "with valid parameters" do
            it "creates a new custom_field" do
                expect {
                post api_v1_custom_fields_url,
                    params: { custom_field: valid_attributes }, headers: auth_headers, as: :json
                }.to change(CustomField, :count).by(1)
            end

            it "renders a JSON response with the new custom_field" do
                post api_v1_custom_fields_url,
                    params: { custom_field: valid_attributes }, headers: auth_headers, as: :json
                expect(response).to have_http_status(:created)
                expect(response.content_type).to match(a_string_including("application/json"))

                expect(brand.reload.custom_fields_count).to eq(1)
            end
            end

            context "with invalid parameters" do
            it "does not create a new access_session" do
                expect {
                post api_v1_custom_fields_url,
                    params: { custom_field: invalid_attributes }, headers: auth_headers, as: :json
                }.to change(CustomField, :count).by(0)
            end

            it "renders a JSON response with errors for the new access_session" do
                post api_v1_custom_fields_url,
                    params: { custom_field: invalid_attributes }, headers: auth_headers, as: :json
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.content_type).to match(a_string_including("application/json"))
            end
            end
        end

        describe "DELETE /destroy" do
            it "destroys the requested client" do
                custom_field = CustomField.create! valid_attributes
                expect {
                    delete api_v1_custom_field_url(custom_field), headers: auth_headers, as: :json
                }.to change(CustomField, :count).by(-1)
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
                post api_v1_custom_fields_url,
                    params: { custom_field: valid_attributes }, headers: auth_headers, as: :json
                }.to change(CustomField, :count).by(0)
                expect(response).to have_http_status(:unauthorized)
            end
        end

        describe "DELETE /destroy" do
            it "renders a unauthorized response" do
                custom_field = CustomField.create! valid_attributes
                expect {
                    delete api_v1_custom_field_url(custom_field), headers: auth_headers, as: :json
                }.to change(CustomField, :count).by(0)
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end
