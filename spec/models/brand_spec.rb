require 'rails_helper'

RSpec.describe Brand, type: :model do
  it { should belong_to(:owner) }
  it { should validate_presence_of(:name) }
end
