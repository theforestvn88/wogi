class Card < ApplicationRecord
  belongs_to :user
  belongs_to :product

  enum :state, {
    issued: "issued",
    active: "active",
    canceled: "canceled"
  }
end
