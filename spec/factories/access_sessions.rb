FactoryBot.define do
  factory :access_session do
    association :user
    association :product
    expired_at { 1.hour.from_now }
  end
end
