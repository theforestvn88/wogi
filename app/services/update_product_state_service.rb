# frozen_string_literal: true

class UpdateProductStateService
    Result = Struct.new(:success, :product, :errors)

    def update(product:, state:)
        if product.update(state: state)
            # TODO: sync log
            # TODO: send-inform-email job
            # TODO: update product's cards
            #
            Result.new(true, product, nil)
        else
            Result.new(false, product, product.errors)
        end
    rescue => e
        Result.new(false, product, e)
    end
end
