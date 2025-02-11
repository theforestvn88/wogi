# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
    def create?
        @user.is_admin
    end

    def destroy?
        @user.is_admin
    end
end
