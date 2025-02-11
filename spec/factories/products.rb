FactoryBot.define do
  factory :product do
    association :brand
    name { Faker::Name.name  }
    price { "9.99" }
  end
end
