# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
    include OnwerPolicy
    
    def index?
        true
    end

    def show?
        true
    end

    def create?
        @user.is_admin
    end
end
