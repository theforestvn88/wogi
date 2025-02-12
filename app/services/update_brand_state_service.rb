# frozen_string_literal: true

class UpdateBrandStateService
    Result = Struct.new(:success, :brand, :errors)

    def update(brand:, state:)
        if brand.update(state: state)
            # TODO: sync log
            # TODO: send-inform-email job
            # update this branch's products
            update_product_state_service = UpdateProductStateService.new
            brand.products.find_in_batches { |batch|
                batch.each { |product|
                    update_product_state_service.update(product: product, state: state)
                }
            }
            Result.new(true, brand, [])
        else
            Result.new(false, brand, brand.errors)
        end
    rescue => e
        Result.new(false, brand, e)
    end
end
