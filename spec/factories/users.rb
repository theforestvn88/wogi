FactoryBot.define do
  factory :user do
    email    { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 10) }
    uid      { Faker::Internet.uuid }
    is_admin { false }
  end
end
