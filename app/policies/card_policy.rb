# frozen_string_literal: true

class CardPolicy < ApplicationPolicy
    include OnwerPolicy
    include Accessable

    def create?
        access?(product: @record.product)
    end

    def active?
        owner?
    end

    def cancel?
        owner?
    end
end
