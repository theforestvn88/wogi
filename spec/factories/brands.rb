FactoryBot.define do
  factory :brand, class: Brand do
    name { Faker::Name.name }
    user
  end
end
