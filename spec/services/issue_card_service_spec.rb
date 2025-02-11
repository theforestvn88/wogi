require "rails_helper"

describe IssueCardService, type: :services do
    let!(:admin_user) { create(:user, is_admin: true) }
    let!(:owner) { create(:user) }
    let!(:brand) { create(:brand, owner: admin_user) }
    let!(:product) { create(:product, owner: admin_user, brand:) }
    let!(:access_session) { create(:access_session, user: owner, product:) }
    let!(:card) { create(:card, user: owner, product: product) }

    subject { IssueCardService.new }

    it "create activation_number" do
        expected_activation_number = "123456"
        allow(SecureRandom).to receive(:hex).and_return(expected_activation_number)

        result = subject.exec(card)
        expect(result.success).to be_truthy
        expect(card.reload.activation_number).to eq(expected_activation_number)
    end

    it "create puchase pin" do
        expected_purchase_pin = "111111"
        allow_any_instance_of(Object).to receive(:rand).and_return(1)

        result = subject.exec(card)
        expect(result.success).to be_truthy
        expect(card.reload.purchase_pin).to eq(expected_purchase_pin)
    end
end
