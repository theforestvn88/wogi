FactoryBot.define do
  factory :card do
    association :user
    association :product
    activation_number { Faker::IdNumber.valid }
    purchase_pin { Faker::IdNumber.valid }
  end
end
