require "rails_helper"

RSpec.describe Api::V1::ClientsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/v1/clients").to route_to("api/v1/clients#create", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/clients/1").to route_to("api/v1/clients#destroy", id: "1", format: :json)
    end
  end
end
