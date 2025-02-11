# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
    include OnwerPolicy
    include Accessable
    
    def index?
        true
    end

    class Scope < ApplicationPolicy::Scope
        def resolve
          if user.is_admin
            scope.all
          else
            user.products
          end
        end
      end

    def show?
        # normal user should not allow to access inactive or not-accessable product
        @user.is_admin || access?
    end

    def create?
        @user.is_admin
    end
end
