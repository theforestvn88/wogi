# frozen_string_literal: true

class BrandSerializer
  include JSONAPI::Serializer

  attributes :name, :state, :created_at, :updated_at
  belongs_to :owner, serializer: UserSerializer, id_method_name: :user_id
end
