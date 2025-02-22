require "rails_helper"

describe UpdateBrandStateService, type: :services do
    let!(:user) { create(:user) }
    let!(:brand) { create(:brand) }
    let!(:product1) { create(:product, brand: brand) }
    let!(:product2) { create(:product, brand: brand) }
    let!(:card11) { create(:card, product: product1, user: user) }
    let!(:card12) { create(:card, product: product1, user: user) }

    subject { UpdateBrandStateService.new }

    before do
        subject.update(brand: brand, state: "inactive")
    end

    it "update brand state" do
        expect(brand.reload.state).to eq("inactive")
    end

    it "update brand's products state" do
        expect(product1.reload.state).to eq("inactive")
        expect(product2.reload.state).to eq("inactive")
    end

    it "cancel product cards" do
        expect(card11.reload.state).to eq("canceled")
        expect(card12.reload.state).to eq("canceled")
    end
end
