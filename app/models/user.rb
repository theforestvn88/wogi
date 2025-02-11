class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :brands
  has_many :assignments
  has_many :products, through: :assignments

  validates_numericality_of :payout_rate, in: 1..100
end
