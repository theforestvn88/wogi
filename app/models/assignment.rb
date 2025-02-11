class Assignment < ApplicationRecord
  belongs_to :client
  belongs_to :product

  attr_accessor :duration
end
