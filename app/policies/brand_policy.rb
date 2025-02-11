# frozen_string_literal: true

class BrandPolicy < ApplicationPolicy
    include OnwerPolicy
    
    def index?
        @user.is_admin
    end

    def show?
        @user.is_admin
    end

    def create?
        @user.is_admin
    end
end
