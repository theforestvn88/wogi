# frozen_string_literal: true

class UpdateBrandStateService
    Result = Struct.new(:success, :brand, :errors)

    def update(brand:, state:)
        result = nil

        begin
            ActiveRecord::Base.transaction do
                brand.update!(state: state)
                brand.products.in_batches { |batch_of_products|
                    batch_of_products.update_all(state: state)
                    if brand.inactive?
                        Card.where(product_id: batch_of_products.pluck(:id)).update_all(state: Card.states[:canceled])
                    end
                }             
            end
            
            # TODO: run refun-canceled-cards service
            # TODO: log
            # TODO: send-inform-email job for the brand and all brand's products (in batch)

            result = Result.new(true, brand, nil)
        rescue => e
            result = Result.new(false, brand, e)
        end

        result
    end
end
