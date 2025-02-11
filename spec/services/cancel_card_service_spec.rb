require "rails_helper"

describe CancelCardService, type: :services do
    let!(:admin_user) { create(:user, is_admin: true) }
    let!(:owner) { create(:user) }
    let!(:brand) { create(:brand, owner: admin_user) }
    let!(:product) { create(:product, owner: admin_user, brand:) }
    let!(:access_session) { create(:access_session, user: owner, product:) }
    let!(:card) { create(:card, user: owner, product: product) }

    subject { CancelCardService.new }

    before do
        subject.exec(card)
    end

    it "change state to canceled" do
        result = subject.exec(card)
        expect(card.reload.state).to eq("canceled")
    end

    it "set canceled_at" do
        expect(card.reload.canceled_at).not_to be_nil
    end
end
