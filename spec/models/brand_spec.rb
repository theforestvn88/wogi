require 'rails_helper'

RSpec.describe Brand, type: :model do
  it { should belong_to(:owner) }
  it { should have_many(:products).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it {
    should define_enum_for(:state).
      with_values(
        active: 'active',
        inactive: 'inactive'
      ).
      backed_by_column_of_type(:enum)
  }
end
