# frozen_string_literal: true

class BrandPolicy < ApplicationPolicy
    def index?
        @user.is_admin
    end

    def show?
        @user.is_admin
    end

    def create?
        brand_owner?
    end

    def update?
        brand_owner?
    end

    def update_state?
        brand_owner?
    end

    def destroy?
        brand_owner?
    end

    private

        def brand_owner?
            @user.id == @record.user_id
        end
end
