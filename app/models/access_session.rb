class AccessSession < ApplicationRecord
  belongs_to :user
  belongs_to :product

  attr_accessor :duration
end
