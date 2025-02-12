class Card < ApplicationRecord
  belongs_to :user
  belongs_to :product

  enum :state, {
    issued: "issued",
    active: "active",
    canceled: "canceled"
  }

  scope :cancellations, ->(from_date:, to_date:) {
    where(canceled_at: from_date..to_date)
  }
end
