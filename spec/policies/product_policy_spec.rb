# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductPolicy, type: :policies do
    let!(:admin_user) { create(:user, is_admin: true) }
    let!(:accessable_user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:brand) { create(:brand, owner: admin_user) }
    let!(:product) { create(:product, owner: admin_user, brand:) }
    let!(:access_session) { create(:access_session, user: accessable_user, product:) }

    context 'admin user' do
        permissions :index?, :show?, :create?, :update?, :update_state?, :destroy? do
            it 'permit' do
                expect(ProductPolicy).to permit(admin_user, product)
            end
        end
    end

    context 'accessable user' do
        permissions :index?, :show? do
            it 'permit' do
                expect(ProductPolicy).to permit(accessable_user, product)
            end
        end

        permissions :create?, :update?, :update_state?, :destroy? do
            it 'not permit' do
                expect(ProductPolicy).not_to permit(accessable_user, product)
            end
        end
    end

    context 'normal user' do
        permissions :show? do
            it 'not permit' do
                expect(ProductPolicy).not_to permit(other_user, product)
            end
        end
    end
end
