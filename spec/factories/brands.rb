FactoryBot.define do
  factory :brand, class: Brand do
    name { Faker::Name.name }
    association :owner, factory: :user
  end
end
