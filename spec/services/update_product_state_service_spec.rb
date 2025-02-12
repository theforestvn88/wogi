require "rails_helper"

describe UpdateProductStateService, type: :services do
    let!(:product) { create(:product, state: "inactive") }

    subject { UpdateProductStateService.new }

    before do
        subject.update(product:, state: "active")
    end

    it "update brand state" do
        expect(product.reload.state).to eq("active")
    end

    it "update product's cards state" do
    end
end
