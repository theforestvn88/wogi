class Client < ApplicationRecord
  belongs_to :user
  validates_numericality_of :payout_rate, in: 1..100
end
