# frozen_string_literal: true

require "rails_helper"

describe "auth session", type: :request do
    let!(:password) { 'thisispassword' }
    let!(:user) { create(:user, password:) }

    describe "POST /api/v1/auth/sign_in create new session" do
        context "with valid params" do
            before do
                post user_session_path, params: { email: user.email, password: }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
            end

            it "return success" do
                expect(response).to be_successful
            end

            it 'returns the user' do
                expect(response_body[:data][:id]).to eq(user.id)
                expect(response_body[:data][:email]).to eq(user.email)
                expect(response_body[:data][:uid]).to eq(user.uid)
                expect(response_body[:data][:provider]).to eq('email')
              end

              it 'returns a valid client and access token' do
                token = response.header['access-token']
                client = response.header['client']
                expect(user.reload).to be_valid_token(token, client)
              end
        end

        context "with invalid params" do
            it 'returns to be unauthorized' do
                post user_session_path, params: { email: user.email, password: 'wrong password' }, as: :json
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end

    describe 'DELETE /api/v1/auth/sign_out destroy session' do
        context "with valid token" do
            it 'return success' do
                delete destroy_user_session_path, headers: user.create_new_auth_token, as: :json
                expect(response).to be_successful
            end

            it 'delete user token' do
                token = user.create_new_auth_token
                expect {
                    delete destroy_user_session_path, headers: token, as: :json
                }.to change { user.reload.tokens.size }.by -1
            end
        end

        context 'with invalid token' do
            it 'return not_found' do
                delete destroy_user_session_path, headers: {}, as: :json
                expect(response).to have_http_status(:not_found)
            end
        end
    end
end
