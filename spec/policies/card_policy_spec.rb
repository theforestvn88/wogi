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
        subject { CardPolicy.new(owner, card) }

        it 'allow to create a card' do
            expect(subject.create?).to be_truthy
        end

        it 'allow to active a card' do
            expect(subject.active?).to be_truthy
        end

        it 'allow to cancel card' do
            expect(subject.cancel?).to be_truthy
        end
    end

    context 'other user' do
        subject { CardPolicy.new(other_user, card) }

        it 'disallow to create a card' do
            expect(subject.create?).to be_falsy
        end

        it 'disallow to active the card' do
            expect(subject.active?).to be_falsy
        end

        it 'disallow to cancel the card' do
            expect(subject.cancel?).to be_falsy
        end
    end
end
