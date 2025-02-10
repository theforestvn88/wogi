# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BrandPolicy, type: :policies do
    let(:admin_user) { create(:user, is_admin: true) }
    let(:normal_user) { create(:user) }
    let(:brand) { create(:brand, owner: admin_user) }

    context 'admin user' do
        subject { BrandPolicy.new(admin_user, brand) }

        it 'allow to access the brands list' do
            expect(subject.index?).to be_truthy
        end

        it 'allow to access brand detail' do
            expect(subject.show?).to be_truthy
        end

        it 'allow to create a brand' do
            expect(subject.create?).to be_truthy
        end

        it 'allow to update a brand' do
            expect(subject.update?).to be_truthy
        end

        it 'allow to destroy a brand' do
            expect(subject.destroy?).to be_truthy
        end
    end

    context 'normal user' do
        subject { BrandPolicy.new(normal_user, brand) }

        it 'disallow to access the brands list' do
            expect(subject.index?).to be_falsy
        end

        it 'disallow to access brand detail' do
            expect(subject.show?).to be_falsy
        end

        it 'disallow to create a brand' do
            expect(subject.create?).to be_falsy
        end

        it 'disallow to update a brand' do
            expect(subject.update?).to be_falsy
        end

        it 'disallow to destroy a brand' do
            expect(subject.destroy?).to be_falsy
        end
    end
end
