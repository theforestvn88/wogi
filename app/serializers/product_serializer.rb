# frozen_string_literal: true

class ProductSerializer
    include JSONAPI::Serializer
  
    attributes :name, :price, :currency, :state, :created_at, :updated_at
end
  