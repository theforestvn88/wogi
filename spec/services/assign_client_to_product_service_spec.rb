require "rails_helper"

describe AssignClientToProductService, type: :services do
    let(:user) { create(:user) }
    let(:client) { create(:client, user: user) } 
    let!(:brand) { create(:brand) }
    let!(:active_product) { create(:product, brand: brand, state: :active) }
    let!(:inactive_product) { create(:product, brand: brand, state: :inactive) }

    subject { AssignClientToProductService.new }

    context "active product" do
        it "allow to assign" do
            result = subject.exec(client_id: client.id, product_id: active_product.id, duration: 1.month)
            expect(result.success).to be_truthy
        end

        it "prevent duplicate" do
            subject.exec(client_id: client.id, product_id: active_product.id, duration: 1.month)
            result = subject.exec(client_id: client.id, product_id: active_product.id, duration: 1.month)
            expect(result.success).to be_falsy
        end
    end

    context "inactive product" do
        it "disallow to assign" do
            result = subject.exec(client_id: client.id, product_id: inactive_product.id, duration: 1.month)
            expect(result.success).to be_falsy
        end
    end
end
