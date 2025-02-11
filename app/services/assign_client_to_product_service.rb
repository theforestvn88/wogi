# frozen_string_literal: true

class AssignClientToProductService
    Result = Struct.new(:success, :access_session, :errors)

    def exec(user_id:, product_id:, duration:)
        client = User.find(user_id)
        # TODO: check client
        
        product = Product.find(product_id)
        raise ActiveRecord::RecordInvalid if product.inactive?

        access_session = AccessSession.new(user: client, product: product, expired_at: Time.now.utc + duration)
        if access_session.save
            Result.new(true, access_session, nil)
        else
            Result.new(false, nil, access_session.errors)
        end
    rescue => e
        Result.new(false, nil, e)
    end
end
