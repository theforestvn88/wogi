class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :owner, class_name: "User", foreign_key: :user_id

  validates_presence_of :name

  enum :state, {
    active: "active",
    inactive: "inactive"
  }

  enum :currency, {
    usd: "USD",
    eur: "EUR", 
    jpy: "JPY", 
    gbp: "GBP", 
    cny: "CNY"
  }
end
