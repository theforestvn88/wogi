require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it { should belong_to(:client) }
  it { should belong_to(:product) }
end
