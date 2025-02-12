# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policies do
    let(:admin_user) { create(:user, is_admin: true) }
    let(:user) { create(:user) }

    context 'admin user' do
        subject { UserPolicy.new(admin_user, User) }

        it 'allow to create a client' do
            expect(subject.create?).to be_truthy
        end

        it 'allow to destroy a client' do
            expect(subject.destroy?).to be_truthy
        end
    end

    context 'normal user' do
        subject { UserPolicy.new(user, User) }

        it 'disallow to create a client' do
            expect(subject.create?).to be_falsy
        end

        it 'disallow to destroy a client' do
            expect(subject.destroy?).to be_falsy
        end
    end
end
