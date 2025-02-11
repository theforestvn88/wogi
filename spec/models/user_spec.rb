require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:brands) }
  it { should have_many(:access_sessions) }
  it { should have_many(:products).through(:access_sessions) }
  it { should validate_numericality_of(:payout_rate).is_in(1..100) }
end
