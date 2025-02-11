FactoryBot.define do
  factory :assignment do
    association :client
    association :product
    expired_at { 1.hour.from_now }
  end
end
