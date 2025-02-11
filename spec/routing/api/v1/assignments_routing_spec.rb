require "rails_helper"

RSpec.describe Api::V1::AssignmentsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/v1/assignments").to route_to("api/v1/assignments#create", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/assignments/1").to route_to("api/v1/assignments#destroy", id: "1", format: :json)
    end
  end
end
