require "rails_helper"

describe AddCustomFieldService, type: :services do
    let!(:admin_user) { create(:user, is_admin: true) }
    let!(:owner) { create(:user) }
    let!(:customable) { create(:brand, owner: admin_user) }
    let!(:inactive_customable) { create(:brand, owner: admin_user, state: :inactive) }

    subject { AddCustomFieldService.new }


    context "active customable" do
        it "success" do
            result = subject.add({
                customable_id: customable.id,
                customable_type: customable.class.name,
                field_type: "TEXT",
                field_name: "Description"
            })

            expect(result.success).to be_truthy
        end
    end

    context "inactive customable" do
        it "failed" do
            result = subject.add({
                customable_id: inactive_customable.id,
                customable_type: inactive_customable.class.name,
                field_type: "TEXT",
                field_name: "Description"
            })

            expect(result.success).to be_falsy
        end
    end

    context "already have more than 5 fields" do
        it "failed" do
            5.times {
                subject.add({
                    customable_id: customable.id,
                    customable_type: customable.class.name,
                    field_type: "TEXT",
                    field_name: "Description"
                })
            }

            result = subject.add({
                customable_id: customable.id,
                customable_type: customable.class.name,
                field_type: "TEXT",
                field_name: "Description"
            })

            expect(result.success).to be_falsy
        end
    end
end
