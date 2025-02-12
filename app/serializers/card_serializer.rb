# frozen_string_literal: true

class CardSerializer
    include JSONAPI::Serializer

    attributes :user_id, :product_id, :state, :canceled_at
end
