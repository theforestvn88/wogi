require "rails_helper"

RSpec.describe Api::V1::AccessSessionsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/v1/access_sessions").to route_to("api/v1/access_sessions#create", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/access_sessions/1").to route_to("api/v1/access_sessions#destroy", id: "1", format: :json)
    end
  end
end
