class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :brands
  has_many :access_sessions
  has_many :products, through: :access_sessions
  has_many :cards

  validates_numericality_of :payout_rate, in: 1..100
end
