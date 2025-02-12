require 'rails_helper'

RSpec.describe "/cards", type: :request do
  let(:admin) { create(:user, is_admin: true) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:brand) { create(:brand, user_id: admin.id) }
  let!(:active_product) { create(:product, brand: brand, owner: admin) }
  let!(:inactive_product) { create(:product, brand: brand, owner: admin, state: :inactive) }
  let!(:access_session) { create(:access_session, user: user, product: active_product) }
  let!(:card) { create(:card, user: user, product: active_product) }

  let(:valid_attributes) {
    { product_id: active_product.id }
  }

  let(:invalid_attributes) {
    { product_id: inactive_product.id }
  }

  let(:auth_headers) {
    extract_auth_params_from_sign_in_response_headers(response)
  }

  context "card owner" do
    before do
      sign_in(user.email, user.password)
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Card" do
          expect {
            post api_v1_cards_url,
                 params: { card: valid_attributes }, headers: auth_headers, as: :json
          }.to change(Card, :count).by(1)
        end

        it "renders a JSON response with the new card" do
          post api_v1_cards_url,
               params: { card: valid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Card" do
          expect {
            post api_v1_cards_url,
                 params: { card: invalid_attributes }, headers: auth_headers, as: :json
          }.to change(Card, :count).by(0)
        end

        it "renders a JSON response with errors for the new card" do
          post api_v1_cards_url,
               params: { card: invalid_attributes }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "PATCH /cards/1/active" do
      context "with valid parameters" do
        let(:activation_params) {
          { activation_number: card.activation_number }
        }

        it "active the requested card" do
          patch active_api_v1_card_url(card),
                params: activation_params, headers: auth_headers, as: :json

          expect(response).to have_http_status(:ok)

          card.reload
          expect(card.state).to eq("active")
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the card" do
          patch active_api_v1_card_url(card),
                params: { activation_number: 0 }, headers: auth_headers, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    describe "PATCH /cards/1/cancel" do
      it "active the requested card" do
        patch cancel_api_v1_card_url(card),
              params: {}, headers: auth_headers, as: :json

        expect(response).to have_http_status(:ok)
        card.reload
        expect(card.state).to eq("canceled")
      end
    end
  end

  context "other user" do
    before do
      sign_in(other_user.email, other_user.password)
    end

    describe "POST /create" do
      it "renders a unauthorized response" do
        expect {
          post api_v1_cards_url,
              params: { card: valid_attributes }, headers: auth_headers, as: :json
        }.to change(Card, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "PATCH /cards/1/active" do
      let(:activation_params) {
        { activation_number: card.activation_number }
      }

      it "renders a unauthorized response" do
        patch active_api_v1_card_url(card),
              params: activation_params, headers: auth_headers, as: :json

        expect(response).to have_http_status(:unauthorized)
        card.reload
        expect(card.state).to eq("issued")
      end
    end

    describe "PATCH /cards/1/cancel" do
      it "renders a unauthorized response" do
        patch cancel_api_v1_card_url(card),
              params: {}, headers: auth_headers, as: :json

        expect(response).to have_http_status(:unauthorized)
        card.reload
        expect(card.state).to eq("issued")
      end
    end
  end
end
