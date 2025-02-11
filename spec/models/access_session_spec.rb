require 'rails_helper'

RSpec.describe AccessSession, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:product) }
end
