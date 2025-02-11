# frozen_string_literal: true

module Accessable
    private

        def access?(product: @record)
            @access ||= product.active? && AccessSession.exists?(user_id: @user.id, product_id: product.id)
        end
end
