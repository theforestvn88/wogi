require 'rails_helper'

RSpec.describe "/api/v1/reports", type: :request do
  let(:admin) { create(:user, is_admin: true) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:brand) { create(:brand, user_id: admin.id) }
  let!(:product1) { create(:product, brand: brand, owner: admin) }
  let!(:product2) { create(:product, brand: brand, owner: admin) }
  let!(:access_session) { create(:access_session, user: user1, product: product1) }
  let!(:access_session) { create(:access_session, user: user2, product: product2) }
  let!(:card1) { create(:card, user: user1, product: product1, canceled_at: 1.month.ago) }
  let!(:card2) { create(:card, user: user2, product: product2, canceled_at: 1.day.ago) }

  let(:auth_headers) {
    extract_auth_params_from_sign_in_response_headers(response)
  }

  context "admin user" do
    before do
      sign_in(admin.email, admin.password)
    end

    describe "GET /cancellations" do
        it "renders a JSON response with the card cancellations" do
            get api_v1_reports_cancellations_path(from_date: 2.month.ago, to_date: Time.now),
                headers: auth_headers, as: :json
            expect(response).to have_http_status(:success)
            expect(response.content_type).to match(a_string_including("application/json"))
            expect(response_body["data"].size).to eq(2)
            expect(json_attributes(:canceled_at, index: 0).to_datetime.to_i).to eq(card2.canceled_at.to_datetime.to_i)
        end
    end
  end

  context "normal user" do
    before do
      sign_in(user1.email, user1.password)
    end

    describe "GET /cancellations" do
      it "renders a unauthorized response" do
        get api_v1_reports_cancellations_path(from_date: 2.month.ago, to_date: Time.now),
            headers: auth_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
