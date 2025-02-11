FactoryBot.define do
  factory :product do
    association :brand
    association :owner, factory: :user
    name { Faker::Name.name  }
    price { "9.99" }
  end
end
