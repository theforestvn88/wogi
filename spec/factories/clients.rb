FactoryBot.define do
  factory :client do
    association :user
    payout_rate { "10" }
  end
end
