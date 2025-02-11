# frozen_string_literal: true

class ClientPolicy < ApplicationPolicy
    def create?
        @user.is_admin
    end

    def destroy?
        @user.is_admin
    end
end
