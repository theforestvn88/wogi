require "rails_helper"

describe UpdateProductStateService, type: :services do
    let!(:user) { create(:user) }
    let!(:product) { create(:product) }
    let!(:card1) { create(:card, product: product, user: user) }
    let!(:card2) { create(:card, product: product, user: user) }

    subject { UpdateProductStateService.new }

    before do
        subject.update(product:, state: "inactive")
    end

    it "update product state" do
        expect(product.reload.state).to eq("inactive")
    end

    it "cancel product's cards" do
        expect(card1.reload.state).to eq("canceled")
        expect(card2.reload.state).to eq("canceled")
    end
end
