class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many   :access_sessions
  has_many   :clients, through: :access_sessions, source: :user

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
