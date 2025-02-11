class Client < ApplicationRecord
  belongs_to :user
  has_many :assignments
  
  validates_numericality_of :payout_rate, in: 1..100
end
