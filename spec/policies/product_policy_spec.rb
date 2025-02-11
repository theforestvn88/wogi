# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BrandPolicy, type: :policies do
    let(:admin_user) { create(:user, is_admin: true) }
    let(:normal_user) { create(:user) }
    let(:brand) { create(:brand, owner: admin_user) }
    let(:product) { create(:product, owner: admin_user, brand:) }

    context 'admin user' do
        subject { ProductPolicy.new(admin_user, brand) }

        it 'allow to access the products list' do
            expect(subject.index?).to be_truthy
        end

        it 'allow to access product detail' do
            expect(subject.show?).to be_truthy
        end

        it 'allow to create a product' do
            expect(subject.create?).to be_truthy
        end

        it 'allow to update a product' do
            expect(subject.update?).to be_truthy
        end

        it 'allow to update product state' do
            expect(subject.update_state?).to be_truthy
        end

        it 'allow to destroy a product' do
            expect(subject.destroy?).to be_truthy
        end
    end

    context 'normal user' do
        subject { ProductPolicy.new(normal_user, brand) }

        it 'allow to access the products list' do
            expect(subject.index?).to be_truthy
        end

        it 'allow to access product detail' do
            expect(subject.show?).to be_truthy
        end

        it 'disallow to create a product' do
            expect(subject.create?).to be_falsy
        end

        it 'disallow to update a product' do
            expect(subject.update?).to be_falsy
        end

        it 'disallow to update product state' do
            expect(subject.update_state?).to be_falsy
        end

        it 'disallow to destroy a product' do
            expect(subject.destroy?).to be_falsy
        end
    end
end
