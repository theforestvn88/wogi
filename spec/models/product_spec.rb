require 'rails_helper'
require 'models/customable_spec'

RSpec.describe Product, type: :model do
  it { should belong_to(:brand) }
  it { should belong_to(:owner) }
  it { should have_many(:access_sessions).dependent(:destroy) }
  it { should have_many(:clients).through(:access_sessions).source(:user) }
  it { should have_many(:cards) }
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it {
    should define_enum_for(:state).
      with_values(
        active: 'active',
        inactive: 'inactive'
      ).
      backed_by_column_of_type(:enum)
  }
  it {
    should define_enum_for(:currency).
      with_values(
        usd: 'USD',
        eur: 'EUR',
        jpy: 'JPY',
        gbp: 'GBP',
        cny: 'CNY'
      ).
      backed_by_column_of_type(:enum)
  }

  it_behaves_like 'customable'
end
