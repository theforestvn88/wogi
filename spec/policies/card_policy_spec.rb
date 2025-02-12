# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardPolicy, type: :policies do
    let!(:admin_user) { create(:user, is_admin: true) }
    let!(:owner) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:brand) { create(:brand, owner: admin_user) }
    let!(:product) { create(:product, owner: admin_user, brand:) }
    let!(:access_session) { create(:access_session, user: owner, product:) }
    let!(:card) { create(:card, user: owner, product: product) }

    context 'owner user' do
        permissions :create?, :active?, :cancel? do
            it 'permit' do
                expect(CardPolicy).to permit(owner, card)
            end
        end
    end

    context 'other user' do
        permissions :create?, :active?, :cancel? do
            it 'not permit' do
                expect(CardPolicy).not_to permit(other_user, card)
            end
        end
    end
end
