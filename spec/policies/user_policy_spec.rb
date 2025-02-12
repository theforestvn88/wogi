# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policies do
    let(:admin_user) { create(:user, is_admin: true) }
    let(:normal_user) { create(:user) }

    context 'admin user' do
        permissions :create?, :destroy? do
            it 'permit' do
                expect(UserPolicy).to permit(admin_user, User)
            end
        end
    end

    context 'normal user' do
        permissions :create?, :destroy? do
            it 'not permit' do
                expect(UserPolicy).not_to permit(normal_user, User)
            end
        end
    end
end
