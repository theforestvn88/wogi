# frozen_string_literal: true

class UpdateBrandStateService
    Result = Struct.new(:success, :brand, :errors)

    def update(brand:, state:)
        result = nil
        begin
            ActiveRecord::Base.transaction do
                # update this branch's products first
                update_product_state_service = UpdateProductStateService.new
                brand.products.find_in_batches { |batch|
                    batch.each { |product|
                        update_product_result = update_product_state_service.update(product: product, state: state)
                        raise ActiveRecord::Rollback unless update_product_result.success
                    }
                }

                # update the brand state
                brand.update!(state: state)

                # at this time all states are updated correct
                # TODO: log
                # TODO: send-inform-email job for the brand and all brand's products (in batch)

                result = Result.new(true, brand, nil)
            end
        rescue => e
            result = Result.new(false, brand, e)
        end

        result
    end
end
