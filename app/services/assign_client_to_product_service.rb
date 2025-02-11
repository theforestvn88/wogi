# frozen_string_literal: true

class AssignClientToProductService
    Result = Struct.new(:success, :assignment, :errors)

    def exec(client_id:, product_id:, duration:)
        client = Client.find(client_id)
        # TODO: check client
        
        product = Product.find(product_id)
        raise ActiveRecord::RecordInvalid if product.inactive?

        assignment = Assignment.new(client: client, product: product, expired_at: Time.now.utc + duration)
        if assignment.save
            Result.new(true, assignment, nil)
        else
            Result.new(false, nil, assignment.errors)
        end
    rescue => e
        Result.new(false, nil, e)
    end
end
