# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BrandPolicy do
    let(:admin_user) { create(:user, is_admin: true) }
    let(:normal_user) { create(:user) }
    let(:brand) { create(:brand, owner: admin_user) }

    context 'admin user' do
        permissions :index?, :show?, :create?, :update?, :update_state?, :destroy? do
            it 'permit' do
                expect(BrandPolicy).to permit(admin_user, brand)
            end
        end
    end

    context 'normal user' do
        permissions :index?, :show?, :create?, :update?, :destroy? do
            it 'not permit' do
                expect(BrandPolicy).not_to permit(normal_user, brand)
            end
        end
    end
end
