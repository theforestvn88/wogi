require "rails_helper"

describe UpdateBrandStateService, type: :services do
    let!(:brand) { create(:brand) }
    let!(:product1) { create(:product, brand: brand) }
    let!(:product2) { create(:product, brand: brand) }

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
end
