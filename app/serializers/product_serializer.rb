# frozen_string_literal: true

class ProductSerializer
    include JSONAPI::Serializer

    attributes :name, :price, :currency, :state, :created_at, :updated_at

    belongs_to :brand
  # belongs_to :owner, serializer: UserSerializer, id_method_name: :user_id
end
