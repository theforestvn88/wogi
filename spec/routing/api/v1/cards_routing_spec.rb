require "rails_helper"

RSpec.describe Api::V1::CardsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/v1/cards").to route_to("api/v1/cards#create", format: :json)
    end

    it "routes to #avtive via PATCH" do
      expect(patch: "/api/v1/cards/1/active").to route_to("api/v1/cards#active", id: "1", format: :json)
    end

    it "routes to #cancel via PATCH" do
      expect(patch: "/api/v1/cards/1/cancel").to route_to("api/v1/cards#cancel", id: "1", format: :json)
    end
  end
end
