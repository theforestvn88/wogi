# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
    include OnwerPolicy
    
    def index?
        true
    end

    def show?
        # normal user should not allow to access inactive product
        @user.is_admin || @record.active?
    end

    def create?
        @user.is_admin
    end
end
