# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
    include OnwerPolicy
    
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
        @user.is_admin || (@record.active? && accessable?)
    end

    def create?
        @user.is_admin
    end

    private

        def accessable?
            @accessable ||= AccessSession.exists?(user_id: @user.id, product_id: @record.id)
        end
end
