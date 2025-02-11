require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:brand) }
  it { should validate_presence_of(:name) }
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
end
