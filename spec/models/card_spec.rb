require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:product) }
  it {
    should define_enum_for(:state).
      with_values(
        issued: 'issued',
        active: 'active',
        canceled: 'canceled'
      ).
      backed_by_column_of_type(:enum)
  }
end
