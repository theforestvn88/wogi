class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many   :assignments
  has_many   :clients, through: :assignments

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

  validates_presence_of :name
  validates_numericality_of :price, greater_than: 0
end
