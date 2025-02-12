require 'rails_helper'

RSpec.describe CustomField, type: :model do
  it { should belong_to(:customable) }
  it { should validate_presence_of(:field_name) }
  it { should validate_presence_of(:field_type) }
end
