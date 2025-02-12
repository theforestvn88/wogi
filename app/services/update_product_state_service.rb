# frozen_string_literal: true

class UpdateProductStateService
    Result = Struct.new(:success, :product, :errors)

    def update(product:, state:)
        result = nil
        begin
            ActiveRecord::Base.transaction do
                product.cards.find_in_batches { |batch|
                    batch.each { |card|
                        # TODO: update this product's cards first
                        # raise any error
                    }
                }

                # update the product state
                product.update!(state: state)
                # TODO: sync log
                # TODO: send-inform-email job
                result = Result.new(true, product, nil)
            end
        rescue => e
            result = Result.new(false, product, e)
        end

        result
    end
end
