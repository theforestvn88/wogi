require 'rails_helper'

RSpec.describe Client, type: :model do
  it { should belong_to(:user) }
  it { should validate_numericality_of(:payout_rate).is_in(1..100) }
end
