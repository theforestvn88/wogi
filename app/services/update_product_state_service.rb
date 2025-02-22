# frozen_string_literal: true

class UpdateProductStateService
    Result = Struct.new(:success, :product, :errors)

    def update(product:, state:)
        result = nil
        begin
            ActiveRecord::Base.transaction do
                product.update!(state: state)
                if product.inactive?
                    product.cards.in_batches { |batch_of_cards|
                        batch_of_cards.update_all(state: Card.states[:canceled])
                    }
                end
            end
            
            # TODO: run refun-canceled-cards service
            # TODO: sync log
            # TODO: send-inform-email job
            result = Result.new(true, product, nil)
        rescue => e
            result = Result.new(false, product, e)
        end

        result
    end
end
